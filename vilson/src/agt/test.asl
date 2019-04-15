//domino(0,0).
domino(5,6).
domino(4,5).
domino(1,6).
//domino(6,6).
//domino(3,3).
domino(0,1).
//domino(2,2).
domino(2,6).


!start.

+!start : true 
	<- 
		?getFirstDomino(X1,Y1);
		.print(X1," ",Y1);
	.
	
getFirstDomino(X1,Y1):-
	 (domino(X1,Y1)
	& X1==Y1
	& not(domino(X2,Y2)
			& X2==Y2	
			& X2 > X1))
.
getFirstDomino(X1,Y1):-
	 (domino(X1,Y1)
	& X1\==Y1
	& S1 = X1+Y1
	& not(domino(X2,Y2)
			& X2\==Y2
			& S2 = X2+Y2	
			& S2 > S1))
.












{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

