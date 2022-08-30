var $path : Text
var $page : Integer
var $pict : Picture

var $wait : Boolean
var $folder : 4D:C1709.Folder

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		
		Form:C1466.documents:=ds:C1482.Documents.all().orderBy("pageNumber")
		
		Form:C1466.tabControl:=New object:C1471
		Form:C1466.tabControl.values:=Form:C1466.documents.toCollection("title").extract("title")
		Form:C1466.tabControl.index:=0
		
		Form:C1466.info:=Form:C1466.documents[0].comments
		
		
		Form:C1466.trace:=False:C215
		
		InitCollections
		SET TIMER:C645(-1)
		
		
	: (Form event code:C388=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET TITLE:C194(*; "H1"; String:C10(Form:C1466.col1.length)+" shapes")
		OBJECT SET TITLE:C194(*; "H2"; String:C10(Form:C1466.col2.length)+" shapes")
		OBJECT SET TITLE:C194(*; "H3"; String:C10(Form:C1466.col3.length)+" shapes")
		
		// forces the redraw of the listboxes
		
		Form:C1466.col1:=Form:C1466.col1
		Form:C1466.col2:=Form:C1466.col2
		Form:C1466.col3:=Form:C1466.col3
		
		
		
		CheckWin
		
	: (Form event code:C388=On Page Change:K2:54)
		
		$page:=FORM Get current page:C276
		Form:C1466.info:=Form:C1466.documents[$page-1].comments
		
		Form:C1466.report:=""
		
		Form:C1466.people:=New collection:C1472
		Form:C1466.log:=New collection:C1472
		
		//OBJECT SET VISIBLE(*; "InfoPage@"; True)
		
		If (Is Windows:C1573)  //| (Macintosh option down)
			ST SET ATTRIBUTES:C1093(*; "formInfo"; ST Start text:K78:15; ST End text:K78:16; Attribute text size:K65:6; 22)
		Else 
			ST SET ATTRIBUTES:C1093(*; "formInfo"; ST Start text:K78:15; ST End text:K78:16; Attribute text size:K65:6; 26)
		End if 
		
	: (Form event code:C388=On Unload:K2:2)
		
End case 




