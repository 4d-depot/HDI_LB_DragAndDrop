//%attributes = {"invisible":true}

// $collection is used
// - as SOURCE during the "On Begin Drag Over" event
// - as TARGET during the "On Drop" event

// $selection are the SOURCE values, used during  "On Begin Drag Over" event only

// This method uses $drag as an object, beware not to use this attribute elsewhere in your code

#DECLARE($collectionString : Text; $selectionString : Text)->$accept : Integer

var $listBoxName : Text
var $columnPtr; $listboxPtr : Pointer
var $indices; $values : Collection
var $i; $n; $p : Integer
var $index; $windowRef : Integer
var $drag : Object
var $blob : Blob
var $collection; $selection : Collection


//ARRAY TEXT($arrColNames; 0)
//ARRAY TEXT($arrHeaderNames; 0)
//ARRAY POINTER($arrColVars; 0)
//ARRAY POINTER($arrHeaderVars; 0)
//ARRAY POINTER($arrStyles; 0)

//ARRAY BOOLEAN($arrColsVisible; 0)

$listBoxName:=OBJECT Get name:C1087(Object current:K67:2)  // drag or drop…
$windowRef:=Current form window:C827

//LISTBOX GET ARRAYS(*; $listBoxName; $arrColNames; $arrHeaderNames; $arrColVars; $arrHeaderVars; $arrColsVisible; $arrStyles)
//$columnPtr:=OBJECT Get pointer(Object named; $arrColNames{1})  // source during drag, target during drop (can be the same)
//$listboxPtr:=OBJECT Get pointer(Object named; $listBoxName)


Case of 
		
	: (Form event code:C388=On Begin Drag Over:K2:44)  // -------------------------------------------- On Begin Drag Over
		
		$drag:=New object:C1471
		
		$drag.collectionString:=$collectionString  // used for CALL FORM
		$drag.selectionString:=$selectionString  // used for CALL FORM
		$drag.windowRef:=$windowRef  // used for CALL FORM
		$drag.listboxName:=$listBoxName
		
		// values can't be evaluated from another worker so they must be passed too
		$drag.selection:=Formula from string:C1601($selectionString).call().reverse()
		
		
		
		VARIABLE TO BLOB:C532($drag; $blob)
		APPEND DATA TO PASTEBOARD:C403("4Dxx"; $blob)
		
	: (Form event code:C388=On Drag Over:K2:13)  // -------------------------------------------- On Drag Over
		
		$accept:=Choose:C955((Pasteboard data size:C400("4Dxx")<=0); -1; 0)
		
	: (Form event code:C388=On Drop:K2:12)  // -------------------------------------------- On Drop
		
		GET PASTEBOARD DATA:C401("4Dxx"; $blob)
		BLOB TO VARIABLE:C533($blob; $drag)
		
		$collection:=Formula from string:C1601($collectionString).call()  // this collection is the collection where th drop is done
		
		$p:=Drop position:C608
		If ($p<0)  // Drop after the last row of the listbox
			$p:=$collection.length
		End if 
		
		
		Case of 
				
				//CASE 1 : Same window, same listbox
			: ($drag.windowRef=$windowRef) && ($drag.listboxName=$listBoxName)
				
				// REORDER LISTBOX
				$selection:=Formula from string:C1601($drag.selectionString).call().reverse()  //MUST be re-evaluated
				
				// remove selection
				For ($i; 0; $selection.length-1)
					$index:=$collection.indexOf($selection[$i])
					$collection.remove($index; 1)
					If ($index<$p)
						$p:=$p-1
					End if 
				End for 
				// insert selection at the drop place
				For ($i; 0; $selection.length-1)
					// insert in target collection
					$collection.insert($p; $selection[$i])
				End for 
				
				
				//CASE 2: Same window, distinct listbox
			: ($drag.windowRef=$windowRef) && ($drag.listboxName#$listBoxName)
				
				For ($i; 0; $drag.selection.length-1)
					// insert in TARGET 
					$collection.insert($p; $drag.selection[$i])
				End for 
				
				// remove method can be called straight
				RemoveItems($drag.collectionString; $drag.selectionString; $drag.listboxName)
				
				
				
				// CASE 3: distinct window (but listbox can have the same name, do NOT test !
			: ($drag.windowRef#$windowRef)
				
				For ($i; 0; $drag.selection.length-1)
					// insert in TARGET 
					$collection.insert($p; $drag.selection[$i])
				End for 
				
				// remove method mustbe executed within a CALL FORM
				CALL FORM:C1391($drag.windowRef; "RemoveItems"; $drag.collectionString; $drag.selectionString; $drag.listboxName)  // ∆∆∆
				
		End case 
		
		$collection:=$collection  // redraw listbox ?
		
		
		// INTERFACE
		LISTBOX SELECT ROW:C912(*; $listBoxName; 0; lk remove from selection:K53:3)  // UNselect everything in target
		
End case 


