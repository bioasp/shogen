% input predicates #shown by preprocess.lp
% dir_edge/3.
% bidir_edge/3.
% firstedge/3.
% lastedge/3.
% startnode/1
% endnode/1
% pmax(U)

pmin(min).

1{ cedge(X,Y,W) : firstedge(X,Y,W) }1.
1{ cedge(X,Y,W) : lastedge(X,Y,W) }1.

0{ cedge(X,Y,W) }1 :- dir_edge(X,Y,W), not firstedge(X,Y,W), not lastedge(X,Y,W).
0{ cedge(X,Y,W) }1 :- bidir_edge(X,Y,W).


% Can we reach a goal node
at(S) :- startnode(S).
at(Y) :- at(X), cedge(X,Y,W).
at(Y) :- at(X), cedge(Y,X,W), Y<=X, bidir_edge(Y,X,W).
path :- at(G), endnode(G). 
:- not path.

% Everything longer than pmax is no solution
:-  pmax(U), U+1 [ cedge(X,Y,W)=W ].
% Everything smaller than pmin is no solution
:-  pmin(L), [ cedge(X,Y,W)=W ] L-1.

%additional constraints
cedge(X,Y) :- cedge(X,Y,W).

% no branches
:-cedge(A,X),cedge(A,Y), cedge(A,Z), X!=Y, X!=Z, Y!=Z.
:-cedge(X,A),cedge(A,Y), cedge(A,Z), X!=Y, X!=Z, Y!=Z.
:-cedge(X,A),cedge(Y,A), cedge(A,Z), X!=Y, X!=Z, Y!=Z.
:-cedge(X,A),cedge(Y,A), cedge(Z,A), X!=Y, X!=Z, Y!=Z.

% no unconnected edges
:-cedge(X,Y), not at(X).
:-cedge(X,Y), not at(Y).


% restore direction of found edges
dedge(X,Y,W) :- cedge(X,Y,W), dir_edge(X,Y,W).

dedge(X,Y,W) :- dedge(Z,X,_), cedge(X,Y,W), bidir_edge(X,Y,W), Y!=Z.
dedge(X,Y,W) :- dedge(Z,X,_), cedge(Y,X,W), bidir_edge(Y,X,W), Y!=Z.


fedge(X,Y,W) :-dedge(X,Y,W), W!=0.

zchain(X,X) :- dedge(Z,X,W), dedge(X,Y,0), W!=0.
zchain(X,X) :- startnode(X), dedge(X,Y,0).
zchain(X,Y) :- zchain(X,Z), dedge(Z,Y,0).

zchainend(Y) :- dedge(X,Y,0),dedge(Y,Z,W), W!=0.
zchainend(Y) :- dedge(X,Y,0),endnode(Y).

zwoop(X,Y) :- zchain(X,Y), zchainend(Y).



% Find shortest paths
#minimize [not false, cedge(X,Y,W)=W].

#hide.
#show fedge/3.
#show zwoop/2.

