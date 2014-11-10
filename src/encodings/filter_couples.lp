% gene(G)
% redge(R1,R2).
% cat(G,R).
% pmax(U)


% this logic program yields only one answerset

% the last gene
last(L) :- gene(L), not gene(L+1).

% setup redge format
% count length clockwise
pedge(p(G1,R1),p(G2,R2)) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G2 >G1,
                               last(L), pmax(U), W1 = (G2-G1)+1, W2 = (L-G2)+1+G1, W1<=W2, W1 <=U.

pedge(p(G1,R1),p(G2,R2)) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G1 >G2,
                               last(L), pmax(U), W1 = (G1-G2)+1, W2 = (L-G1)+1+G2, W1<=W2, W1 <=U.

% count length counter clockwise
pedge(p(G1,R1),p(G2,R2)) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G2 >G1,
                               last(L), pmax(U), W1 = (G2-G1)+1, W2 = (L-G2)+1+G1, W2<W1, W2 <=U.
pedge(p(G1,R1),p(G2,R2)) :- redge(R1,R2), cat(G1,R1), cat(G2,R2), G1 >G2,
                               last(L), pmax(U), W1 = (G1-G2)+1, W2 = (L-G1)+1+G2, W2<W1, W2 <=U.

pedge(p(G,R1),p(G,R2)) :- redge(R1,R2), cat(G,R1), cat(G,R2).





fpath(p(GS,RS),p(GS,RS)) :- pedge(p(GS,RS),Y), pair(RS,RZ).

fpath(p(GY,RY),p(GS,RS)) :- fpath(p(GX,RX),p(GS,RS)),
                            pedge(p(GX,RX),p(GY,RY)),
                            GS<=GY, last(L), pmax(U),
                            (GY-GS)+1 <= U.

fpath(p(GY,RY),p(GS,RS)) :- fpath(p(GX,RX),p(GS,RS)),
                            pedge(p(GX,RX),p(GY,RY)),
                            GS<=GY, last(L), pmax(U),
                            (L-GY)+1+GS <= U.


fpath(p(GY,RY),p(GS,RS)) :- fpath(p(GX,RX),p(GS,RS)),
                            pedge(p(GX,RX),p(GY,RY)),
                            GS>GY, last(L), pmax(U),
                            (GS-GY)+1 <= U.

fpath(p(GY,RY),p(GS,RS)) :- fpath(p(GX,RX),p(GS,RS)),
                            pedge(p(GX,RX),p(GY,RY)),
                            GS>GY, last(L), pmax(U),
                            (L-GS)+1+GY <= U.

                            
                            
rpath(p(GZ,RZ),p(GZ,RZ)) :- pedge(Y,p(GZ,RZ)), pair(RS,RZ).                            

rpath(p(GY,RY),p(GZ,RZ)) :- rpath(p(GX,RX),p(GZ,RZ)),
                            pedge(p(GY,RY),p(GX,RX)),
                            GZ<=GY, last(L), pmax(U),
                            (GY-GZ)+1 <= U.
                            
rpath(p(GY,RY),p(GZ,RZ)) :- rpath(p(GX,RX),p(GZ,RZ)),
                            pedge(p(GY,RY),p(GX,RX)),
                            GZ<=GY, last(L), pmax(U),
                            (L-GY)+1+GZ <= U.


rpath(p(GY,RY),p(GZ,RZ)) :- rpath(p(GX,RX),p(GZ,RZ)),
                            pedge(p(GY,RY),p(GX,RX)),
                            GZ>GY, last(L), pmax(U),
                            (GZ-GY)+1 <= U.

rpath(p(GY,RY),p(GZ,RZ)) :- rpath(p(GX,RX),p(GZ,RZ)),
                            pedge(p(GY,RY),p(GX,RX)),
                            GZ>GY, last(L), pmax(U),
                            (L-GZ)+1+GY <= U.                            
                            

vpair(RS,RZ)     :- fpath(p(GZ,RZ),p(GS,RS)), rpath(p(GS,RS),p(GZ,RZ)), pair(RS,RZ).

#hide.
#show vpair/2.



