#Include 'Protheus.ch'
#Include 'Totvs.ch'
#include "topconn.ch"

/*
+-----------------------------------------------------------------------------------------------+
!   Modulo      !   SIGAFAT                                                                     !
+-----------------------------------------------------------------------------------------------+
!   Programa    !   F4NFORI                                                                     !
+-----------------------------------------------------------------------------------------------+
!   DescriÃ§Ã£o   !   PE serÃ¡ acionado na chamada da interface de visualizacao dos                !
!               !   documentos de entrada/saida para devoluÃ§Ã£o . Utilizado para que             !    
!               !   o usuÃ¡rio possa incluir um filtro que deverÃ¡ ser executado na atualizaÃ§Ã£o   !
!               !   do arquivo temporÃ¡rio com base nos itens do SD1 .                           !
+-----------------------------------------------------------------------------------------------+
!   Autor       !   Faraway - @PAULO.OLIVEIRA                                                          !                
+-----------------------------------------------------------------------------------------------+
!   Data        !   23/06/2020                                                                  !
+-----------------------------------------------------------------------------------------------+
!                               AtualizaÃ§Ã£o                                                     !
+-----------------------------------------------------------------------------------------------+   
!   Data        !   Autor       !   DescriÃ§Ã£o                                                   !
+-----------------------------------------------------------------------------------------------+
+-----------------------------------------------------------------------------------------------+
*/
User Function F4NFORI()  //PEDIDO VENDA DEVOLUCAO


	Local cExp1 := PARAMIXB[1]//cPrograma - Local a ser considerado // paulo 18/06
	Local cExp2 := PARAMIXB[2]//
//	Local cExp3 := PARAMIXB[3]//cClifor - Codigo do Cliente/Fornecedor
	Local cExp4 := ''
	Local cRet01 :=''   
	//Local DataEmi := ddatabase - GetNewPar("MV_ZZLTDIA",365) 
//	Local cParF4  := alltrim(GetNewPar("MV_ZZF4LIB","")) 
	Local DataEmi := ddatabase//-1000
	_msg:='Usar Filtro Curvas A, B e C ?'

	if cExp1 =="SD2"
		Return
	endif

	if SM0->M0_CODFIL <> '01' //somente para empresa, exceto filial
		Return
		
	endif

	iF MSGYESNO ( _msg, "Nota Origem " ) == .f.
		Return
	endif	
	
	_Prod  := Ascan(aHeader,{ |x| UPPER(Alltrim(x[2])) == "C6_PRODUTO"})
	_Curva := 'A'
	 _dias	 :=2000
	nPProd  := aScan(aHeader,{|X| ALLTRIM(X[2]) == "C6_PRODUTO"}) 
	_Prod :=aCols[N][nPProd]  

	_Curva 	:=  posicione("SB3",1,xFilial("SB3")+_Prod ,'B3_CLASSE' )

	if _curva =="A"
			_dias	:= GetNewPar("MV_ZZF4CvA",150)
			DataEmi := ddatabase - _dias
	elseif _curva =="B"
			_dias	:= GetNewPar("MV_ZZF4CvB",700)
			DataEmi := ddatabase - _dias 
	elseif _curva =="C"
			_dias	:= GetNewPar("MV_ZZF4CvC",1000)	
			DataEmi := ddatabase - _dias
	else
			DataEmi := ddatabase - _dias
	endif	

//	alert("Produto "+  _prod+ " Curva "+ _curva + " Dias "+ str(_dias) + "Inicio "+dtoc(Dataemi)) 

//	Alert('1 '+cExp1+" 2 "+cExp2+" 3 "+cExp3+" 4 "+cParF4)



	if cExp1 <> "SD2"
// If __cUserID $ cParF4
 		If cExp2 <> '000203'
 			cRet01 :=" D1_LOCAL in ('04','09') AND D1_EMISSAO >= '"+dtos(DataEmi) +"'"  
	
 			cExp4:=cRet01
 		Else
 			cRet01 :=" D1_EMISSAO >= '"+dtos(DataEmi) +"'"   
	
 			cExp4:=cRet01
 		EndIf
//EndIf   
	endif

Return (cExp4)
