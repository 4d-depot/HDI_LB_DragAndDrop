// Three events must be enabled so as the D&D works fine

// - On begin drag over
// - On drag over
// - On drop

If (Form:C1466.trace)
	TRACE:C157
End if 

//$0:=ManageDragAndDropCollectionsOLD(Form.col1; Form.selectedLB1)

$0:=ManageDragDrop(Form:C1466.col1; Form:C1466.selectedLB1)

// for the game only
If (Form event code:C388=On Drop:K2:12)
	Form:C1466.moves:=Form:C1466.moves+1
End if 

SET TIMER:C645(-1)