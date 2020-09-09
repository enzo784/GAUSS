#INCLUDE "rwmake.ch"    
#INCLUDE "topconn.ch" 

//Rotina utilizada como validação dos campos B1_TIPPRO, B1_MARCA, B1_GRUPO e B1_TIPO.
//Controla a estruturação de código do produto cadastrado.

//Data : 04/10/06

User Function CodProd()
                        
Local cTipo
Local cTipPro                                                	
Local cGrupo
Local cPrefCod
Local aArea := GetArea()

//APMsgAlert("fun  " +funname())	
//APMsgAlert("user  " +cUserName)


If !empty(M->B1_TIPPRO) .AND. !empty(M->B1_GRUPO) .AND. !empty(M->B1_TIPO) 
 

	cTipo   := B1Prod(ALLTRIM(M->B1_TIPO),ALLTRIM(M->B1_TIPPRO))
	cTipPro := B1TipPro(ALLTRIM(M->B1_TIPPRO))
	cGrupo  := SUBSTR(M->B1_GRUPO,2,2)
	
	cPrefCod := cTipo+cTipPro+cGrupo
	
	cQuery := "SELECT MAX(B1_COD) COD "
	cQuery += "FROM "
	cQuery += RetSQLName("SB1")
	cQuery += " WHERE "
	cQuery += "       B1_FILIAL = '"+xFilial("SB1")+"' AND "
	cQuery += "       D_E_L_E_T_ = ' ' AND "
	cQuery += "       SUBSTRING(B1_COD,1,4) = '"+cPrefCod+"' "
	
	TCQUERY cQuery NEW ALIAS "QRY"
	
	QRY->(DbGoTop())
	
	If QRY->COD == NIL
		M->B1_SEQ := "0001"
	Else
		M->B1_SEQ := SOMA1(SUBSTR(QRY->COD,5,4))
	EndIf	
	
		
	QRY->(DbCloseArea())   
	

	if alltrim(funname())<>'PMATA010' //Se não processar pelo execauto 
		M->B1_COD := cPrefCod + M->B1_SEQ
	else
		M->B1_COD := QRY_SB1->_COD
		M->B1_SEQ := QRY_SB1->_SEQ
	endif	
			
	
Else
	
	M->B1_SEQ := SPACE(4)
	M->B1_COD := SPACE(15)
	
EndIf

RestArea(aArea)

Return(.T.)  



Static Function B1Prod(cTipo,cTipoPro)

Local cTpRet := SPACE(1) 
//if (cTipoPro == 'BJ') .or.(cTipoPro == 'CD').or.(cTipoPro=='FU').or.(cTipoPro=='PL').or.(cTipoPro=='SB').or.(cTipoPro=='SD').or.(cTipoPro=='SP').or.(cTipoPro=='SR');
//	.or.(cTipoPro=='SV') .or. (cTipoPro=='TB').or.(cTipoPro=='VL')
  if cTipoPro $ "BJ/CD/FU/PL/SB/SD/SP/SR/SV/TB/VL/AA/AL/AM/BS/CA/CI/DP/EL/FI/GD/IN/PA/SF/VA/UA"
	Do Case
		Case cTipopro =="BJ"
		cTpRet :="B"   
		Case cTipopro =="CD"
		cTpRet :="C"  
		Case cTipopro =="FU"
		cTpRet :="F"
		Case cTipopro =="PL"
		cTpRet :="P"
		Case cTipopro =="SB"
		cTpRet :="S"  
		Case cTipopro =="SD"
		cTpRet :="S"   
		Case cTipopro =="SP"
		cTpRet :="S" 
		Case cTipopro =="SR"
		cTpRet :="S"
		Case cTipopro =="SV"
		cTpRet :="S" 
		Case cTipopro =="TB"
		cTpRet :="T" 
		Case cTipopro =="VL"
		cTpRet :="V"
		Case cTipopro =="AA"
		cTpRet :="A"
		Case cTipopro =="AL"
		cTpRet :="A"
		Case cTipopro =="AM"
		cTpRet :="A"
		Case cTipopro =="BS"
		cTpRet :="B"
		Case cTipopro =="CA"
		cTpRet :="C"	
		Case cTipopro =="CI"
		cTpRet :="C"
		Case cTipopro =="DP"
		cTpRet :="D"
		Case cTipopro =="EL"
		cTpRet :="E"
		Case cTipopro =="FI"
		cTpRet :="F"
		Case cTipopro =="GD"
		cTpRet :="F"
		Case cTipopro =="IN"
		cTpRet :="I"
		Case cTipopro =="PA"
		cTpRet :="P"
		Case cTipopro =="SF"
		cTpRet :="G"
		Case cTipopro =="VA"
		cTpRet :="V"
		Case cTipopro =="UA"
		cTpRet :="U"
	
	
	
		
		
	endCase
		
else		

	if ((cTipoPro == 'RV') .OR. (cTipoPro == 'CR') .OR. (cTipoPro == 'DI') .OR. (cTipoPro == 'TD') .OR.(cTipoPro == 'GI').OR.(cTipoPro == 'GC').OR.(cTipoPro == 'GB').or.(cTipoPro == 'GF');
   .or.	(cTipoPro == 'GL') .OR.(cTipoPro == 'GS').OR.(cTipoPro =='RT')			)
	 Do Case                 
	
		Case cTipo == "AT"	
			cTpRet := "T"
			
		Case cTipo == "BN"
			cTpRet := "B"
			
		Case cTipo == "BF"
			cTpRet := "N"	
			
		Case cTipo == "EP"
			cTpRet := "F"
			
		Case cTipo == "HL"
			cTpRet := "H"
			
		Case cTipo == "ME"
			cTpRet := "E"
			
		Case cTipo == "MI"
			cTpRet := "R"
			
		Case cTipo == "MM"
			cTpRet := "M"
			
		Case cTipo == "MO"	
			cTpRet := "O"
			
		Case cTipo == "MP"
			cTpRet := "P"
			
		Case cTipo == "MU"
			cTpRet := "U"
			
		Case cTipo == "PA"
			cTpRet := "G"
			
		Case cTipo == "PI"
			cTpRet := "I"		
			
		Case cTipo == "DI"
			cTpRet := "X"  
		Case cTipo == "GC"
			cTpRet := "G"  
		Case cTipoPro=="BJ"
			cTpRet :="B"
		Case cTipopro =="UA"
		cTpRet :="U"
	
		EndCase 
	else
	Do Case                 
	
		Case cTipo == "AT"	
			cTpRet := "T"
			
		Case cTipo == "BN"
			cTpRet := "B"
			
		Case cTipo == "BF"
			cTpRet := "N"	
			
		Case cTipo == "EP"
			cTpRet := "F"
			
		Case cTipo == "HL"
			cTpRet := "H"
			
		Case cTipo == "ME"
			cTpRet := "E"
			
		Case cTipo == "MI"
			cTpRet := "R"
			
		Case cTipo == "MM"
			cTpRet := "M"
			
		Case cTipo == "MO"	
			cTpRet := "O"
			
		Case cTipo == "MP"
			cTpRet := "P"
			
		Case cTipo == "MU"
			cTpRet := "U"
			
		Case cTipo == "PA"
			cTpRet := "I"
			
		Case cTipo == "PI"
			cTpRet := "I"		
			
		Case cTipo == "DI"
			cTpRet := "X"    

		Case cTipopro =="UA"
		cTpRet :="U" 
	
			
		
	 EndCase  
  endif   
endIf
Return(cTpRet)		
		         
		
Static Function B1TipPro(cTipo)

Local cTpRet := SPACE(1)

Do Case
	Case cTipo == "AT"
		cTpRet := "T"
	
	Case cTipo == "BI"
		cTpRet := "B"
		
	Case cTipo == "CR"
		cTpRet := "R"
		
	Case cTipo == "DI"
		cTpRet := "D"
		
	Case cTipo == "ET"
		cTpRet := "Q"
		
	Case cTipo == "MI"
		cTpRet := "I"
		
	Case cTipo == "ML"
		cTpRet := "L"
		
	Case cTipo == "NA"
		cTpRet := "N"	
		
	Case cTipo == "PC"
		cTpRet := "P"
		
	Case cTipo == "RV"
		cTpRet := "V"	

	Case cTipo == "TD"
		cTpRet := "O"                                     
		
	Case cTipo == "GI"
		cTpRet := "I"  
		
	Case cTipo == "AL"
		cTpRet := "J" 
		
	Case cTipo == "GC"
		cTpRet := "C"  
	Case cTipo == "AM"
		cTpRet := "M"
 
	Case cTipo == "BJ"
		cTpRet := "I" 
		 
	Case cTipo =="CD"
		cTpRet :="D"
		
	Case cTipo =="FU"
		cTpRet :="U" 
   
	Case cTipo =="GB"
		cTpRet :="B" 
		   
	Case cTipo =="GF"
		cTpRet :="F" 
		   
	Case cTipo =="GL"
		cTpRet :="L"   
		
	Case cTipo =="GS"
		cTpRet :="S"    
	Case cTipo =="RT"
		cTpRet :="T"   
	Case cTipo =="PL"
		cTpRet :="L"  
	Case cTipo =="SB"
		cTpRet :="B"  
	Case cTipo =="SD"
		cTpRet :="D" 
	Case cTipo =="SP"
		cTpRet :="F" 
	Case cTipo =="SR"
		cTpRet :="R"
	Case cTipo =="SV"
		cTpRet :="V"    
	Case cTipo =="TB"
		cTpRet :="B"  
	Case cTipo =="VL"
		cTpRet :="L"
    Case cTipo =="AA"
		cTpRet :="A"
	Case cTipo =="AL"
		cTpRet :="L"
	Case cTipo =="AM"
		cTpRet :="M"
	Case cTipo =="BS"
		cTpRet :="S"
	Case cTipo =="CA"
		cTpRet :="A"	
	Case cTipo =="CI"
		cTpRet :="I"
	Case cTipo =="DP"
		cTpRet :="P"
	Case cTipo =="EL"
		cTpRet :="L"
	Case cTipo =="FI"
		cTpRet :="I"
	Case cTipo =="GD"
		cTpRet :="A"
	Case cTipo =="IN"
		cTpRet :="N"
	Case cTipo =="PA"
		cTpRet :="A"
	Case cTipo =="SF"
		cTpRet :="F"
	Case cTipo =="VA"
		cTpRet :="A" 
	
	Case cTipo =="PG"
		cTpRet :="A"	
	Case cTipo =="PA"
		cTpRet :="A"	
	Case cTipo =="UA"
		cTpRet :="A"




EndCase

Return(cTpRet)
