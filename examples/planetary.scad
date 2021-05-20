use <PolyGear.scad>
use <shortcuts.scad>

//////

ring_teeth = 40;
sun_teeth = 18;
n_planets = 5;

//////

planet_teeth = (ring_teeth - sun_teeth)/2;
assert(planet_teeth == round(planet_teeth), 
       "ring_teeth and sun_teeth have to be both even or both odd");
planet_angle = 360/n_planets;

//////

// Cutting the ring gear, note that the backlash (which defaults to 0.1) here is negative.
// Addendum and dedendum are also given to add some clearance
D() {
  Cy(h=10, d=ring_teeth+10);
  spur_gear(n=ring_teeth, z=11, backlash=-0.1, add = 0.1, ded = -0.2);  
}

// Here comes the sun
Rz(180/sun_teeth*((planet_teeth+1)%2)) spur_gear(n=sun_teeth, z=10);

// Now doing the planets
// To properly place the planets without tooth interference, theta is computed.
// It may slightly deviate from planet_angle depending on the numeber of teeth and planets.
for (i=[0:n_planets-1]) 
  let(theta = round(i*planet_angle*(ring_teeth+sun_teeth)/360)*
              360/(ring_teeth+sun_teeth))
  echo(str("Planet ",i+1," angle = ", theta))
  Rz(theta)
  Tx((sun_teeth+planet_teeth)/2) 
  Rz(theta*sun_teeth/planet_teeth)
  spur_gear(n=planet_teeth, z=10);
