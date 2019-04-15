!start.

+!start : true 
	<- 
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
	
+playerturn(AGENT_NAME): name(NAME) & AGENT_NAME=NAME & not dominosontable(_) 
<-
	.wait(.count((domino(_,_)),7));
	?getFirstDomino(X,Y);
	.print("First domino ",X," ",Y);
	put(domino(X,Y),l);
//	.print("PEÇA JOGADA ",DOUBLE);
.

+playerturn(AGENT_NAME): .my_name(NAME) & AGENT_NAME=NAME
	<-
		.print("My turn ",AGENT_NAME);
//		!chooseAndPut;
.


+!chooseAndPut:true
	<-
	true
//		?getBetterDouble(R);
.

//REGRAS-------------------------------------------------------------------------- ----------------
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














{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

