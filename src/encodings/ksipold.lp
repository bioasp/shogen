% input predicates #shown by preprocess.lp
% dir_edge/3.
% bidir_edge/3.
% firstedge/3.
% lastedge/3.
% startnode/1
% endnode/1
% pmax(U)

pmin(min).

1{ cdir_edge(X,Y,W) : firstedge(X,Y,W) }1.
1{ cdir_edge(X,Y,W) : lastedge(X,Y,W) }1.

0{ cdir_edge(X,Y,W) }1 :- dir_edge(X,Y,W), not firstedge(X,Y,W), not lastedge(X,Y,W).
0{ cbidir_edge(X,Y,W) }1 :- bidir_edge(X,Y,W).


% Can we reach a goal node
at(S) :- startnode(S).
at(Y) :- at(X), cdir_edge(X,Y,W).
at(Y) :- at(X), X<=Y, cbidir_edge(X,Y,W).
at(Y) :- at(X), Y<=X, cbidir_edge(Y,X,W).
path :- at(G), endnode(G). 
:- not path.

% Everything longer than pmax is no solution
:-  pmax(U), U+1 [ cdir_edge(X,Y,W)=W, cbidir_edge(X2,Y2,W2)=W2 ].
% Everything smaller than pmin is no solution
:-  pmin(L), [ cdir_edge(X,Y,W)=W, cbidir_edge(X2,Y2,W2)=W2 ] L-1.

%additional constraints
fedge(X,Y) :- cdir_edge(X,Y,W).
fedge(X,Y) :- cbidir_edge(X,Y,W).

% no branches
:-fedge(A,X),fedge(A,Z), fedge(A,Y), X!=Y, X!=Z, Y!=Z.
:-fedge(X,A),fedge(A,Z), fedge(A,Y), X!=Y, X!=Z, Y!=Z.
:-fedge(X,A),fedge(Z,A), fedge(A,Y), X!=Y, X!=Z, Y!=Z.
:-fedge(X,A),fedge(Z,A), fedge(Y,A), X!=Y, X!=Z, Y!=Z.

% no unconnected edges
:-fedge(X,Y), not at(X).
:-fedge(X,Y), not at(Y).


% restore direction of found edges
fedge(X,Y,W) :- cdir_edge(X,Y,W).

fedge(X,Y,W) :- fedge(Z,X,_), cbidir_edge(X,Y,W), Y!=Z.
fedge(X,Y,W) :- fedge(Z,X,_), cbidir_edge(Y,X,W), Y!=Z.


% Find shortest paths
#minimize [cdir_edge(X,Y,W)=W,cbidir_edge(X2,Y2,W2)=W2].


#hide.
#show fedge/3.
