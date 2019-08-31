// Dario Pellegrini, Padova (IT) 2019/8
// <pellegrini.dario@gmail.com> 

function back(list) = list[len(list)-1];
function pop_back(list) =
  len(list)>1 ? [for (i=[0:len(list)-2]) list[i]] : [];

function front(list) = list[0];
function pop_front(list) =
  len(list)>1 ? [for (i=[1:len(list)-1]) list[i]] : [];

function range(r) = [ for(x=r) x ];
function indx(l) = [ for(x=[len(l)-1]) x ];

function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];
function flatten(list) = [ for (i = list, v = i) v ];

function linspace(start,stop, n=$fn) = let (step=(stop-start)/(n-1))
  concat( [ for (i = [0:1:n-1.1]) start+i*step], stop);

function _linspace(start,stop, n=$fn) = 
  pop_back(linspace(start, stop, n+1));

function polar_linspace(w1, w2, n=$fn, cw=true, ccw=undef) =
  let( w = is_undef(ccw) ? cw : !ccw, 
       wi = w ? w1 : ( w1<=w2 ? w1+360 : w1 ) ,
       wf = w ? ( w1<=w2 ? w2 : w2+360 ) : w2 ) 
  [ for (i=linspace(wi,wf,n)) i%360 ];

function _polar_linspace(w1, w2, n=$fn, cw=true, ccw=undef) =
  let( w = is_undef(ccw) ? cw : !ccw, 
       wi = w ? w1 : ( w1<=w2 ? w1+360 : w1 ) ,
       wf = w ? ( w1<=w2 ? w2 : w2+360 ) : w2 )
  [ for (i=_linspace(wi,wf,n)) i%360 ];

