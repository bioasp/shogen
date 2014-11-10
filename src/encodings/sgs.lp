% shortest_genome_segment.lp
% start(R).
% end(R).
% pmax(U).
#const pmin=1.
last(L) :- gene(L), not gene(L+1).
cat_gene(G) :- cat(G,R).

sgene(G) :- start(R),cat(G,R).
egene(G) :- end(R),cat(G,R).

% possible start and end genes have max distance pmax 
pse(S,E) :- cat_gene(S),cat_gene(E), S<E, 
            (E-S)+1 <= U, pmax(U), (E-S)+1 >= pmin,
            sgene(B), S > B-U, E < B+U,
             B >=S, B <= E,
            egene(G), S > G-U, E < G+U,
             G >=S, G <= E.

pse(S,S) :- sgene(S), egene(S), pmin==1.

% over the cut
% case 1: start and end gene at the end
pse(S,E) :- cat_gene(S),cat_gene(E), S>E, 
            sgene(B), B>=S,
            egene(G), G>=S,
            E < U, pmax(U), S > (L-U)+1, last(L),
            (L-S)+1+E <= U, (L-S)+1+E>= pmin.
% case 2: start gene at the end end gene at the begin
pse(S,E) :- cat_gene(S),cat_gene(E), S>E, 
            sgene(B), B>=S,
            egene(G), G<=E,
            E < U, pmax(U), S > (L-U)+1, last(L),
            (L-S)+1+E <= U, (L-S)+1+E>= pmin.
% case 3: start gene at the begin end gene at the end
pse(S,E) :- cat_gene(S),cat_gene(E), S>E, 
            sgene(B), B<=E,
            egene(G), G>=S,
            E < U, pmax(U), S > (L-U)+1, last(L),
            (L-S)+1+E <= U, (L-S)+1+E>= pmin.
% case 4: start and end gene at the begin
pse(S,E) :- cat_gene(S),cat_gene(E), S>E, 
            sgene(B), B<=E,
            egene(G), G<=E,
            E < U, pmax(U), S > (L-U)+1, last(L),
            (L-S)+1+E <= U, (L-S)+1+E>= pmin.


% choose start and end genes
1{se(S,E): pse(S,E)}1.

% the following genes are on the segment
cgene(S) :- se(S,E).
cgene(E) :- se(S,E).

cgene(X) :- se(S,E), S<E, cat_gene(X), X>S, X<E. 

% over the cut
cgene(X) :- se(S,E), S>E, cat_gene(X), X>S. 
cgene(X) :- se(S,E), S>E, cat_gene(X), X<E. 


% active reactions
area(R) :- reaction(R), cgene(G), cat(G,R).
iscat(R) :- cat(G,R).
area(R) :- reaction(R), not iscat(R).

reached(R) :- start(R).
reached(R) :- area(R), produced(M): reactant(M,R).
reached(R) :- area(R), reversible(R), produced(M): product(M,R).
produced(M) :- product(M,R), reached(R).
produced(M) :- reactant(M,R), reached(R), reversible(R).
:-end(R), not reached(R).

breached(R) :- end(R).
breached(R) :- area(R), consumed(M), product(M,R).
breached(R) :- area(R), reversible(R), consumed(M), reactant(M,R).
consumed(M) :- reactant(M,R), breached(R).
produced(M) :- product(M,R), breached(R), reversible(R).
:-start(R), not breached(R).

%used genes
ugene(G) :- cgene(G), cat(G,X), reached(X),breached(X).

:- se(S,E), not ugene(S).
:- se(S,E), not ugene(E).

% the length of the chosen dna strand
length((E-S)+1)   :- S<=E, se(S,E).

% over the cut
length((L-S)+1+E) :- S>E, se(S,E), last(L).

:- length(X), X < pmin.

#minimize [ length(L) = L].

#hide.
#show ugene(X).
%#show cgene(X).








