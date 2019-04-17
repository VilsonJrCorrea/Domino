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
+!updateGoal: true
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
	
+!play: goal(win) & haveDominoToPlay(DOMINO,SIDE)
	<-
		put(DOMINO,SIDE);
		!dropDominoOfBelief(DOMINO);
		-planning;
	.
	
+!play: goal(draw) 
	<-
		.print("Goal draw ")
	.
	
+!play:  goal(lose) 
	<-
		.print("Goal lose")
	.

-!play: true
	<-
		!buy;
		!updateGoal;
		?goal(GOAL);
		.print("Goal updated ",GOAL);
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
//==================================================rules what play
getBiggerInLeft(X,I,DOM):- .count(domino(X,I),CONT) 
							& CONT>0 
							& DOM = domino(X,I).

getBiggerInLeft(X,I,DOM):- .count(domino(X,I),CONT) 
							& CONT==0 
							& getBiggerInLeft(X,I-1,DOM).

getBiggerInRight(X,I,DOM):- .count(domino(I,X),CONT) 
							& CONT>0 
							& DOM=domino(I,X).
							
getBiggerInRight(X,I,DOM):- .count(domino(I,X),CONT) 
							& CONT==0 
							& getBiggerInRight(X,I-1,DOM).
							
getReverse(A,B):- getSides(A,P,Q) & B=domino(Q,P).

haveDominoToPlay(DOM,l):-
	goal(win)
	& getExtremeties(X,Y) 
	& .count(domino(X,_),CONT)
	& CONT > 0
	& getBiggerInLeft(X,6,AUX)
	& getReverse(AUX,DOM)
.
haveDominoToPlay(DOM,l):-
	goal(win)
	& getExtremeties(X,Y) 
	& .count(domino(_,X),CONT)
	& CONT > 0
	& getBiggerInRight(X,6,DOM)
.

haveDominoToPlay(DOM,r):-
	goal(win)
	& getExtremeties(X,Y) 
	& .count(domino(Y,_),CONT)
	& CONT > 0
	& getBiggerInLeft(Y,6,DOM)
.

haveDominoToPlay(DOM,r):-
	goal(win)
	& getExtremeties(X,Y) 
	& .count(domino(_,Y),CONT)
	& CONT > 0
	& getBiggerInRight(Y,6,AUX)
	& getReverse(AUX,DOM)
.




refreshGoal(GOAL):-
	getExtremeties(X,Y) 
	& refreshEnemyDominoes(LISTDONTHAVE) 
	& calculateProbabilityWin(X,Y,LISTDONTHAVE,PROBABILITY)
	& chooseGoal(PROBABILITY,GOAL)
	& .print(GOAL," - probability of lose ",PROBABILITY)
.

chooseGoal(PROBABILITY,GOAL):- PROBABILITY<0.5 & GOAL=win.
chooseGoal(PROBABILITY,GOAL):- PROBABILITY>=0.5 & PROBABILITY<=0.95 & GOAL=draw.
chooseGoal(PROBABILITY,GOAL):- PROBABILITY>0.95 & GOAL=lose.

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

getExtremeties(X,Y):-
	dominosontable(LIST) & getHead(LIST,X) & getLastElement(LIST,Y)
.
getHead([H|T],R):-getSides(H,X,Y) & R=X.
getLastElement([H|T],R):-getLastElement(T,R).
getLastElement([H|[]],R):-getSides(H,X,Y) & R=X.
getSides(domino(X,Y),X,Y):-true.

refreshEnemyDominoes(RESPOSTA):-
	allDominoes(LIST) & verifyWhatIDontHave(LIST,[],RESPOSTA)
.

verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-
	getSides(H,X,Y) & domino(X,Y) & verifyWhatIDontHave(T,AUXLIST,LISTDONTHAVE)
.
verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-
	getSides(H,X,Y) & not domino(X,Y) & .concat([H],AUXLIST,NLIST) & verifyWhatIDontHave(T,NLIST,LISTDONTHAVE)
.
verifyWhatIDontHave([],AUXLIST,LISTDONTHAVE):-
	LISTDONTHAVE=AUXLIST
.



//=====================================================Rules start
getFirstDomino(X1,Y1):-
	 domino(X1,Y1)
	& X1==Y1
	& not(domino(X2,Y2)
			& X2==Y2	
			& X2 > X1)
.
getFirstDomino(X1,Y1):-
	 domino(X1,Y1)
	& X1\==Y1
	& S1 = X1+Y1
	& not(domino(X2,Y2)
			& X2\==Y2
			& S2 = X2+Y2	
			& S2 > S1)
.

allDominoes(RESPOSTA):-
	getAllDominoes(0,6,[],RESPOSTA)
.
getAllDominoes(X,MAX,L,RESPOSTA):-
	X<=MAX 
	& getFamily(X,0,MAX,L,L2)
	& getAllDominoes(X+1,MAX,L2,RESPOSTA)
.

getAllDominoes(X,MAX,L,RESPOSTA):-
	RESPOSTA=L
.

getFamily(X,I,MAX,L,RESPOSTA):-
	I<=MAX 
	& not .member(domino(X,I),L) 
	& not .member(domino(I,X),L) 
	& .concat([domino(X,I)],L,N) 
	& getFamily(X,I+1,MAX,N,RESPOSTA)
.
getFamily(X,I,MAX,L,RESPOSTA):-
	I<=MAX 
	& (.member(domino(X,I),L) | .member(domino(I,X),L))
	& getFamily(X,I+1,MAX,L,RESPOSTA)
.

getFamily(X,Y,MAX,L,RESPOSTA):-
	L=RESPOSTA
.













{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

