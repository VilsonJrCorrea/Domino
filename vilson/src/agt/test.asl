domino(domino(0,0)).
domino(domino(1,6)).
domino(domino(6,6)).
domino(domino(3,3)).
domino(domino(0,1)).
domino(domino(2,2)).
domino(domino(2,6)).

!start.

+!start : true 
	<- 
		?getFirstDomino(DOMINO);
		.print(DOMINO);
	.
	
//+hand(DOMINO):true
//	<-
//		+domino(DOMINO);
//		.print("Recebida ",DOMINO);
//	.
	
//+dominosontable(LIST):true
//	<-
//		.print("Pe�as na mesa ",LIST);
//	.
//	
//+playerturn(AGENT_NAME):name(NAME) & AGENT_NAME=NAME & not dominosontable(_) 
//<-
//	.wait(.count(domino(domino(_,_)),7));
//	?getFirstDomino(DOUBLE);
//	.print("|||||||||||||||Better double ",DOUBLE);
//	put(DOUBLE,l);
//	.print("PE�A JOGADA ",DOUBLE);
//.

//+playerturn(AGENT_NAME):name(NAME) & AGENT_NAME=NAME
//<-
//	.print("My turn ",AGENT_NAME);
//	!chooseAndPut;
//.


//+!chooseAndPut:true
//	<-
//		?getBetterDouble(R);
//.

//REGRAS--------------------------------------------------------------------------gx ----------------
getFirstDomino(DOMINO1):-
	 domino(DOMINO1)
	& getSides(DOMINO1,X1,Y1)
	&.print("---------------------------",DOMINO1,"---------------------------------")
	& not(domino(DOMINO2)
			& getSides(DOMINO2,X2,Y2)
			& .print("Domino 1 ",DOMINO1," Domino 2 ",DOMINO2 )
			&  X2\==Y2 & X1==Y1
	//		& not (X1<X2 & Y1<Y2)			
	//	&   DOMINO1==DOMINO2 
	//QUANDO FOR VERDADE QUALQUER CONDI��O ELE SAI		
	)
.


//getBetterDouble(DOMINO1):-
//	 domino(DOMINO1)
//	& getSides(DOMINO1,X1,Y1)
//	& not(domino(DOMINO2) 
//		& .print("Domino 1 ",DOMINO1," Domino 2",DOMINO2 )
//		& getSides(DOMINO2,X2,Y2) 
//		& X2==Y2 & X1\==Y1
//	)
//.

getSides(domino(X,Y),X,Y):-true.














{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

