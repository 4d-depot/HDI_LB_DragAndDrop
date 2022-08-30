var $i; $j; $rnd; $order : Integer
var $color; $shape : Text


Case of 
	: (Form event code:C388=On Load:K2:1)
		
		Form:C1466.collection1:=New collection:C1472
		Form:C1466.collection2:=New collection:C1472
		Form:C1466.collection3:=New collection:C1472
		
		For ($i; 1; 12)  //
			For ($j; 1; 3)
				
				$color:=Choose:C955(Random:C100%3; "LimeGreen"; "DodgerBlue"; "violet")
				$rnd:=Random:C100%3
				$shape:=Choose:C955($rnd; "■"; "●"; "▲")
				$order:=Choose:C955($rnd; 1; 2; 3)
				
				Case of 
					: ($j=1)
						Form:C1466.collection1.push(New object:C1471("color"; $color; "shape"; $shape; "order"; $order))
					: ($j=2)
						Form:C1466.collection2.push(New object:C1471("color"; $color; "shape"; $shape; "order"; $order))
					: ($j=3)
						Form:C1466.collection3.push(New object:C1471("color"; $color; "shape"; $shape; "order"; $order))
				End case 
				
			End for 
		End for 
		
		OBJECT SET RGB COLORS:C628(*; "Sample"; Form:C1466.color)
		
	: (Form event code:C388=On Close Box:K2:21)
		
		CANCEL:C270
		
End case 
