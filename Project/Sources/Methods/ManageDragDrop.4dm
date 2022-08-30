//%attributes = {"invisible":true}

// $collection is used
// - as SOURCE during the "On Begin Drag Over" event
// - as TARGET during the "On Drop" event

// $collectionValues are the SOURCE values, used during  "On Begin Drag Over" event only

// This method uses Form.drag as an object, beware not to use this attribute elsewhere in your code

#DECLARE($collection : Collection; $collectionValues : Collection)->$accept : Integer

var $listBoxName : Text
var $columnPtr; $listboxPtr : Pointer
var $indices; $values : Collection
var $i; $n; $p : Integer
var $index : Integer

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
		
	: (Form event code:C388=On Begin Drag Over:K2:44)  // -------------------------------------------- On Begin Drag Over
		
		Form:C1466.drag:=New object:C1471
		Form:C1466.drag.source:=$collection
		Form:C1466.drag.sourceName:=$listBoxName
		Form:C1466.drag.values:=$collectionValues.reverse()
		
	: (Form event code:C388=On Drag Over:K2:13)  // -------------------------------------------- On Drag Over
		
		$accept:=Choose:C955(Undefined:C82(Form:C1466.drag); -1; 0)
		
	: (Form event code:C388=On Drop:K2:12)  // -------------------------------------------- On Drop
		
		If (Not:C34(Undefined:C82(Form:C1466.drag)))
			
			$p:=Drop position:C608
			If ($p<0)  // Drop after the last row of the listbox
				$p:=$collection.length
			End if 
			
			
			If (Form:C1466.drag.sourceName#$listBoxName)  // EXTERNAL LISTBOX
				
				For ($i; 0; Form:C1466.drag.values.length-1)
					
					// insert in TARGET 
					$collection.insert($p; Form:C1466.drag.values[$i])
					
					// remove from SOURCE
					$index:=Form:C1466.drag.source.indexOf(Form:C1466.drag.values[$i])
					Form:C1466.drag.source.remove($index; 1)
				End for 
				
				//Unselect in source what has been dragged
				LISTBOX SELECT ROW:C912(*; Form:C1466.drag.sourceName; 0; lk remove from selection:K53:3)  // UNselect everything in source
				
			Else   // REORDER LISTBOX
				
				// remove from SOURCE
				For ($i; 0; Form:C1466.drag.values.length-1)
					
					$index:=Form:C1466.drag.source.indexOf(Form:C1466.drag.values[$i])
					Form:C1466.drag.source.remove($index; 1)
					
					If ($index<$p)
						$p:=$p-1
					End if 
					
				End for 
				
				// insert in TARGET (same as source)
				For ($i; 0; Form:C1466.drag.values.length-1)
					// insert in target collection
					$collection.insert($p; Form:C1466.drag.values[$i])
				End for 
				
				
			End if 
			
			$collection:=$collection  // redraw listbox ?
			
			//Unselect everything in target
			LISTBOX SELECT ROW:C912(*; $listBoxName; 0; lk remove from selection:K53:3)  // UNselect everything
			//Select what has been dropped
			For ($i; 0; Form:C1466.drag.values.length-1)
				LISTBOX SELECT ROW:C912(*; $listBoxName; $p+$i+1; lk add to selection:K53:2)
			End for 
			
			OB REMOVE:C1226(Form:C1466; "drag")
			
		Else 
			
			// NEVER, (REJECTED DURING ON DRAG OVER)
			
		End if 
		
End case 


