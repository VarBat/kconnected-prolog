%to find all the pairs of vertices and also using max list to check if the list has all the nodes in ascendiing order to avaoid duplicates
pairs(Z) :- findall(A,(adjacent(_,A)),L),sort(L,Y),max_list(Y,U),length(Y,U),
	findall(W,(dist(P,Q,Y),sort([P,Q],W)),T),sort(T,Z).

%to find maximum of a list
my_max([], R, R). 
my_max([X|Xs], WK, R):- X >  WK, my_max(Xs, X, R). 
my_max([X|Xs], WK, R):- X =< WK, my_max(Xs, WK, R).
my_max([X|Xs], R):- my_max(Xs, X, R). 

%to find if the given path is distinct from the other paths
distinct(X,Y):-forall(member(W,Y),(X\=W,intersection(X,W,[]))).

%to check if two nodes are adjacent
adjacent(X,Y):-edge(X,Y);edge(Y,X).

%to check if two nodes belong to the same list but are distinct
dist(X,Y,W):-member(X,W),member(Y,W),not(X=Y).

%to check if a path with no vertices from other paths
simpath(X,Y,V,P):-(adjacent(W,X)),not(member(W,V)),(Y = W,P = [X,Y]).
simpath(X,Y,V,P):-(adjacent(W,X)),not(member(W,V)),(simpath(W,Y,[X|V],L),P = [X|L]).

%to delete a element from the list
delete(X,[X|Y],Y).
delete(X,[Y|Z],[Y|W]):-Y\=X,delete(X,Z,W).

%to get the K disjoint lists, we recurse untill k times
mpath(A,B,L,K,W):- simpath(A,B,W,X1),delete(A,X1,X2),delete(B,X2,X),K=1,L=[X],!.
mpath(A,B,L,K,W):- simpath(A,B,W,X1),delete(A,X1,X2),delete(B,X2,X),merge(W,X,W1),
	K>1,K1 is K-1,mpath(A,B,L1,K1,W1),distinct(X,L1),L=[X|L1],!.

%to check if atleast there are K disjoint sets for each pair of vertices
conn(K):-pairs(Z),forall(member(X,Z),(X = [A,B],mpath(A,B,L,K,[]),not(L=[]))).

biconn:-conn(2).

%pritning a path(list)
printpath([]).
printpath([X|Y]):-print(X),printpath(Y).

%printing a path(list)
printlist(X,Y,[W],Z):-writeln(Z),print(X),printpath(W),writeln(Y).
printlist(X,Y,[W|K],Z):-writeln(Z),print(X),printpath(W),writeln(Y),Z1 is Z+1,printlist(X,Y,K,Z1).

%to call the mpath and print the paths 
callmpath(X,Y,K):-mpath(X,Y,L,K,[]),L=[],fail,!. 
callmpath(X,Y,K):-mpath(X,Y,L,K,[]),printlist(X,Y,L,1),!.








