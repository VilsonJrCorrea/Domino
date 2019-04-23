!start.
+!start : true 
	<- 
		?allDominoes(RESPOSTA);
		+allDominoes(RESPOSTA);
		join;
	.
	
+hand(DOMINO):true
	<-
		+DOMINO;
		.print("Recebida ",DOMINO);
	.
	
+dominosontable(LIST):true
	<-
		.print("Peças na mesa ",LIST);
	.
	
+playerturn(AGENT_NAME): .my_name(NAME) & AGENT_NAME==NAME & not dominosontable(_) & not win(_)
<-
	.wait(.count((domino(_,_)),7));
	?getFirstDomino(X,Y);
	put(domino(X,Y),l);
	-domino(X,Y);
.

+playerturn(AGENT_NAME): .my_name(NAME) & AGENT_NAME\==NAME & not dominosontable(_)  & not win(_)
<-
	-+otherPlayerName(AGENT_NAME);
.

+playerturn(AGENT_NAME): .my_name(NAME) 
						& AGENT_NAME==NAME
						& not planning
						& not win(_)
						<-
							+planning
							!updateGoal;
							!play
						.
+sucessfullput(DOMINO):true
	<-
		.print("Domino full put with sucess ",DOMINO)
	.
	
+draw:true
	<-
		.print("Draw match")
	.
+!updateGoal: not win(_)
	<-
		?refreshGoal(GOAL);
		-goal(_);
		+goal(GOAL);
.
+!dropDominoOfBelief(DOMINO):true
	<-
		-DOMINO;
		?getReverse(DOMINO,RDOMINO);
		-RDOMINO;
	.
	
+!play: goal(win) & haveExtremeties & getDominoToWin(DOMINO,SIDE)
	<-
		put(DOMINO,SIDE);
		!dropDominoOfBelief(DOMINO);
		-planning;
	.
	
+!play: goal(win) & not haveExtremeties 
<-
	.print("Goal is WIN, but i don't have the extremeties!'");
	!buy;
	!updateGoal;
	?goal(GOAL);
	.print("Goal updated ",GOAL);
	!play;
.	
	
+!play: goal(draw) & haveExtremeties & getDominoToDraw(DOMINO,SIDE)
	<-
		put(DOMINO,SIDE);
		!dropDominoOfBelief(DOMINO);
		-planning;
	.

+!play: goal(draw) & not haveExtremeties 
	<-
		.print("Goal is DRAW, but i don't have the extremeties!");
		!buy;
		!updateGoal;
		?goal(GOAL);
		.print("Goal updated ",GOAL);
		!play;
	.
	
	
+!play:  goal(lose) 
	<-
		.print("Goal lose")
	.

-!play: not win(_)
	<-
		!buy;
		!updateGoal;
		?goal(GOAL);
		.print("##############>Goal updated ",GOAL);
		!play;
	.
+!buy:true
	<-
	getdomino(NEWDOMINO);
	+NEWDOMINO;
	.print("New domino buyed ",NEWDOMINO);
.
-!buy:true
	<-
		.print("Passing the turn");
		passturn;
	.


//DRAW--------------------------------------------------------------------------------------------------
getDominoToDraw(DOMINO,SIDE):- whatThatMostAppearThatIHave(QTD,P) &chooseDominoToDraw(P,DOM) & whatSidePlay(DOM,SIDE,DOMINO).
whatThatMostAppearThatIHave(QTD,P):- dominosontable(TABLE) & verifyDominonsOnTable(TABLE,0,0,QTD,VALAUX,P) .
verifyDominonsOnTable(TABLE,I,MAIOR,CONT,VALAUX,P):- 
					(I<7 & getExtremeties(XE,YE)
						 & (XE==I | YE==I)
						 & verifyHowManyHaveOnTheRest(TABLE,I,0,SUM,X) 
						 & (SUM>=MAIOR & SUM<7 &  verifyDominonsOnTable(TABLE,I+1,SUM,CONT,X,P) 
					          | (SUM<MAIOR | SUM==7) & verifyDominonsOnTable(TABLE,I+1,MAIOR,CONT,VALAUX,P)))
					| (I<7 &verifyDominonsOnTable(TABLE,I+1,MAIOR,CONT,VALAUX,P)).
verifyDominonsOnTable(TABLE,I,MAIOR,CONT,VALAUX,P):-CONT=MAIOR & P=VALAUX.
verifyHowManyHaveOnTheRest([H|T],I,N,SUM,VAL):-	getSides(H,X,Y) & (X==I | Y==I) & verifyHowManyHaveOnTheRest(T,I,N+1,SUM,VAL).
verifyHowManyHaveOnTheRest([H|T],I,N,SUM,VAL):- getSides(H,X,Y) & (X\==I | Y\==I) & verifyHowManyHaveOnTheRest(T,I,N,SUM,VAL).
verifyHowManyHaveOnTheRest([],I,N,SUM,VAL):-SUM=N & VAL=I.
haveExtremeties:- getExtremeties(XE,YE) & (domino(XE,_)| domino(YE,_)| domino(_,XE)| domino(_,YE)).
chooseDominoToDraw(P,DOMINO):-	.count(domino(P,_),COUNT)& COUNT > 0 & biggerInRigth(DOMINO,P,6).
chooseDominoToDraw(P,DOMINO):-	.count(domino(_,P),COUNT)& COUNT>0   & biggerInLeft(DOMINO,P,6).
biggerInRigth(DOMINO,N,M):-	.count(domino(N,M),COUNT)&((COUNT>0 & DOMINO = domino(N,M))|(COUNT==0&biggerInRigth(DOMINO,N,M-1))).
biggerInLeft(DOMINO,N,M):- .count(domino(M,N),COUNT) &((COUNT>0	& DOMINO=domino(M,N))|COUNT==0 & biggerInLeft(DOMINO,N,M-1)).

//getBiggerInLeft(X,I,DOM):- .count(domino(X,I),CONT) & CONT>0 & DOM = domino(X,I).
//getBiggerInLeft(X,I,DOM):- .count(domino(X,I),CONT) & CONT==0 & getBiggerInLeft(X,I-1,DOM).
//getBiggerInRight(X,I,DOM):- .count(domino(I,X),CONT)& CONT>0 & DOM=domino(I,X).
//getBiggerInRight(X,I,DOM):- .count(domino(I,X),CONT) & CONT==0 & getBiggerInRight(X,I-1,DOM).

whatSidePlay(DOMINO,SIDE,R):- getExtremeties(XE,YE)	& getSides(DOMINO,X,Y) & XE == X & getReverse(DOMINO,NDOMINO) & R = NDOMINO	& SIDE = l.
whatSidePlay(DOMINO,SIDE,R):- getExtremeties(XE,YE) & getSides(DOMINO,X,Y) & X == YE & R = DOMINO & SIDE = r.
whatSidePlay(DOMINO,SIDE,R):- getExtremeties(XE,YE)	& getSides(DOMINO,X,Y) & Y == YE & getReverse(DOMINO,NDOMINO) & R = NDOMINO	& SIDE = r.
whatSidePlay(DOMINO,SIDE,R):-getExtremeties(XE,YE) & getSides(DOMINO,X,Y) & Y == XE & R = DOMINO & SIDE = l.


//RULES
refreshGoal(GOAL):-
	getExtremeties(X,Y) 
	& refreshEnemyDominoes(LISTDONTHAVE) 
	& calculateProbabilityWin(X,Y,LISTDONTHAVE,PROBABILITY)
	& chooseGoal(PROBABILITY,GOAL)
	& .print(GOAL," - probability of lose ",PROBABILITY)
.

//WIN-------------------------------------------------------------------
getDominoToWin(DOM,l):- getExtremeties(X,Y) & .count(domino(X,_),CONT) & CONT > 0	& getBiggerInLeft(X,6,AUX) & getReverse(AUX,DOM).
getDominoToWin(DOM,l):- getExtremeties(X,Y) & .count(domino(_,X),CONT) & CONT > 0	& getBiggerInRight(X,6,DOM).
getDominoToWin(DOM,r):- getExtremeties(X,Y) & .count(domino(Y,_),CONT) & CONT > 0	& getBiggerInLeft(Y,6,DOM).
getDominoToWin(DOM,r):- getExtremeties(X,Y) & .count(domino(_,Y),CONT) & CONT > 0	& getBiggerInRight(Y,6,AUX)	& getReverse(AUX,DOM).
calculateProbabilityWin(X,Y,LISTDONTHAVE,R):-
	 allDominoes(LISTALL)
	& .length(LISTALL,TAM)
	& .length(LISTDONTHAVE,TAMDONT)
	& .count(domino(_,_),TAMHAND)
	& ((X\==Y 
		& .count(domino(_,X),X2) 
		& .count(domino(Y,_),X3)
		& .count(domino(X,_),X1) 
		& .count(domino(_,Y),X4)
		& P=(X1+X2+X3+X4)) 	 
	|(X==Y 
		& .count(domino(X,_),X1) 
		& .count(domino(_,Y),X2)
		& P=(X1+X2)))
	& P1 = P/TAM
	& NAMAO=TAMHAND-P
	& P2 = NAMAO/TAMDONT
	& R = P2-P1
.

getBiggerInLeft(X,I,DOM):- .count(domino(X,I),CONT) & CONT>0 & DOM = domino(X,I).
getBiggerInLeft(X,I,DOM):- .count(domino(X,I),CONT) & CONT==0 & getBiggerInLeft(X,I-1,DOM).
getBiggerInRight(X,I,DOM):- .count(domino(I,X),CONT)& CONT>0 & DOM=domino(I,X).
getBiggerInRight(X,I,DOM):- .count(domino(I,X),CONT) & CONT==0 & getBiggerInRight(X,I-1,DOM).
getReverse(A,B):- getSides(A,P,Q) & B=domino(Q,P).
chooseGoal(PROBABILITY,GOAL):- PROBABILITY<0.2 & GOAL=win.
chooseGoal(PROBABILITY,GOAL):- PROBABILITY>=0.2 & PROBABILITY<=0.95 & GOAL=draw.
chooseGoal(PROBABILITY,GOAL):- PROBABILITY>0.95 & GOAL=lose.
getHead([H|T],R):-getSides(H,X,Y) & R=X.
getLastElement([H|T],R):-getLastElement(T,R).
getLastElement([H|[]],R):-getSides(H,X,Y) & R=Y.
getSides(domino(X,Y),X,Y):-true.
getExtremeties(X,Y):- dominosontable(LIST) & getHead(LIST,X) & getLastElement(LIST,Y).
refreshEnemyDominoes(RESPOSTA):-allDominoes(LIST) & verifyWhatIDontHave(LIST,[],RESPOSTA).
verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-getSides(H,X,Y) & domino(X,Y) & verifyWhatIDontHave(T,AUXLIST,LISTDONTHAVE).
verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-getSides(H,X,Y) & not domino(X,Y) & .concat([H],AUXLIST,NLIST) & verifyWhatIDontHave(T,NLIST,LISTDONTHAVE).
verifyWhatIDontHave([],AUXLIST,LISTDONTHAVE):-LISTDONTHAVE=AUXLIST.
getFirstDomino(X1,Y1):- domino(X1,Y1)& X1==Y1& not(domino(X2,Y2)& X2==Y2& X2 > X1).
getFirstDomino(X1,Y1):- domino(X1,Y1)& X1 \== Y1 & S1=X1+Y1 & not(domino(X2,Y2) & X2\==Y2 & S2=X2+Y2 & S2>S1).
allDominoes(RESPOSTA):-	getAllDominoes(0,6,[],RESPOSTA).
getAllDominoes(X,MAX,L,RESPOSTA):-	X<=MAX	& getFamily(X,0,MAX,L,L2)& getAllDominoes(X+1,MAX,L2,RESPOSTA).
getAllDominoes(X,MAX,L,RESPOSTA):-RESPOSTA=L.
getFamily(X,I,MAX,L,RESPOSTA):-	I<=MAX & not .member(domino(X,I),L)	& not .member(domino(I,X),L) & .concat([domino(X,I)],L,N) & getFamily(X,I+1,MAX,N,RESPOSTA).
getFamily(X,I,MAX,L,RESPOSTA):-	I<=MAX & (.member(domino(X,I),L) | .member(domino(I,X),L))	& getFamily(X,I+1,MAX,L,RESPOSTA).
getFamily(X,Y,MAX,L,RESPOSTA):-L=RESPOSTA.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

