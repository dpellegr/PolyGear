// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
// Dario Pellegrini, Padova (IT) 2019/8
// <pellegrini.dario@gmail.com> 

include <PolyGearBasics.scad>

////////////////////////////////////////

module PGDemo() {
  $t=-$t;
  bevel_pair(w=5, n1=17, n2=13, only=0, axis_angle=60, helix_angle = zerol(40));

  Rz(360*$t/17) Tz(-10) 
    spur_gear(n=17, pressure_angle=20, z=10, chamfer=30, helix_angle = [ for (x=linspace(-1,1,11)) exp(-abs(x))*50*sign(x) ]);

  Tz(-10) Rz(-360/17*2) Ty((13+17)/2) Mx() Rz(360*$t/13) 
    spur_gear(n=13, pressure_angle=20, z=10, chamfer=30, helix_angle = [ for (x=linspace(-1,1,11)) exp(-abs(x))*50*sign(x) ]);

  Rz(360*$t/17) Mz() Cy(h=10, r=3, C=0, $fn=17);
}

PGDemo();

////////////////////////////////////////

function constant(helix=45, $fn=9) = lst_repeat(helix, $fn);
function zerol(helix=30, $fn=9) = linspace(-helix, helix, $fn);
function spiral(helix=30, $fn=9) = linspace(-helix, 0, $fn);
function herringbone(helix=30, $fn=9) = let(n=floor($fn/2)) 
  concat( lst_repeat(-helix, n),[0],lst_repeat(helix, n) );

module spur_gear(
//basic options
  n = 16,  // number of teeth
  m = 1,   // module
  z = 1,   // thickness
  pressure_angle = 20,
  helix_angle    = 0,   // the sign gives the handiness, can be a list
  backlash       = 0.1, // in module units
//shortcuts
  w  = undef, //overrides z when defined
  a0 = undef, //overrides pressure angle when defined
  b0 = undef, //overrides helix angle when defined
  tol= undef, //overrides backlash
//advanced options
  chamfer       = 0, // degrees, should be in [0:90[
  chamfer_shift = 0, // from the pitch radius in module units
  add = 0, // add to addendum
  ded = 0, // subtract to the dedendum
  x   = 0, // profile shift
  type= 1, //-1: internal 1: external. In practice it flips the sing of the profile shift
//finesse options
  $fn=5,     // tooth profile subdivisions
) {
  z = is_undef(w) ? z : w;
  pressure_angle = is_undef(a0) ? pressure_angle : a0;
  helix_angle    = let(hlx = is_undef(b0) ? helix_angle : b0) 
                     is_list(hlx) ? hlx : [hlx, hlx];
  backlash       = is_undef(tol) ? backlash : tol; // in module units
  fz = len(helix_angle);
  pts = flatten([ for (i=[0:fz-1]) let(zi= z*i/(fz-1) - z/2) gear_section(
    n=n, m=m, z=zi,
    pressure_angle = pressure_angle, helix_angle = helix_angle[i], backlash = backlash,
    add = add, ded = ded, x = x, type = type, $fn=$fn
  )]);
  Nlay = len(pts)/fz;
  side = make_side_faces(Nlay, fz);
  caps = make_cap_faces(Nlay, fz, n);
  if (chamfer == 0) polyhedron(points=pts, faces=concat(side, caps));
  else render(10) I() {
    polyhedron(points=pts, faces=concat(side, caps));
    MKz() let(t = chamfer, rc = m*n/2 + m*chamfer_shift) 
      Cy(r1=z/2/tan(t)+rc, r2=0, h=rc*tan(t)+z/2, C=0, $fn=n);
  }
}

module bevel_gear(
//basic options
  n = 16,  // number of teeth
  m = 1,   // module
  w = 1,   // tooth width
  cone_angle     = 45,
  pressure_angle = 20,
  helix_angle    = 0,   // the sign gives the handiness
  backlash       = 0.1, // in module units
//shortcuts
  z  = undef, //gear thickness, overrides w when defined
  a0 = undef, //overrides pressure angle when defined
  b0 = undef, //overrides helix angle when defined
  tol= undef, //overrides backlash
//advanced options
  add = 0, // add to addendum
  ded = 0, // subtract to the dedendum
  x   = 0, // profile shift
  type= 1, //-1: internal 1: external. In practice it flips the sing of the profile shift
//finesse options
  $fn=max($fn, 5),     // tooth profile subdivisions
) {
  z              = is_undef(z) ? w*cos(cone_angle) : z;
  pressure_angle = is_undef(a0) ? pressure_angle : a0;
  helix_angle    = let(hlx = is_undef(b0) ? helix_angle : b0) 
                     is_list(hlx) ? hlx : [hlx/2, hlx/2];
  backlash       = is_undef(tol) ? backlash : tol; // in module units
  fz = len(helix_angle);
  r0 = m*n/2;
  H0 = r0/tan(cone_angle);
  pts = flatten([ for (i=[0:fz-1]) let(wi=i*w/fz, zi=i*z/(fz-1), H=H0-zi, R=H/cos(cone_angle))
    Tzpts ( 
      fold_on_sphere(
        Tzpts ( 
          gear_section(
            n = n, m = m*H/H0, z = wi - w/2, // here z is used to compute the helix...
            pressure_angle = pressure_angle, helix_angle = helix_angle[i], backlash = backlash,
            add = add, ded = ded, x = x, type = type, $fn=$fn
          ), -wi + w/2 // ...and here we bring back the section to z=0
        ), R, [0,0,H]
      ), zi
    )
  ]);
  Nlay = len(pts)/fz; //points per layer
  side = make_side_faces(Nlay, fz);
  caps = make_cap_faces(Nlay, fz, n);
  polyhedron(points=pts, faces=concat(side, caps));
}

function bevel_gear_z_offset(n, m=1, cone_angle=45, ded=0) =
  let(r0 = m*n/2,
      r0_ded = f_r0_ded( r0, m, ded),
      R = r0/sin(cone_angle),
      ded_angle = (r0-r0_ded)/R*r2d,
      z = R*(cos(cone_angle-ded_angle)-cos(cone_angle))
  ) -z;

module bevel_pair(
//basic options
  n1 = 16,  // number of teeth
  n2 = 16,  // number of teeth
  m = 1,   // module
  w = 1,   // tooth width
  axis_angle     = 90,
  pressure_angle = 0,
  helix_angle    = 0,  // the sign gives the handiness
  backlash       = 0.1,// in module units
  only           = 0,  // build only gear 1 or 2 (0 for both)
//shortcuts
  a0 = undef, //overrides pressure angle when defined
  b0 = undef, //overrides helix angle when defined
  tol= undef, //overrides backlash
//advanced options
  add = 0, // add to addendum
  ded = 0, // subtract to the dedendum
  x   = 0, // profile shift
  type= 1, //-1: internal 1: external. In practice it flips the sing of the profile shift
//finesse options
  $fn=max($fn, 5)     // tooth profile subdivisions
){
  a = axis_angle;
  b = 90-a;
  r1 = m*n1/2;
  r2 = m*n2/2;
  c1 = (b==0) ? 
    atan(r1/r2) :
    let( xx = r1 + r2/sin(b), yy = xx*tan(b)) 
      assert(yy>0, "Internal crown not implemented") 
      atan(r1/yy);
  c2 = a - c1;
  gear2x = r1 + r2*cos(a);
  gear2z = r2 * sin(a);

  pressure_angle = is_undef(a0) ? pressure_angle : a0;
  helix_angle    = is_undef(b0) ? helix_angle : b0; 
  backlash       = is_undef(tol) ? backlash : tol; 

  if (only != 2) {
    Rz(360*$t/n1)
    bevel_gear(
      n = n1,
      m = m,
      w = w,
      cone_angle     = c1,
      pressure_angle = pressure_angle,
      helix_angle    = helix_angle,
      backlash       = backlash,
    //advanced options
      add = add,
      ded = ded,
      x = x,
      type = type,
    //finesse options
      $fn=$fn
    );
  }
  
  if (only != 1) {
    move = only==2 ? 0 : 1;
    T(-gear2x*move, 0, gear2z*move) Ry(a*move) Rz(360/n2/2*move) Mx() 
    Rz(360*$t/n2)
    bevel_gear(
      n = n2,
      m = m,
      w = w,
      cone_angle     = c2,
      pressure_angle = pressure_angle,
      helix_angle    = helix_angle,
      backlash       = backlash,
    //advanced options
      add = add,
      ded = ded,
      x = -x,
      type = type,
    //finesse options
      $fn=$fn
    );
  }
}
