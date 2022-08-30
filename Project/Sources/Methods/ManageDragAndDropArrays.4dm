//%attributes = {"invisible":true}
// This method uses Form.drag as an object, beware not to use this attribute elsewhere in your code

#DECLARE()->$accept : Integer

var $listBoxName : Text
var $columnPtr; $listboxPtr : Pointer
var $indices; $values : Collection
var $i; $n; $p : Integer

ARRAY TEXT:C222($arrColNames; 0)
ARRAY TEXT:C222($arrHeaderNames; 0)
ARRAY POINTER:C280($arrColVars; 0)
ARRAY POINTER:C280($arrHeaderVars; 0)
ARRAY POINTER:C280($arrStyles; 0)

ARRAY BOOLEAN:C223($arrColsVisible; 0)

$listBoxName:=OBJECT Get name:C1087(Object current:K67:2)
LISTBOX GET ARRAYS:C832(*; $listBoxName; $arrColNames; $arrHeaderNames; $arrColVars; $arrHeaderVars; $arrColsVisible; $arrStyles)
$columnPtr:=OBJECT Get pointer:C1124(Object named:K67:5; $arrColNames{1})  // source during drag, target during drop (can be the same)
$listboxPtr:=OBJECT Get pointer:C1124(Object named:K67:5; $listBoxName)

Case of 
		
	: (Form event code:C388=On Begin Drag Over:K2:44)
		
		Form:C1466.drag:=New object:C1471
		Form:C1466.drag.sourceName:=$listBoxName
		Form:C1466.drag.sourceColumnPtr:=$columnPtr
		
		$indices:=New collection:C1472()
		$values:=New collection:C1472()
		
		$n:=0
		Repeat 
			$n:=Find in array:C230($listboxPtr->; True:C214; $n+1)
			If ($n>0)
				$indices.push($n)  // indices
				$values.push($columnPtr->{$n})  // values
			End if 
		Until ($n<0)
		
		Form:C1466.drag.indices:=$indices.reverse()  // will be reordered "on drop"
		Form:C1466.drag.values:=$values.reverse()  // will be reordered "on drop"
		
		
	: (Form event code:C388=On Drag Over:K2:13)
		
		If (Undefined:C82(Form:C1466.drag))
			//reject anything that does NOT come from a listbox
			$accept:=-1
		Else 
			$accept:=0
		End if 
		
	: (Form event code:C388=On Drop:K2:12)
		
		
		If (Not:C34(Undefined:C82(Form:C1466.drag)))
			
			$p:=Drop position:C608
			If ($p<0)  // Drop after the last row of the listbox
				$p:=Size of array:C274($columnPtr->)+1
			Else 
				$p:=$p+1
			End if 
			
			
			If (Form:C1466.drag.sourceName#$listBoxName)  // EXTERNAL LISTBOX
				
				
				For ($i; 0; Form:C1466.drag.indices.length-1)
					
					// insert in TARGET 
					INSERT IN ARRAY:C227($columnPtr->; $p; 1)  // always at the same position, reordering reversed items :-)
					$columnPtr->{$p}:=Form:C1466.drag.values[$i]
					
					// remove from SOURCE
					DELETE FROM ARRAY:C228(Form:C1466.drag.sourceColumnPtr->; Form:C1466.drag.indices[$i]; 1)
				End for 
				
				//Unselect in source what has been dragged
				LISTBOX SELECT ROW:C912(*; Form:C1466.drag.sourceName; 0; lk remove from selection:K53:3)  // UNselect everything in source
				
			Else   // REORDER LISTBOX
				
				// remove from SOURCE
				For ($i; 0; Form:C1466.drag.indices.length-1)
					DELETE FROM ARRAY:C228(Form:C1466.drag.sourceColumnPtr->; Form:C1466.drag.indices[$i]; 1)
					If (Form:C1466.drag.indices[$i]<$p)
						$p:=$p-1
					End if 
				End for 
				// insert in TARGET (same as source)
				For ($i; 0; Form:C1466.drag.indices.length-1)
					// insert in target collection
					INSERT IN ARRAY:C227($columnPtr->; $p; 1)  // always at the same position, reordering reversed items :-)
					$columnPtr->{$p}:=Form:C1466.drag.values[$i]
				End for 
				
				
			End if 
			
			//Unselect everything in target
			LISTBOX SELECT ROW:C912(*; $listBoxName; 0; lk remove from selection:K53:3)  // UNselect everything
			//Select what has been dropped
			For ($i; 0; Form:C1466.drag.indices.length-1)
				LISTBOX SELECT ROW:C912(*; $listBoxName; $p+$i; lk add to selection:K53:2)
			End for 
			
			OB REMOVE:C1226(Form:C1466; "drag")
			
		Else 
			
			// NEVER, (REJECTED DURING ON DRAG OVER)
			
		End if 
		
End case 