//%attributes = {"invisible":true}
#DECLARE($position : Text; $color : Text)

var $win; $left; $top; $right; $bottom : Integer

$win:=Open form window:C675("D_LB"; Plain form window:K39:10; Horizontally centered:K39:1; Vertically centered:K39:4)



GET WINDOW RECT:C443($left; $top; $right; $bottom)

Case of 
	: ($position="left")
		
		SET WINDOW RECT:C444($left-500; $top; $right-500; $bottom)
		
	: ($position="right")
		SET WINDOW RECT:C444($left+500; $top; $right+500; $bottom)
		
End case 


DIALOG:C40("D_LB"; New object:C1471("color"; $color; "position"; $position); *)