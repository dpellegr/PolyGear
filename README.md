#Introducing PolyGear

![](https://i.imgur.com/2gOQ9Pu.gif "PolyGear")

PolyGear is a powerful OpenSCAD library for the generation of **spur** and **bevel gears** as a single polyhedron. The library allows full control of the **involute tooth profile**, including pressure angle, backlash, variable helix angle, addendum, dedendum and profile shifting.

Being able to vary the helix angle allows for instantaneous generation and switch between herringbone, zerol, spiral and customized profiles; all constructed as a single and smooth polyhedron even for small facet number.

The gear is constructed in an **extremely efficient** way, by triangulating a minimalist vertex cloud with a single polyhedron.

I wrote this library because I was unsatisfied with the existing ones:

* https://www.thingiverse.com/thing:3575
* https://www.thingiverse.com/thing:636119
* https://www.thingiverse.com/thing:1604369

being, to my taste, either too hampered, fragile or computational expensive. My aim has been overcoming these limitations. Do not expect lightening holes or other gimmicks, but comprehensive and efficient control over your gear teeth.

I would expect that the comments in the code and the demo example should suffice as user **documentation**, but if I collect some good questions I may compile a FAQ.
________________

Library files:

 * PolyGear.scad - main file, the one that you should read and *use* in your project
 * PolyGearBase.scad - computation of the gear profile and some meshing functions
 * PolyGearUtils.scad - collection of more and less trivial complementary functions
 * linspace.scad - lightweight library for producing range of points
 * shortcuts.scad - a slightly enhanced version of the [excellent shortcuts library](https://www.thingiverse.com/thing:644830) by [Parkinbot](https://www.thingiverse.com/Parkinbot/about)

Extra:

 * You will also find a copy of the nice open access paper which I use for the generation of the involute profiles. It serves as documentation for the computations implemented in PolyGearBase.scad

#Enjoy!#

________________

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
