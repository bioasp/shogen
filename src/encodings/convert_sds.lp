% gene(G)
% redge(R1,R2).
% cat(G,R).
% pmax(U)

% this logic program yields only one answerset
% it converts into the logic format used by sgs.lp


% the last gene
last(L) :- gene(L), not gene(L+1).

% filter edges
% count length clockwise
edge(R1,R2) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G2 >G1,
                               last(L), pmax(U), W1 = (G2-G1)+1, W2 = (L-G2)+1+G1, W1<=W2, W1 <=U.

edge(R1,R2) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G1 >G2, 
                               last(L), pmax(U), W1 = (G1-G2)+1, W2 = (L-G1)+G2, W1<=W2, W1 <=U.

% count length counter clockwise
edge(R1,R2) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G2 >G1, 
                               last(L), pmax(U), W1 = (G2-G1)+1, W2 = (L-G2)+1+G1, W2<W1, W2 <=U.
edge(R1,R2) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G1 >G2, 
                               last(L), pmax(U), W1 = (G1-G2)+1, W2 = (L-G1)+1+G2, W2<W1, W2 <=U.

edge(R1,R2) :- redge(R1,R2), cat(G,R1), cat(G,R2).



% genes that catalyse reactions
cat_gene(X) :- gene(X), cat(X,_).

#hide.
#show edge(X,Y).
#show last(G).
#show cat_gene(X).
#show cat(G,R).
#show pmax/1.
