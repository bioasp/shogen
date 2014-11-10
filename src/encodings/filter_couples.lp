% gene(G)
% redge(R1,R2).
% cat(G,R).
% pmax(U)
last(L) :- gene(L), not gene(L+1).
iscat(R) :- cat(G,R).
niscat(R) :- reaction(R), not  iscat(R).
revniscat(R) :- reversible(R),niscat(R).

dist(R1,R2) :- cat(G1,R1), cat(G2,R2), G1 >G2, 
                   last(L), pmax(U),
                   W1 = (G1-G2)+1,
                   W2 = (L-G1)+1+G2, 
                   W1<=W2, 
                   W1 <=U.


dist(R1,R2) :- cat(G1,R1), cat(G2,R2), G1 >G2, 
                   last(L), pmax(U), 
                   W1 = (G1-G2)+1, 
                   W2 = (L-G1)+G2,
                   W2<W1, 
                   W2 <=U.

dist(R1,R2) :- cat(G,R1), cat(G,R2),
	       pmax(U), 
               1<=U.

pair(Z,S):- pair(S,Z), dist(S,Z).

goodpair(S,Z) :- pair(S,Z), dist(S,Z).
goodstart(S) :- goodpair(S,Z).

fpath(M,S) :- product(M,S), goodstart(S).
fpath(M,S) :- reactant(M,S), goodstart(S), reversible(R).

fpath(M,S) :- product(M,R), rpath(R,S).

fpath(M,S) :- reactant(M,R), iscat(R), reversible(R),
              rpath(R,S).

rpath(R,S) :- iscat(R), goodpair(S,Z),
              fpath(M2,S): reactant(M2,R),
              dist(S,R),
              dist(R,Z).

rpath(R,S) :- niscat(R),goodstart(S),
              fpath(M2,S): reactant(M2,R).


rpath(R,S) :- iscat(R), goodpair(S,Z), reversible(R),
              fpath(M2,S): product(M2,R),
              dist(S,R),
              dist(R,Z).

rpath(R,S) :- revniscat(R),
              fpath(M2,S): product(M2,R),
              goodstart(S).



vpair(S,Z)     :- rpath(Z,S), pair(S,Z).


#hide.
% #show fpath/2.
#show vpair/2.



