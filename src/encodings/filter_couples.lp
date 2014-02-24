% redge/3
% zedge/2
% pair/2
% pmax(U)


start(p(G,S),S) :-  redge(p(G,S),Y,W), pair(S,Z).
 start(p(G,S),S) :-  zedge(p(G,S),Y), pair(S,Z).

fpath(X,0,S) :- start(X,S).
 fpath(Y,L,S) :- fpath(X,L,S), zedge(X,Y).
fpath(Y,L+W,S) :- redge(X,Y,W), fpath(X,L,S),
                       pmax(N), L+W <= N.

vpair(S,Z)     :- fpath(p(G,Z),L,S), pair(S,Z).

#hide.
#show vpair/2.
