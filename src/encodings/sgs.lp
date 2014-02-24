% shortest_genome_segment.lp
% cat_gene(G).
% last(G).
% edge(R1,R2).
% cat(G,R).
% start(R).
% end(R).
% pmax(U).
#const pmin=1.


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

% the following genes are the activated
cgene(S) :- se(S,E).
cgene(E) :- se(S,E).

cgene(X) :- se(S,E), S<E, cat_gene(X), X>S, X<E. 

% over the cut
cgene(X) :- se(S,E), S>E, cat_gene(X), X>S. 
cgene(X) :- se(S,E), S>E, cat_gene(X), X<E. 


% active edges
aedge(X,Y) :- edge(X,Y), cat(G1,X), cat(G2,Y), cgene(G1), cgene(G2), G1!=G2.
aedge(X,Y) :- edge(X,Y),cat(G,X), cat(G,Y), cgene(G).

% active reactions
area(R) :- start(R), cgene(G), sgene(G).
area(Y) :- area(X), aedge(X,Y), end(E), X!=E.
:- not area(X), end(X).

brea(R) :- end(R), cgene(G), sgene(G).
brea(X) :- brea(Y), aedge(X,Y), start(S), Y!=S.


%used genes
ugene(X) :- sgene(X), cgene(X).
ugene(X) :- egene(X), cgene(X).
ugene(G) :- cgene(G), cat(G,X), area(X),brea(X).

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








