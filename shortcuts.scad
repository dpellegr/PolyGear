// ShortCuts.scad 
// Autor: Rudolf Huttary, Berlin 2015
// Update: Dario Pellegrini, Padova (IT) 2019/8
//
//$fn = 60; 

show_examples(); 

module show_examples()
	place_in_rect(30, 30)
	{
		Cy(h = 10); 
		CyH(h = 10); 
		CyH(h = 10, w = 30); 
		CyS(h = 10); 
		CyS(h = 10, w1 = 25, w2 = 75); 
		Cu(10); 
		Ri(h = 10); 
		RiH(h = 10); 
		RiS(h = 10, w1 = 10); 
		RiS(h = 10, w1 = 30, w2 = 300); 
		Sp(); 
		SpH(10, 30, 30); 
	}
help(); 


module help() help_shortcuts(); 
  
module help_shortcuts()
{
  h = "<br><b>shortcuts.scad<br> by Rudolf Huttary</b>, 2018.01<br> 
  help(): shows this help<br>
  help_shortcuts(): shows this help<br>
  show_examples(): shows some examples<br>
  place_in_rect(): places children objects in grid<br>
  <b>Transformations:</b><br>
   T(x=0, y=0, z=0): translation by [x,y,z]; alternatively T([x,y,z]) allowed <br>
   Tx(x=0) , Ty(y=0), Tz(z=0): translate along annoted axis<br>
   R(x=0, y=0, z=0): rotation by [x,y,z]; alternatively R([x,y,z]) allowed <br>
   Rx(x=0) , Ry(y=0), Rz(z=0) rotate around noted axis<br>
   S(x=1, y=1, z=1): scale by [x,y,z]; alternatively S([x,y,z]) allowed <br>
   Sx(x=1) , Sy(y=1), Sz(z=1): scale along noted axis<br>
   Skew(x=0, y=0, z=0, a=0, b=0, c=0): skew operation<br>
   skew(x=0, y=0, z=0, a=0, b=0, c=0): skew operation<br>
   SkewX(x=0), SkX(x=0), SkewY(y=0), SkY(y=0), SkewZ(z=0), SkZ(z=0): skew along axis <br>
  <b>Logical</b><br>
   difference :  D()<br>
   union :  U()<br>
   intersection : I()<br>
  <b>Useful</b><br>
   rotN(r=10, N=4, offs=0, M=undef): operator places N instances of children around circle with radius r <br>
   forX(dx = 10, N=4): operator places N instances of children centered along X with instance distance dx<br>
   forY(dy = 10, M=4): operator places M instances of children centered along Y with instance distance dy<br>
   forZ(dz = 10, M=4): operator places M instances of children centered along Z with instance distance dz<br>
   forXY(dx, N=4, dy = 10, M=4): operator places NxM instances of children in centered XY grid with width [dx, dy]<br>
   C(r,g,b,t) or C(string,t): color operator; alternatively C([r,g,b], t) and C(\"colorname\",t) allowed  <br>
   function Rg(N=10): generates int range (0:1:N-1)<br>
   measure(s=10, x=undef, y=undef, z=undef): draw transparent 2D square(s) of size s, translated by x,y,z orthogonal to axis x,y,z<br>
  <b>Primitives</b><br>
   Ci(r=10, d=undef): circle with radius r or diameter d<br>
   CiH(r=10, w=0, d=undef) or circle_half(...): half circle rotated by w<br>
   CiS(r=10, w1=0, w2=90, d=undef)or circle_sector(...): circle sector from angle w1 to w2<br>
   Sq(x=10, y=undef, center=true)): rect with x,y or square with sides x<br>
   Cy(r=10, h=1, center=true, r1=undef, r2=undef, d=undef): cylinder<br>
   CyH(r=10, w=0, d=undef) or cylinder_half(...) half cylinder rotated by w<br>
   CyS(r=10, h=1, w1=0, w2=90, C=true, d=undef) or Pie(...) or cylinder_sector(...): cylinder sector from angle w1 to w2<br>
   CyR(r=10, h=10, r_=1, d=undef, r1=undef, r2=undef, d1=undef, d2=undef, center=false) or cylinder_rounded(...): like cylinder() with rounded end faces <br>
   Cu(x=10, y=undef, z=undef, center=true): a cube with sides x,y,z; alternatively cube([x,y,z]) and cube(x) allowed<br>
   CuR(x = 10, y = undef, z = undef, r = 0, center = true) or cube_rounded(size, r=0, center=false): cube with rounded vertices<br>
   Ri(R=10, r=5, h=1, center=true, D=undef, d=undef): ring<br>
   RiH(R=10, r=5, h=1, w=0 center=true, D=undef, d=undef) or ring_half(...) half ring rotated by w<br>
   RiS(R=10, r=5, h=1, w1=0, w2=90, center=true, D=undef, d=undef) or ring_sector(): ring sector from w1 to w2<br>
   Sp(r=10): sphere<br>
   SpH(r=10, w1 = 0, w2 = 0) or sphere_half(...); half sphere rotated with angle w<br>
   To(torus(R=10, r=1, w1=0, w2=360): torus(...): torus from angle w1 to angle w2<br>";
  echo(str(h)); 
}


// Euclidean Transformations

module T(x=0, y=0, z=0){
  translate(x[0]==undef?[x, y, z]:x)children(); }
module TK(x=0, y=0, z=0){ children(); T(x,y,z) children(); }
  
module Tx(x) { translate([x, 0, 0])children(); }
module Ty(y) { translate([0, y, 0])children(); }
module Tz(z) { translate([0, 0, z])children(); }
module TKx(x) { TK(x=x) children(); }
module TKy(y) { TK(y=y) children(); }
module TKz(z) { TK(z=z) children(); }

module R(x=0, y=0, z=0) rotate( is_list(x)? x : [x, y, z]) children();
module Rx(x=90) for(i=(is_list(x)?x:[x])) R([i, 0, 0]) children();
module Ry(y=90) for(i=(is_list(y)?y:[y])) R([0, i, 0]) children();
module Rz(z=90) for(i=(is_list(z)?z:[z])) R([0, 0, i]) children();
module M(x=0, y=0, z=0) mirror( is_list(x)? x : [x, y, z]) children(); 
module Mx() M([1, 0, 0]) children(); 
module My() M([0, 1, 0]) children(); 
module Mz() M([0, 0, 1]) children(); 

module RK(x=0, y=0, z=0){children(); rotate( is_list(x)? x : [x, y, z]) children();}
module RKx(x=90) Rx(concat(0,x)) children();
module RKy(y=90) Ry(concat(0,y)) children();
module RKz(z=90) Rz(concat(0,z)) children();
module MK(x=0, y=0, z=0) {children(); mirror( is_list(x)? x : [x, y, z]) children();} 
module MKx() MK([1, 0, 0]) children(); 
module MKy() MK([0, 1, 0]) children(); 
module MKz() MK([0, 0, 1]) children(); 

module S(x=1, y=undef, z=undef){ scale(x[0]==undef?[x, y?y:x, z?z:y?1:x]:x) children();}
module Sx(x=1){scale([x, 1, 1]) children();}
module Sy(y=1){scale([1, y, 1]) children();}
module Sz(z=1){scale([1, 1, z]) children();}

module Skew(x=0, y=0, z=0, a=0, b=0, c=0)
  multmatrix([[1, a, x], [b, 1, y], [z, c, 1]]) children(); 
module skew(x=0, y=0, z=0, a=0, b=0, c=0) 
  Skew(x, y, z, a, b, c) children();
module SkX(x=0) Skew(x=x) children();
module SkY(y=0) Skew(y=y) children();
module SkZ(z=0) Skew(z=z) children();
module SkewX(x=0) Skew(x=x) children();
module SkewY(y=0) Skew(y=y) children();
module SkewZ(z=0) Skew(z=z) children();

module LiEx(h=1, tw = 0, sl = 20, sc = 1, C=true) linear_extrude(height=h, twist = tw, slices = sl, scale = sc, center=C) children();

// Booleans
module D() if($children >1) difference(){children(0); children([1:$children-1]);} else children(); 
module U() children([0:$children-1]);
module I() intersection_for(n=[0:$children-1]) children(n); 

// rotates N instances of children around z axis
module rotN(r=10, N=4, offs=0, M=undef) for($i=[0:(M?M-1:N-1)])  rotate([0,0,offs+$i*360/N])  translate([r,0,0]) children();
module forN(r=10, N=4, offs=0, M=undef) rotN(r, N, offs, M) children();
module forX(dx = 10, N=4) for(i=[0:N-1]) T(-((N-1)/2-i)*dx) children(); 
module forY(dy = 10, M=4) for(i=[0:M-1]) Ty(-((M-1)/2-i)*dy) children(); 
module forZ(dz = 10, M=4) for(i=[0:M-1]) Tz(-((M-1)/2-i)*dz) children(); 
module forXY(dx = 10, N=4, dy = 10, M=4) forX(dx, N) forY(dy, M) children(); 


// primitives - 2D

module Sq(x =10, y = undef, center = true)
{
		square([x, y?y:x], center = center); 
}
module Ci(r = 10, d=undef) circle(d?d/2:r); 

// derived primitives - 2d
module CiH(r = 10, w = 0, d=undef)
  circle_half(r, w, d); 

module CiS(r = 10, w1 = 0, w2 = 90, d=undef)
  circle_sector(r, w1, w2, d); 


// primitives - 3d
module Cy(r = undef, h = 1, C = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
  cylinder(r=d?d/2:r, h=h, center=C, r1=d1?d1/2:r1, r2=d2?d2/2:r2); 

module Cu(x = 10, y = undef, z = undef, C = true)
  cube(x[0] == undef?[x, y?y:x, y?z?z:1:x]:x, center=C); 

module CuR(x = 10, y = undef, z = undef, r = 0, C = true)
  cube_rounded(x[0] == undef?[x, y?y:x, y?z?z:1:x]:x, r=r, center=C); 

module CyR(r = 10, h=10, r_=1, d = undef, r1=undef, r2=undef, d1 = undef, d2 = undef, C=false)  
  cylinder_rounded(r, h, r, d, r1, r2, d1, d2, C); 

// derived primitives - 3d
module CyH(r = 10, h = 1, w = 0, C = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
  Rz(w) cylinder_half(r=r, h=h, center=C, r1=r1, r2=r2, d=d, d1=d1, d2=d2); 

module CyS(r = 10, h = 1, w1 = 0, w2 = 90, C = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
  cylinder_sector(r=r, h=h, w1=w1, w2=w2, center=C, r1=r1, r2=r2, d=d, d1=d1, d2=d2); 

module Ri(R = 10, r = 5, h = 1, C = true, D=undef, d=undef)
  ring(R, r, h, C, D, d); 

module RiS(R = 10, r = 5, h = 1, w1 = 0, w2 = 90, C = true, D=undef, d=undef)
   ring_sector(R, r, h, w1, w2, C, D, d); 

module RiH(R = 10, r=5, h = 1, w = 0, C = true, D=undef, d=undef)
   ring_half(R, r, h, w, C, D, d); 
module Pie(r = 10, h = 1, w1 = 0, w2 = 90, C = true, d=undef)
  cylinder_sector(r, h, w1, w2, C, d);  
module Sp(r = 10)
  sphere(r); 
module SpH(r = 10, w1 = 0, w2 = 0)
  sphere_half(r, w1, w2); 
module To(R=10, r=1, r1 = undef, w=0, w1=0, w2=360) torus(R=R, r=r, r1=r1, w=w,w1=w1, w2=w2);  

module Col(r=1, g=1, b=1, t=1) 
{
  if(len(r)) 
    color(r, g) children(); 
  else
    color([r,g,b], t) children(); 
}

function Rg(N=10) = [for(i=[0:N-1]) i]; 

//


// clear text definitions

module cube_rounded(size, r=0, center=false)
{
  sz = size[0]==undef?[size, size, size]:size; 
  ce = center[0]==undef?[center, center, center]:center; 
  r_ = min(abs(r), abs(size.x/2), abs(size.y/2), abs(size.z/2)); 
  translate([ce.x?-sz.x/2:0,ce.y?-sz.y/2:0, ce.z?-sz.z/2:0])
  if(r)
    hull() 
    {
      translate([r_, r_, r_]) sphere(r_); 
      translate([r_, r_, sz.z-r_]) sphere(r_); 
      translate([r_, sz.y-r_, r_]) sphere(r_); 
      translate([r_, sz.y-r_, sz.z-r_]) sphere(r_); 
      translate([sz.x-r_, r_, r_]) sphere(r_); 
      translate([sz.x-r_, r_, sz.z-r_]) sphere(r_); 
      translate([sz.x-r_, sz.y-r_, r_]) sphere(r_); 
      translate([sz.x-r_, sz.y-r_, sz.z-r_]) sphere(r_); 
    }
  else 
    cube(size); 
}

module circle_half(r = 10, w = 0, d = undef)
{
  R= d?d/2:r;
	difference()
	{
		circle(R); 
     rotate([0, 0, w-90])
     translate([0, -R])
		square([R, 2*R], center = false); 
	}
}

module circle_sector(r = 10, w1 = 0, w2 = 90, d = undef)
{
  R = d?d/2:r; 
  W2 = (w1>w2)?w2+360:w2; 
  diff = abs(W2-w1);
  if (diff < 180)
    intersection()
		{
       circle_half(R, w1); 
       circle_half(R, W2-180); 
 		}
	else if(diff>=360)
    circle(R); 
  else
		{
       circle_half(R, w1); 
       circle_half(R, W2-180); 
 		}
}

module cylinder_half(r = 10, h = 1, center = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
{
  R = max(d?d/2:r, r1?r1:0, r2?r2:0, d1?d1/2:0, d2?d2/2:0);
  difference()
  {
    Cy(r=r, h=h, C=center, r1=r1, r2=r2, d=d, d1=d1, d2=d2);
    Ty(-(R+1)/2)
    Cu(2*R+1, R+1, h+1, C = center); 
  }
//  linear_extrude(height = h, center = center)
//  circle_half(r=r, w=w, d=d); 
} 

module cylinder_sector(r = 10, h = 1, w1 = 0, w2 = 90, center = true, r1 = undef, r2=undef, d=undef, d1=undef, d2=undef)
{
  R = max(d?d/2:r, r1?r1:0, r2?r2:0, d1?d1/2:0, d2?d2/2:0);
    intersection()
    {
      Cy(r=r, h=h, C=center, r1=r1, r2=r2, d=d, d1=d1, d2=d2);
      cylinder_sector_(r=R, h=h, w1=w1, w2=w2, center=center);
    }
}

module cylinder_sector_(r = 10, h = 1, w1 = 0, w2 = 90, center = true)
  linear_extrude(height = h, center = center, convexity = 2)
  circle_sector(r=r, w1=w1, w2=w2); 

module cylinder_rounded(r=10, h=10, r_=1, d=undef, r1=undef, r2=undef, d1=undef, d2=undef, center=true)
{
  r1 = r1==undef?d1==undef?d==undef?r:d/2:d1/2:r1;
  r2 = r2==undef?d2==undef?d==undef?r:d/2:d2/2:r2;
  r_ = min(abs(h/4), abs(r1), abs(r2), abs(r_));
  h = abs(h);
  Tz(center?-h/2:0) rotate_extrude() I()
  {
    offset(r_)offset(-r_) polygon([[-2*r_,0], [r1, 0], [r2, h], [0,h], [-2*r_,h]] );
    Sq(max(r1,r2), h, 0);
  }
} 


module ring(R = 10, r = 5, h = 1, center = true, D=undef, d=undef)
  linear_extrude(height = h, center = center, convexity = 2)
	difference()
	{
    Ci(r = D?D/2:R); 
    Ci(r = d?d/2:r); 
	}


module ring_half(R = 10, r = 5, h = 1, w = 0, center = true, D=undef, d=undef)
  linear_extrude(height = h, center = center, convexity = 2)
  Rz(w)
	difference()
	{
    CiH(r = D?D/2:R); 
    Ci(r = d?d/2:r); 
	}

module ring_sector(R = 10, r = 5, h = 1, w1 = 0, w2 = 90, center = true, D=undef, d=undef)
  linear_extrude(height = h, center = center, convexity = 2)
	difference()
	{
    CiS(r = D?D/2:R, w1 = w1, w2 = w2); 
    Ci(r = d?d/2:r); 
	}


module sphere_half(r = 10, w1 = 0, w2 = 0)
  R(w1, w2)
	intersection() {
   	sphere(r);
    Tz(r) Cu(2*r); 
	}

module torus(R=10, r=1, r1 = undef, w=0, w1=0, w2=360)
{
  if (r1)
    D(){
      To(R=R, r=r, w=w, w1=w1, w2=w2); 
      To(R=R, r=r1, w=w, w1=w1-1, w2=w2+1); 
    }
  else
    Rz(w1)
    rotate_extrude(angle = w2-w1)
    T(R)
    Rz(w)
    circle(r); 
    
}

// additional code
module place_in_rect(dx =20, dy=20)
{
  cols = ceil(sqrt($children)); 
  rows = floor(sqrt($children)); 
  for(i = [0:$children-1])
	{ 
	  T(dx*(-cols/2+(i%cols)+.5), dy*(rows/2-floor(i/cols)-.5))
		 children(i); 
	}
}

module measure(s=10, x=undef, y=undef, z=undef)
{
  p=[[s, s, 0], [-s, s, 0], [-s, -s, 0], [s, -s, 0]]; 
  C("black",.5)
  {
    if(z) Tz(z) polyhedron(p, [[0,1,2,3]]); 
    if(x) Tx(x) Ry(90)polyhedron(p, [[0,1,2,3]]); 
    if(y) Ty(y) Rx(90) polyhedron(p, [[0,1,2,3]]); 
  }
}
