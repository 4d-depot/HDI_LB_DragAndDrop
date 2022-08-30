//%attributes = {"invisible":true}
var $i; $j; $rnd; $order : Integer
var $shape; $color : Text

Form:C1466.moves:=0

Form:C1466.col1:=New collection:C1472
Form:C1466.col2:=New collection:C1472
Form:C1466.col3:=New collection:C1472

For ($j; 1; 3)
	For ($i; 1; 8)  //
		
		$color:=Choose:C955(Random:C100%3; "LimeGreen"; "DodgerBlue"; "violet")
		$rnd:=Random:C100%3
		$shape:=Choose:C955($rnd; "■"; "●"; "▲")
		$order:=Choose:C955($rnd; 1; 2; 3)
		
		Case of 
			: ($j=1)
				Form:C1466.col1.push(New object:C1471("color"; $color; "shape"; $shape; "order"; $order))
			: ($j=2)
				Form:C1466.col2.push(New object:C1471("color"; $color; "shape"; $shape; "order"; $order))
			: ($j=3)
				Form:C1466.col3.push(New object:C1471("color"; $color; "shape"; $shape; "order"; $order))
		End case 
		
	End for 
End for 

OBJECT SET RGB COLORS:C628(*; "Sample1"; "LimeGreen")
OBJECT SET RGB COLORS:C628(*; "Sample2"; "DodgerBlue")
OBJECT SET RGB COLORS:C628(*; "Sample3"; "Violet")

