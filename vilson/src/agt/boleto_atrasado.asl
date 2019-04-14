!start.

+!start : true 
	<- 
		join;
	.
	
+hand(DOMINO):true
	<-
		+domino(DOMINO);
		.print("Recebida ",DOMINO);
	.
	
+dominosontable(LIST):true
	<-
		.print("Peças na mesa ",LIST);
	.
	
+playerturn(AGENT_NAME):name(NAME) & AGENT_NAME=NAME & not dominosontable(_) 
<-
	.wait(.count(domino(domino(_,_)),7));
	?getFirstDomino(DOUBLE);
	.print("|||||||||||||||Better double ",DOUBLE);
	put(DOUBLE,l);
	.print("PEÇA JOGADA ",DOUBLE);
.

+playerturn(AGENT_NAME):name(NAME) & AGENT_NAME=NAME
<-
	.print("My turn ",AGENT_NAME);
	!chooseAndPut;
.


+!chooseAndPut:true
	<-
		?getBetterDouble(R);
.

//REGRAS--------------------------------------------------------------------------gx ----------------
getFirstDomino(DOMINO1):-
	 domino(DOMINO1)
	& getSides(DOMINO1,X1,Y1)
	& not(domino(DOMINO2) 
		& .print("Domino 1 ",DOMINO1," Domino 2 ",DOMINO2 )
		& getSides(DOMINO2,X2,Y2) 
		& X2==Y2 
		& X1\==Y1
//		& X1 < X2
//		& X1 < Y2
//		& Y1 < X2
//		& Y1 < Y2
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

