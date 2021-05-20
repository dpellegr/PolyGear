// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
// Dario Pellegrini, Padova (IT) 2019/8
// <pellegrini.dario@gmail.com> 

// Follows the formalism explained in the open access paper:
// https://www.sciencedirect.com/science/article/pii/S0263224118310315

include <PolyGearUtils.scad>

function phi_b1(r0,rb,s0,flank,type) = 
   flank*r0*sqrt(1-pow(rb/r0,2))/rb*r2d - flank*acos(rb/r0) + type*flank*s0/2/r0*r2d;
   //                                                         ^^^ sgn(yy)*acos(xx/r0)

function phi_bi(i,n,r0,rb,s0,flank,type) = constrain_angle( type*phi_b1(r0,rb,s0,flank,type) + (i-1)*360/n);

function prof(at, z, i, n, r0, rb, s0, c, flank, type) = 
  let( r=rb/cos(at), theta=phi_bi(i,n,r0,rb,s0,flank,type) + c*z - flank*inv(at),
      x = r*cos(theta),
      y = r*sin(theta))
  [x,y,z];

function linearized_prof(t, z, i, n, r0, rb, s0, c, flank, type) = 
  prof(acos(1/t), z, i, n, r0, rb, s0, c, flank, type);

function f_r0_add( r0, m, add) = r0 + m*(1 + add);
function f_r0_ded( r0, m, ded) = r0 - m*(1+0.167)*(1 + ded);

function gear_section (
//basic options
  n = 16, // number of teeth
  m = 1,  // module
  z = 0,  // thickness
  pressure_angle = 20,
  helix_angle    =  0, // the sign gives the handiness
  backlash       =  0, // in module units
//advanced options
  add = 0, // add to addendum
  ded = 0, // subtract to the dedendum
  x   = 0, // profile shift
  type= 1, //-1: internal 1: external. In practice it flips the sing of the profile shift
//finesse options
  $fn=max($fn, 5)
) = 
let(
  a0 = pressure_angle,
  b0 = helix_angle,
  
  // derived parameters
  rb = n*m / (2*sqrt( pow(tan(a0),2) + pow(cos(b0*0),2))), //b0 forced to zero to drop the radius dependency on the helix angle
  bb = acos(cos(a0)*sqrt(pow(tan(a0),2)+pow(cos(b0),2))),
  c  = sign(b0) * tan(bb)/rb * r2d,
  r0 = n*m/(2*cos(b0*0)),                                  //b0 forced to zero to drop the radius dependency on the helix angle
  s0 = r0*PI/n + 2*x*m*tan(a0) - backlash*m,

  // addendum and dedendum
  ra0 = f_r0_add(r0, m, add),
  rd0 = f_r0_ded(r0, m, ded),

  // override ra in case the tips self cross
  minimum_tip_width = 0.1, //a bit above zero to avoid overlapping vertexes and degenerated facets
  ra = let(zz=0, ii=1) 
    linearized_prof(ra0/rb, zz, ii, n, r0, rb, s0, c, flank=-1, type=type).y < -minimum_tip_width/2 
      ? ra0
      : lookup( -minimum_tip_width/2, [ for ( t = linspace( 1, ra0/rb, 100) )
          [linearized_prof(t, zz, ii, n, r0, rb, s0, c, flank=-1, type=type).y, t*rb]
        ]),
  // override rd in case the bases self cross
  minimum_tip_angle = atan(minimum_tip_width/2/rd0),
  rd = let(zz=0, ii=2,
    theta = cartesian2polar(linearized_prof(max(1,rd0/rb), zz, ii, n, r0, rb, s0, c, flank=-1, type=type)).y - 180/n
  ) theta > minimum_tip_angle
      ? rd0
      : lookup( minimum_tip_angle, [ for ( t = linspace( max(1,rd0/rb), ra/rb, 100) )
          [cartesian2polar(linearized_prof(t, zz, ii, n, r0, rb, s0, c, flank=-1, type=type)).y - 180/n, t*rb]
        ])
)
rotate_lst( flatten([
  for (i=[1:n]) concat( [
      for (flank=[-1,1]) for (t= flank<0 ? linspace(max(1,rd/rb),ra/rb,$fn) : linspace(ra/rb,max(1,rd/rb),$fn)) 
        linearized_prof(t, z, i, n, r0, rb, s0, c, flank=flank, type=type)
    ],
    let( t1=phi_bi(  i, n, r0, rb, s0, 1,type) + c*z,
         t2=phi_bi(1+i, n, r0, rb, s0,-1,type) + c*z,
         tm=(t1+t2)/2 )    
    p2p3(
      rd < rb
        ? make_arc_no_extremes(polar(rb, t1), polar(rd,tm), polar(rb, t2), n=2*round($fn/3)+1)
        : [polar(rd, tm)],
      z
    )
  )
]), $fn);
      
// helpers for the generation of the polyhedron faces

function split_quad(q, flip=undef) = is_undef(flip) || flip==0 || flip==false ?
  [[q[0], q[1], q[2]], [q[0],q[2],q[3]]] :
  [[q[0], q[2], q[1]], [q[0],q[3],q[2]]] ;

function make_side_faces(npts, nlayers) = flatten([
   for (j=[0:nlayers-2]) for(i=[0:npts-1])
     split_quad([i+j*npts, (i+1)%npts+j*npts, (i+1)%npts+(j+1)*npts, i+(j+1)*npts], flip=1)
]);

function make_cap_faces(Npts, Nlayers, Nteeth) = let (
  Nppt = Npts/Nteeth,
  apex = (Nppt-1)/2,
  l = Npts*(Nlayers-1)
) concat( 
  flatten( [for (t=[0:Nteeth-1]) for (i=[0:apex-1]) let(s=t*Nppt+Npts)
    split_quad([(s+i)%Npts, (s+i+1)%Npts, (s-i-2)%Npts, (s-i-1)%Npts])]), 
  flatten( [for (t=[0:Nteeth-1]) for (i=[0:apex-1]) let(s=t*Nppt+Npts)
    split_quad([(s+i)%Npts + l, (s+i+1)%Npts + l, (s-i-2)%Npts + l, (s-i-1)%Npts + l], flip=1)]),
  [            [for (i=[apex:Nppt:Npts]) i]],
  [reverse_lst([for (i=[apex:Nppt:Npts]) i+l])]
);
