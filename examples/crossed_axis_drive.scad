use <PolyGear.scad>

width = 10;
N1 = 15;
N2 = 23;
axis_angle = -50;

rotate([0,0,-360/N1*$t])
  spur_gear(n=N1, w=width, helix_angle=constant(axis_angle/2));

translate([(N1+N2)/2,0]) rotate([-axis_angle,0]) rotate([0,0,360/N2*$t])
  spur_gear(n=N2, w=width, helix_angle=constant(axis_angle/2));