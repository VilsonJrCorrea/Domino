domino(0,0).
//domino(5,6).
domino(4,5).
//domino(6,6).
//domino(3,3).
domino(0,1).
domino(1,1).
//domino(2,2).
dominosontable([
			
				domino(0,6),
//				domino(6,1),
//				domino(1,3),
//				domino(3,6),
//				domino(6,6),
//				domino(6,4),
				domino(4,0),
				domino(0,5)
//				domino(5,2),
				//domino(2,3),
				//domino(3,4),
				//domino(4,4),
				//domino(4,2),
				//domino(2,6),
				//domino(6,5),
				//domino(5,5),
				//domino(5,3)
]).

!start.

+!start : true
	<- 
		?getDominoToPlayCrazyMode(DOMINO,SIDE);
		.print("Domino ",DOMINO," Side ",SIDE);
	.


getDominoToPlayCrazyMode(DOMINO,SIDE):-verifyWhatThatIHaveToCrazyMode(DOMINO,SIDE).
verifyWhatThatIHaveToCrazyMode(DOMINO,SIDE):- getExtremeties(XE,YE) 
											& countInX(XE,N1) 
											& countInY(YE,N2)
											& ((N1>N2 & SIDE=l & chooseDominoToCrazy(XE,DOM))| 
												(N1<N2 & SIDE=r & chooseDominoToCrazy(YE,DOM)))
											& needReverse(DOMINO,DOM,SIDE).
											
needReverse(R,DOMINO,SIDE):-getSides(DOMINO,X,Y) & getExtremeties(XE,YE) & X==XE & SIDE = l	& getReverse(DOMINO,NDOMINO) & R=NDOMINO.
needReverse(R,DOMINO,SIDE):-getSides(DOMINO,X,Y) & getExtremeties(XE,YE) & YE==Y & SIDE = r	& getReverse(DOMINO,NDOMINO)& R=NDOMINO.
needReverse(R,DOMINO,SIDE):-getSides(DOMINO,X,Y) & getExtremeties(XE,YE) & XE==Y & SIDE = l	& R=DOMINO.
needReverse(R,DOMINO,SIDE):-getSides(DOMINO,X,Y) & getExtremeties(XE,YE) & YE==X & SIDE = r	& R=DOMINO.
chooseDominoToCrazy(E,DOMINO):-getDominoThatIWillHaveForCrazyMode(DOMINO,E,6).
getDominoThatIWillHaveForCrazyMode(DOMINO,E,I):-haveDomino(E,I,DOMINO)| (not haveDomino(E,I) & getDominoThatIWillHaveForCrazyMode(DOMINO,E,I-1)).
haveDomino(E,I,DOMINO):-.count(domino(E,I),C1) & C1>0 & DOMINO=domino(E,I).
haveDomino(E,I,DOMINO):-.count(domino(I,E),C1) & C1>0 & DOMINO=domino(I,E).
countInX(XE,N):- refreshEnemyDominoes(LISTDONTHAVE)	
			   & enemyHaveExtremetie(LISTDONTHAVE,XE)
			   & .count(domino(XE,_),COUNT1)
			   & .count(domino(_,XE),COUNT2)
			   & N=COUNT1+COUNT2
.
countInY(YE,N):-refreshEnemyDominoes(LISTDONTHAVE) 
			  & enemyHaveExtremetie(LISTDONTHAVE,YE) 
			  & .count(domino(YE,_),COUNT1)
			  & .count(domino(_,YE),COUNT2) & N=COUNT1+COUNT2
.
countInX(XE,N):-refreshEnemyDominoes(LISTDONTHAVE) & not enemyHaveExtremetie(LISTDONTHAVE,XE) & N = 0.
countInY(YE,N):-refreshEnemyDominoes(LISTDONTHAVE)& not enemyHaveExtremetie(LISTDONTHAVE,YE)& N=0.
enemyHaveExtremetie([H|T],E):- (getSides(H,X,Y) & E==X | E==Y)|(enemyHaveExtremetie(T,E)).
enemyHaveExtremetie([],E):-false.



getExtremeties(X,Y):- dominosontable(LIST) & getHead(LIST,X) & getLastElement(LIST,Y).
getHead([H|T],R):-getSides(H,X,Y) & R=X.
getLastElement([H|T],R):-getLastElement(T,R).
getLastElement([H|[]],R):-getSides(H,X,Y) & R=Y.
getSides(domino(X,Y),X,Y):-true.
refreshEnemyDominoes(RESPOSTA):-allDominoes(LIST) & verifyWhatIDontHave(LIST,[],RESPOSTA).
allDominoes(RESPOSTA):-	getAllDominoes(0,6,[],RESPOSTA).
getAllDominoes(X,MAX,L,RESPOSTA):-	X<=MAX	& getFamily(X,0,MAX,L,L2)& getAllDominoes(X+1,MAX,L2,RESPOSTA).
getAllDominoes(X,MAX,L,RESPOSTA):-RESPOSTA=L.
getFamily(X,I,MAX,L,RESPOSTA):-	I<=MAX & not .member(domino(X,I),L)	& not .member(domino(I,X),L) & .concat([domino(X,I)],L,N) & getFamily(X,I+1,MAX,N,RESPOSTA).
getFamily(X,I,MAX,L,RESPOSTA):-	I<=MAX & (.member(domino(X,I),L) | .member(domino(I,X),L))	& getFamily(X,I+1,MAX,L,RESPOSTA).
getFamily(X,Y,MAX,L,RESPOSTA):-L=RESPOSTA.
verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-getSides(H,X,Y) & domino(X,Y) & verifyWhatIDontHave(T,AUXLIST,LISTDONTHAVE).
verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-getSides(H,X,Y) & not domino(X,Y) & .concat([H],AUXLIST,NLIST) & verifyWhatIDontHave(T,NLIST,LISTDONTHAVE).
verifyWhatIDontHave([],AUXLIST,LISTDONTHAVE):-LISTDONTHAVE=AUXLIST.
getReverse(A,B):- getSides(A,P,Q) & B=domino(Q,P).
{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

