//domino(0,0).
//domino(5,6).
domino(4,5).
domino(1,6).
//domino(6,6).
domino(3,3).
domino(0,1).
//domino(2,2).
domino(2,6).
dominosontable([
				domino(3,0),
				domino(0,6),
				domino(6,1),
				domino(1,3),
//				domino(3,3),
				domino(3,6),
				domino(6,6),
				domino(6,4),
				domino(4,0),
				domino(0,5),
				domino(5,2),
				domino(2,3),
				domino(3,4),
				domino(4,4),
				domino(4,2),
				domino(2,6),
				domino(6,5),
				domino(5,5),
				domino(5,3)
]).

!start.

+!start : haveExtremeties(R)
	<- 
	
	?whatThatMostAppearThatIHave(QTD,P);
	.print("A PEÇA QUE EU TENHO E APARECE ",QTD," VEZES NA MESA E A ",P)
	
	
	.
+!start: not haveExtremeties(R)
	<-
		.print("Não tem extremidade")
	.

haveExtremeties(R):-
	getExtremeties(XE,YE) & (domino(XE,_)| domino(YE,_)| domino(_,XE)| domino(_,YE)).


whatThatMostAppearThatIHave(QTD,P):-
	dominosontable(TABLE) & .print(TABLE) & verifyDominonsOnTable(TABLE,0,0,QTD,VALAUX,P) .

verifyDominonsOnTable(TABLE,I,MAIOR,CONT,VALAUX,P):- 
					(I<7 & getExtremeties(XE,YE)
						 & (XE==I | YE==I)
						 & verifyHowManyHaveOnTheRest(TABLE,I,0,SUM,X) 
						 & (SUM>=MAIOR & SUM<7 &  verifyDominonsOnTable(TABLE,I+1,SUM,CONT,X,P) 
					          | (SUM<MAIOR | SUM==7) & verifyDominonsOnTable(TABLE,I+1,MAIOR,CONT,VALAUX,P)))
					| (I<7 &verifyDominonsOnTable(TABLE,I+1,MAIOR,CONT,VALAUX,P)).

verifyDominonsOnTable(TABLE,I,MAIOR,CONT,VALAUX,P):-CONT=MAIOR & P=VALAUX.

verifyHowManyHaveOnTheRest([H|T],I,N,SUM,VAL):-
					getSides(H,X,Y) & (X==I | Y==I) & verifyHowManyHaveOnTheRest(T,I,N+1,SUM,VAL).
					
verifyHowManyHaveOnTheRest([H|T],I,N,SUM,VAL):- getSides(H,X,Y) & (X\==I | Y\==I) & verifyHowManyHaveOnTheRest(T,I,N,SUM,VAL).
verifyHowManyHaveOnTheRest([],I,N,SUM,VAL):-SUM=N & VAL=I.



getHead([H|T],R):-getSides(H,X,Y) & R=X.
getLastElement([H|T],R):-getLastElement(T,R).
getLastElement([H|[]],R):-getSides(H,X,Y) & R=Y.
getSides(domino(X,Y),X,Y):-true.
getExtremeties(X,Y):- dominosontable(LIST) & getHead(LIST,X) & getLastElement(LIST,Y).


//
//refreshGoal(GOAL):-
//	getExtremeties(X,Y) &
//	 refreshEnemyDominoes(LIST)
//.
//
//
//getExtremeties(X,Y):-
//	dominosontable(LIST) & getHead(LIST,X) & getLastElement(LIST,Y)
//.
//getHead([H|T],R):-getSides(H,X,Y) & R=X.
//getLastElement([H|T],R):-getLastElement(T,R).
//getLastElement([H|[]],R):-getSides(H,X,Y) & R=X.
getSides(domino(X,Y),X,Y):-true.
//
//refreshEnemyDominoes(RESPOSTA):-
//	allDominoes(LIST) & verifyWhatIDontHave(LIST,[],LISTDONTHAVE) & .print("LIST DONT HAVE ",LISTDONTHAVE)
//.
//
//verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-
//	getSides(H,X,Y) & domino(X,Y) & verifyWhatIDontHave(T,AUXLIST,LISTDONTHAVE)
//.
//verifyWhatIDontHave([H|T],AUXLIST,LISTDONTHAVE):-
//	getSides(H,X,Y) & not domino(X,Y) & .concat([H],AUXLIST,NLIST) & verifyWhatIDontHave(T,NLIST,LISTDONTHAVE)
//.
//verifyWhatIDontHave([],AUXLIST,LISTDONTHAVE):-
//	LISTDONTHAVE=AUXLIST
//.
//
//
//
//
//
//
//getAllDominoes(X,MAX,L,RESPOSTA):-
//	X<=MAX 
//	& getFamily(X,0,MAX,L,L2)
//	& getAllDominoes(X+1,MAX,L2,RESPOSTA)
//.
//
//getAllDominoes(X,MAX,L,RESPOSTA):-
//	RESPOSTA=L
//.
//
//getFamily(X,I,MAX,L,RESPOSTA):-
//	I<=MAX 
//	& not .member(domino(X,I),L) 
//	& not .member(domino(I,X),L) 
//	& .concat([domino(X,I)],L,N) 
//	& getFamily(X,I+1,MAX,N,RESPOSTA)
//.
//getFamily(X,I,MAX,L,RESPOSTA):-
//	I<=MAX 
//	& (.member(domino(X,I),L) | .member(domino(I,X),L))
//	& getFamily(X,I+1,MAX,L,RESPOSTA)
//.
//
//getFamily(X,Y,MAX,L,RESPOSTA):-
//	L=RESPOSTA
//.
//
//
//
////getFirstDomino(X1,Y1):-
////	 (domino(X1,Y1)
////	& X1==Y1
////	& not(domino(X2,Y2)
////			& X2==Y2	
////			& X2 > X1))
////.
////getFirstDomino(X1,Y1):-
////	 (domino(X1,Y1)
////	& X1\==Y1
////	& S1 = X1+Y1
////	& not(domino(X2,Y2)
////			& X2\==Y2
////			& S2 = X2+Y2	
////			& S2 > S1))
////.
//
//
//
//
//
//
////	.send(AGENT_NAME,tell, domino(666,666));
////	.send(AGENT_NAME,askOne,domino(0,Y1),A);
////	.send(AGENT_NAME,askOne,domino(1,Y2),B);
////	.send(AGENT_NAME,askOne,domino(2,Y3),C);
////	.send(AGENT_NAME,askOne,domino(3,Y4),D);
////	.send(AGENT_NAME,askOne,domino(4,Y5),E);
////	.send(AGENT_NAME,askOne,domino(5,Y6),F);
////	.send(AGENT_NAME,askOne,domino(6,Y7),G);
////	.send(AGENT_NAME,askOne,domino(Y8,0),H);
////	.send(AGENT_NAME,askOne,domino(Y9,1),I);
////	.send(AGENT_NAME,askOne,domino(Y10,2),J);
////	.send(AGENT_NAME,askOne,domino(Y11,3),K);
////	.send(AGENT_NAME,askOne,domino(Y12,4),L);
////	.send(AGENT_NAME,askOne,domino(Y13,5),M);
////	.send(AGENT_NAME,askOne,domino(Y14,6),N);
////	.print(A);
////	.print(B);
////	.print(C);
////	.print(D);
////	.print(E);
////	.print(F);
////	.print(G);
////	.print(K);
////	.print(L);
////	.print(M);
////	.print(N);
////	.print("VOLTOU")
////	.send(AGENT_NAME,achieve, late);
////	put(domino(X,Y),l);
////	-domino(X,Y);
//




{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

