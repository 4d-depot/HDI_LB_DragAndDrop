//%attributes = {"invisible":true}

var $colCollection; $colColors; $success; $colCheck : Collection
var $i; $j; $p; $minOrder : Integer

If (Form:C1466.moves#0)
	OBJECT SET VISIBLE:C603(*; "moves"; True:C214)
	OBJECT SET TITLE:C194(*; "moves"; String:C10(Form:C1466.moves)+"\n moves")
Else 
	OBJECT SET VISIBLE:C603(*; "moves"; False:C215)
End if 

$colCollection:=New collection:C1472(Form:C1466.col1; Form:C1466.col2; Form:C1466.col3)
$colColors:=New collection:C1472("LimeGreen"; "DodgerBlue"; "violet")
$success:=New collection:C1472(True:C214; True:C214; True:C214)

For ($i; 0; 2)
	
	$colCheck:=$colCollection[$i]
	If ($colCheck.length>0)
		
		$minOrder:=0
		For ($j; 0; $colCheck.length-1)
			
			If ($colCheck[$j].color=$colColors[$i])
				If ($colCheck[$j].order>=$minOrder)
					$minOrder:=$colCheck[$j].order
				Else 
					$success[$i]:=False:C215  // this column is not ordered yet
				End if 
			Else 
				$success[$i]:=False:C215  // this column can't be ok but the "other one" neither
				
				$p:=$colColors.indexOf($colCheck[$j].color)
				$success[$p]:=False:C215
				
			End if 
			
		End for 
	Else 
		$success[$i]:=False:C215
	End if 
End for 

For ($i; 0; 2)
	OBJECT SET VISIBLE:C603(*; "success"+String:C10($i+1); $success[$i])
End for 

OBJECT SET VISIBLE:C603(*; "fireWorks@"; ($success[0] & $success[1] & $success[2]))



