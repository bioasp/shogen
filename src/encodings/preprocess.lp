% redge/3
% zedge/2
% start/1
% goal/1
% pmax(U)

redge(X,Y,0) :- zedge(X,Y).

startnode(p(G,R)) :-  redge(p(G,R),Y,W), start(R).
endnode(p(G,R)) :-   redge(X,p(G,R),W), goal(R).

fpath(X,0) :- startnode(X).
fpath(Y,L+W) :- redge(X,Y,W), fpath(X,L),
                pmax(N), L+W <= N,
                not startnode(Y), not endnode(X).

% pp :- fpath(X,_), endnode(X).
% :- not pp.

bpath(X,0) :- endnode(X).
bpath(X,L+W) :- redge(X,Y,W), bpath(Y,L),
                pmax(N), L+W <= N,
                not startnode(Y), not endnode(X).

% Interesting edges lie in the intersection of fpath and bpath

dir_edge(X,Y,W) :- redge(X,Y,W), not redge(Y,X,W), fpath(X,L1), bpath(Y,L2),
                pmax(N), L1+W <= N, L2+W <= N, L1+L2+W <= N,
                not startnode(Y), not endnode(X).



dir_edge(X,Y,W) :- redge(X,Y,W), redge(Y,X,W), fpath(X,L1), bpath(Y,L2),
                pmax(N), L1+W <= N, L2+W <= N, L1+L2+W <= N,
                not startnode(Y), not endnode(X), startnode(X).

dir_edge(X,Y,W) :- redge(X,Y,W), redge(Y,X,W), fpath(X,L1), bpath(Y,L2),
                pmax(N), L1+W <= N, L2+W <= N, L1+L2+W <= N,
                not startnode(Y), not endnode(X), endnode(Y).



bidir_edge(X,Y,W) :- redge(X,Y,W), redge(Y,X,W), fpath(X,L1), bpath(Y,L2),
                pmax(N), L1+W <= N, L2+W <= N, L1+L2+W <= N,
                not startnode(Y), not endnode(X), X<Y, not startnode(X), not endnode(Y).

firstedge(X,Y,W) :- dir_edge(X,Y,W), startnode(X).
lastedge(X,Y,W) :- dir_edge(X,Y,W), endnode(Y).


#hide.
#show pmax/1.
#show startnode/1.
#show endnode/1.
#show dir_edge/3.
#show bidir_edge/3.
#show firstedge/3.
#show lastedge/3.
