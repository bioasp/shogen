% redge/3
% zedge/2
% pair/2
% pmax(U)
pmax(200).
last(L) :- gene(L), not gene(L+1).
iscat(R) :- cat(G,R).

dist(R1,R2,W1) :- reaction(R1),reaction(R2),product(M,R1),reactant(M,R2),
                   cat(G1,R1), cat(G2,R2), G2 >G1,
                   last(L), pmax(U), 
                   W1 = G2-G1, 
                   W2 = (L-G2)+G1, 
                   W1<=W2, 
                   W1 <=U.

dist(R1,R2,W1) :- reaction(R1),reaction(R2),product(M,R1),reactant(M,R2),
                   cat(G1,R1), cat(G2,R2), G1 >G2, 
                   last(L), pmax(U),
                   W1 = G1-G2,
                   W2 = (L-G1)+G2, 
                   W1<=W2, 
                   W1 <=U.

dist(R1,R2,W2) :- reaction(R1),reaction(R2),product(M,R1),reactant(M,R2),
                   cat(G1,R1), cat(G2,R2), G2 >G1, 
                               last(L), pmax(U), W1 = G2-G1, W2 = (L-G2)+G1, W2<W1, W2 <=U.

dist(R1,R2,W2) :- reaction(R1),reaction(R2),product(M,R1),reactant(M,R2),
                   cat(G1,R1), cat(G2,R2), G1 >G2, 
                   last(L), pmax(U), 
                   W1 = G1-G2, 
                   W2 = (L-G1)+G2,
                   W2<W1, 
                   W2 <=U.

dist(R1,R2,0) :- reaction(R1),reaction(R2),product(M,R1),reactant(M,R2),
                 cat(G,R1), cat(G,R2).

pair(Z,S):- pair(S,Z), pmax(U), dist(S,Z,W), W<=U.



fpath(M,S) :- product(M,S), pair(S,Z), pmax(U), dist(S,Z,W), W<=U.
fpath(M,S) :- reactant(M,S), pair(S,Z), pmax(U), dist(S,Z,W), W<=U, reversible(R).
fpath(M,S) :- product(M,R), reaction(R), pair(S,Z),
                  fpath(M2,S): reactant(M2,R),
                  pmax(U), dist(S,R,W1), dist(Z,R,W2),
                  U>=W1, U>=W2,
                  dist(S,Z,W), W<=U.

fpath(M,S) :- product(M,R), reaction(R), pair(S,Z),
                  fpath(M2,S): reactant(M2,R),
                  pmax(U), dist(S,Z,W), W<=U, not iscat(R).

fpath(M,S) :- reactant(M,R), reaction(R), pair(S,Z), reversible(R),
                  fpath(M2,S): product(M2,R),
                  pmax(U), dist(S,R,W1), dist(Z,R,W2),
                  U>=W1, U>=W2,
                  dist(S,Z,W), W<=U.

fpath(M,S) :- reactant(M,R), reaction(R), pair(S,Z), reversible(R),
                  fpath(M2,S): product(M2,R),
                  pmax(U), dist(S,Z,W), W<=U, not iscat(R).

vpair(S,Z)     :- fpath(M,S): reactant(M,Z), pair(S,Z).
vpair(S,Z)     :- fpath(M,S): product(M,Z), reversible(Z), pair(S,Z).



#hide.
% #show fpath/2.
#show vpair/2.
