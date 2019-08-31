// This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.
// Dario Pellegrini, Padova (IT) 2019/8
// <pellegrini.dario@gmail.com> 

use <shortcuts.scad>
use <linspace.scad>
d2r = PI/180;
r2d = 1/d2r;

function radius(x,y) = sqrt(x*x+y*y);
function _polar2cartesian(r, theta) = [r*cos(theta), r*sin(theta)];
function _cartesian2polar(x, y) = [sqrt(x*x+y*y), atan2(y,x)];
function polar2cartesian(pts) = is_list(front(pts)) 
  ? [ for (p=pts) _polar2cartesian(p.x,p.y)]
  : _polar2cartesian(pts.x, pts.y);
function cartesian2polar(pts) = is_list(front(pts))
  ? [ for (p=pts) _cartesian2polar(p.x,p.y)]
  : _cartesian2polar(pts.x, pts.y);
function polar(r, theta) = _polar2cartesian(r, theta);

function inv(a) = tan(a)*r2d-a;

function lst_repeat(item, times) = [ for (i=[1:times]) item ];

function Tpts(pts, x=0, y=0, z=0) = [ for (pt=pts) [pt.x+x, pt.y+y, pt.z+z] ];
function Txpts(pts, x=0) = Tpts(pts, x=x);
function Typts(pts, y=0) = Tpts(pts, y=y);
function Tzpts(pts, z=0) = Tpts(pts, z=z);

function find_circle(p1, p2, p3) = let (
    x1=p1.x, y1=p1.y,
    x2=p2.x, y2=p2.y,
    x3=p3.x, y3=p3.y,

    x12 = x1 - x2, x13 = x1 - x3,
    y12 = y1 - y2, y13 = y1 - y3,
    y31 = y3 - y1, y21 = y2 - y1,
    x31 = x3 - x1, x21 = x2 - x1,
    
    sx13 = pow(x1, 2) - pow(x3, 2),
    sy13 = pow(y1, 2) - pow(y3, 2),
    sx21 = pow(x2, 2) - pow(x1, 2),
    sy21 = pow(y2, 2) - pow(y1, 2),

    f = ( sx13 * x12 + sy13 * x12 +
          sx21 * x13 + sy21 * x13 ) /
          (2 * (y31 * x12 - y21 * x13)),
    g = ( sx13 * y12 + sy13 * y12 +
          sx21 * y13 + sy21 * y13 ) / 
          (2 * (x31 * y12 - x21 * y13)),
    
    c = pow(x1, 2) + pow(y1, 2) + 2 * g * x1 + 2 * f * y1,
    r = sqrt( pow(g,2) + pow(f,2) + c),
    cx = -g,
    cy = -f,
    w1 = atan2(y1-cy, x1-cx),
    w2 = atan2(y2-cy, x2-cx),
    w3 = atan2(y3-cy, x3-cx),
    A = (w3<w2),
    B = (w2<w1),
    C = (w1<w3)
  ) [cx, cy, r, w1, w3, /*direction of rotation*/ (A&&B) || (A&&C) || (B&&C) ];

function make_arc(p1,p2,p3,n=$fn) = let(c=find_circle(p1,p2,p3), x=c[0], y=c[1], r=c[2]) [
  for (t=polar_linspace(w1=c[3], w2=c[4], n=n, ccw=c[5])) [x,y]+polar(r,t)
];

function make_arc_no_extremes(p1,p2,p3,n=$fn) = 
  pop_front(pop_back(make_arc(p1,p2,p3,n+2)));

function make_circle(p1,p2,p3,n=$fn) = 
  let(c=find_circle(p1,p2,p3), x=c[0], y=c[1], r=c[2]) [
    for (t=_linspace(0, 360, n)) [x,y]+polar(r,t)
];
    
function p2p3(p2, z, res=[]) =
  is_undef(p2[0][0]) ?
    [p2.x, p2.y, z]
  : (
    len(p2) == 1 ?
      concat(res, [[front(p2).x, front(p2).y, z]])
    :
      p2p3(pop_front(p2), z, concat(res, [[front(p2).x, front(p2).y, z]]))
  );

function reverse_lst(lst) = [ for (i=[len(lst)-1:-1:0]) lst[i] ];
function rotate_lst(lst, n) = let(N=len(lst)) [ for (i=[0:N-1]) lst[(i+n+N)%N] ];

function constrain_angle(x) = let( y = x%360.0 ) y < 0 ? y+360 : y;

function cum_sum(lst, i=1) =
  i == len(lst) ? lst :
    cum_sum( [ for (j=[0:len(lst)-1]) j==i ? lst[j]+lst[j-1] : lst[j] ], i+1);

function cum_avg(lst) = let (tmp = cum_sum(lst))
  [ for (i=[0:len(lst)-1]) tmp[i]/(i+1) ];

//function cum_avg_corr(lst, z_max) = let (tmp = cum_avg(lst))
//  [ for (i=[0:len(lst)-1]) tmp[i]*cos(i/(len(lst)-1)) ];

function fold_on_sphere(pts, R, C=[0,0,0]) = Tpts([
  let (ptst = Tpts(pts, -C.x, -C.y, -C.z)) for (pt=ptst) 
  let( Rp = sqrt( pt.x*pt.x + pt.y*pt.y + pt.z*pt.z ),
       phi = atan2(pt.y, pt.x),
       tp = acos( pt.z / Rp),
       tc = acos( pt.z / R),
       xx = Rp*sin(tp)-R*sin(tc),
       theta = tc - xx/R*r2d //fold teeth on sphere
  )
  [
    R*sin(theta)*cos(phi),
    R*sin(theta)*sin(phi),
    R*cos(theta)
  ]
], C.x, C.y, C.z);

module draw(pts, size = 0.1) {
  for (i=[0:len(pts)-1]) let(p=pts[i]) T(p.x, p.y, p.z) {
    Cu(size);
    Ty(size/2) linear_extrude(size) text(str(i), size=size);
  }
}
