//%attributes = {"invisible":true}

#DECLARE($sourceFormulaString : Text; $valuesFormulaString : Text; $listboxName : Text)

var $source; $values : Collection
var $value : Object
var $p : Integer

$source:=Formula from string:C1601($sourceFormulaString).call()
$values:=Formula from string:C1601($valuesFormulaString).call()

For each ($value; $values)
	$p:=$source.indexOf($value)
	$source.remove($p; 1)
End for each 



LISTBOX SELECT ROW:C912(*; $listboxName; 0; lk remove from selection:K53:3)  // UNselect everything in source
