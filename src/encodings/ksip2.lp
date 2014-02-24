% input predicates #shown by preprocess.lp
% dir_edge/3.
% bidir_edge/3.
% zero_edge/2.
% startnode/1
% endnode/1
% pmax(U)

pmin(min).

1 {start(X) :  startnode(X)}1.
1 {end(X) :  endnode(X)}1.

0{ cedge(X,Y,W) }1 :- dir_edge(X,Y,W).
0{ cedge(X,Y,W) }1 :- bidir_edge(X,Y,W).


% Can we reach a goal node
at(S) :- start(S).
at(Y) :- at(X), cedge(X,Y,W), end(E), X!=E.
 at(Y) :- at(X), zero_edge(X,Y), end(E), X!=E.
at(Y) :- at(X), cedge(Y,X,W), Y<=X, bidir_edge(Y,X,W), end(E), X!=E.
path :- at(G), end(G). 
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


% grounded
gat(S,0) :- start(S).
gat(Y,L+1) :- gat(X,L), cedge(X,Y,W), dir_edge(X,Y,W), pmax(U), L+1<=U.
gat(Y,L+1) :- gat(X,L), cedge(X,Y,W), bidir_edge(X,Y,W), pmax(U), L+1<=U, not gat(Y,L-1).
gat(X,L+1) :- gat(Y,L), cedge(X,Y,W), bidir_edge(X,Y,W), pmax(U), L+1<=U, not gat(X,L-1).
gat(Y,L+1) :- gat(X,L), zero_edge(X,Y), not zero_edge(Y,X), pmax(U), L+1<=U.
gat(Y,L+1) :- gat(X,L), zero_edge(X,Y), zero_edge(Y,X), pmax(U), L+1<=U, not gat(Y,L-1).



% restore direction of found edges
fedge(X,Y,W) :- cedge(X,Y,W), dir_edge(X,Y,W).

fedge(X,Y,W) :- cedge(X,Y,W), bidir_edge(X,Y,W), gat(X,L), gat(Y,L+1).
fedge(X,Y,W) :- cedge(X,Y,W), bidir_edge(X,Y,W), gat(X,L+1), gat(Y,L).


% successor via zero edges
zchain(X,X) :- zero_edge(X,Y).
zchain(X,Z) :- zchain(X,Y), zero_edge(Y,Z).

% predecessor via zero_edges
zbchain(X,X) :- zero_edge(Y,X).
zbchain(X,Z) :- zbchain(X,Y), zero_edge(Z,Y).

% only one in/out edge can for a supernode

in(X) :- zchain(X,X), fedge(Y,X,W), W!=0.
in(X) :- zchain(X,X), start(X).
%:-zchain(X,A), fedge(B,A,W), zchain(X,C), start(C).
:-zchain(X,A), fedge(B,A,W), zchain(X,C), fedge(D,C,W2),B!=D.

out(X) :- zbchain(X,X), fedge(X,Y,W), W!=0.
out(X) :- zbchain(X,X), end(X).
:-zchain(X,A), fedge(A,B,W), zchain(X,C), end(C).
:-zchain(X,A), fedge(A,B,W), zchain(X,C), fedge(C,D,W2),B!=D.


io(X,Y) :- in(X), out(Y), zchain(X,Y).

sn(X,Z) :- io(X,Y), zchain(X,Z), zbchain(Y,Z), X!=Z.



%fgene(XG) :- fedge(p(XG,XR), p(YG,YR),W).
%fgene(YG) :- fedge(p(XG,XR), p(YG,YR),W).

%gene(GX) :- bidir_edge(p(GX,RX),Y,W).
%gene(GY) :- bidir_edge(X,p(GY,RY),W).

%gene(GX) :- dir_edge(p(GX,RX),Y,W).
%gene(GY) :- dir_edge(X,p(GY,RY),W).

%nlast(G) :- fgene(G), fgene(G2), G2 >G.
%nfirst(G) :- fgene(G), fgene(G2), G2 <G.

%first(G) :- fgene(G), not nfirst(G).
%last(G) :-  fgene(G), not nlast(G).

%count(X) :- X=#sum[fgene(G):gene(G)].
%length((E-S)+1)   :- first(S), last(E).
%:- count(X), length(L), (X*10)< (L*7).


% Find shortest paths
#minimize [ not false, cedge(X,Y,W)=W].



#hide.
#show fedge/3.
%#show cedge/3.
%#show sn/2.
%#show in/1.
%#show out/1.
#show io/2.
%#show zchain/2.
%#show zbchain/2.

%#show path/0.

