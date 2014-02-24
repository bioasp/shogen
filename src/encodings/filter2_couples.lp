% pmax(L).
% start(R).
% goal(R).
#const pmin=0.

last(L) :- gene(L), not gene(L+1).
cat_gene(G) :- gene(G), cat(G,R).


% possible start and end genes have max distance pmax 
pse(S,E) :- cat_gene(S),cat_gene(E), S<E, 
            (E-S)+1 <= U, pmax(U), (E-S)+1 >= pmin.

pse(S,S) :- cat_gene(S), pmin==1.

% over the cut
pse(S,E) :- cat_gene(S),cat_gene(E), S>E, 
            E < U, pmax(U), S > (L-U)+1, last(L),
            (L-S)+1+E <= U, (L-S)+1+E>= pmin.

% choose start and end genes
0{se(S,E): pse(S,E)}1.

% the following genes are the activated
cgene(S) :- se(S,E).
cgene(E) :- se(S,E).

cgene(X) :- se(S,E), S<E, cat_gene(X), X>S, X<E. 

% over the cut
cgene(X) :- se(S,E), S>E, cat_gene(X), X>S. 
cgene(X) :- se(S,E), S>E, cat_gene(X), X<E. 


needse :- se(S,E).
length(0) :- not needse.

% the length of the chosen dna strand
length((E-S)+1)   :- S<=E, se(S,E).

% over the cut
length((L-S)+1+E) :- S>E, se(S,E), last(L).

:- length(X), X < pmin.

#minimize [ length(L) = L ].


seed(X) :- reaction(R), reactant(X,R), start(R).
target(X) :- reaction(R), product(X,R), goal(R).

seed("ADP").
seed("ATP").
seed("ADENOSYL-HOMO-CYS").
seed("NADPH").
seed("PYRUVATE").
seed("NADH").
seed("S__45__ADENOSYLMETHIONINE").
seed("ATP").
seed("AMP").
seed("NADP").
seed("CARBON__45__DIOXIDE").
seed("PROTON").
seed("AMMONIA").
seed("WATER").
seed("PPI").
seed("CO__45__A").
seed("OXYGEN__45__MOLECULE").
seed("ADP").
seed("Pi").
seed("NAD").
seed("GLT").


iscat(R) :- cat(G,R).
dreaction(R) :- reaction(R), not iscat(R).


scope(X) :- seed(X).
scope(M) :- product(M,R), reaction(R), cgene(G), cat(G,R),
                 scope(M2): reactant(M2,R).

scope(M) :- product(M,R), dreaction(R),
                 scope(M2): reactant(M2,R).

scope(M) :- reactant(M,R), reaction(R), reversible(R), cgene(G), cat(G,R),
                 scope(M2): product(M2,R).

scope(M) :- reactant(M,R), dreaction(R), reversible(R),
                 scope(M2): product(M2,R).

app(R) :- dreaction(R),scope(M2): product(M2,R).
app(R) :- reaction(R),scope(M2): product(M2,R), cgene(G), cat(G,R).
:- goal(R), not app(R).


bscope(X) :- target(X), not seed(X).
bscope(M) :- reactant(M,R), reaction(R), app(R), not seed(M),
             bscope(M2), product(M2,R).

bscope(M) :- product(M,R), reaction(R), reversible(R), app(R), not seed(M),
             bscope(M2), reactant(M2,R).

bapp(R) :- app(R), reaction(R), bscope(M2), product(M2,R).
bapp(R) :- app(R), reaction(R), reversible(R), bscope(M2), reactant(M2,R).

aunit(G):- bapp(R), cat(G,R),cgene(G).

:- se(S,E), not aunit(S).
:- se(S,E), not aunit(E).


#hide.
#show aunit/1.
% #show length/1.



