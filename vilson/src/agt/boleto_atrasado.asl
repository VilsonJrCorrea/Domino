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
	
+playerturn(AGENT_NAME): .my_name(NAME) & AGENT_NAME==NAME & not dominosontable(_) 
<-
	.wait(.count((domino(_,_)),7));
	?getFirstDomino(X,Y);
	put(domino(X,Y),l);
	-domino(X,Y);
.

+playerturn(AGENT_NAME): .my_name(NAME) & AGENT_NAME\==NAME & not dominosontable(_) 
<-
	-+otherPlayerName(AGENT_NAME);
.

+playerturn(AGENT_NAME): .my_name(NAME) 
						& AGENT_NAME==NAME
//						& GOAL==play 
//						& haveDominoToPlay(DOM)
	<-
		.print("Entre aqui")
		?refreshGoal(GOAL) 
		.print("My turn ",AGENT_NAME);
	.


//==================================================rules what play
refreshGoal(GOAL):-
	getExtremeties(X,Y) & refreshEnemyDominoes(LISTDONTHAVE) & calculateProbabilityWin(X,Y,LISTDONTHAVE,P) & .print(P)
.

calculateProbabilityWin(X,Y,LISTDONTHAVE,P):-
	 allDominoes(LISTALL)
	& .length(LISTALL,TAM)
	& .print(X,Y)
	& ((X\==Y 
		& .count(domino(_,X),X2) 
		& .count(domino(Y,_),X3)
		& .count(domino(X,_),X1) 
		& .count(domino(_,Y),X4)
		& P=(X1+X2+X3+X4)/TAM ) 	 
	|(X==Y 
		& .count(domino(X,_),X1) 
		& .count(domino(_,Y),X2)
		& P=(X1+X2)/TAM))
	
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

