/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+                                                      
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! 05 - FATURAMENTO	                                     !
+------------------+---------------------------------------------------------+
!Nome              ! LIBPED01                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Valor de Pedidos Liberados	               				!
!				   ! 														 !
+------------------+---------------------------------------------------------+
!Autor             ! Enzo Piovesan	                                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   !     05/08/2020                                          !
+------------------+---------------------------------------------------------+
*/

#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
#include 'protheus.ch'

/*
+----------------------------------------------------------------------------+
! Função    ! LIBPED01     ! Autor ! Enzo Piovesan      ! Data ! 05/08/2020  !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! 														         !
+-----------+----------------------------------------------------------------+
*/
User Function LIBPED01()
Local _lRet := .T.
Private aGarc := {}    
Private _emp	:= SM0->M0_CODIGO

If TRepInUse()
	Pergunte("LIBPED",.F.)
	oReport := LIBPED02()
	oReport:PrintDialog()
EndIf

Return(_lRet)

/*
+----------------------------------------------------------------------------+
! Função    !LIBPED02     ! Autor ! Enzo Piovesan      ! Data !  05/08/2020  !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Impressão Relatório.										 	 !
+-----------+----------------------------------------------------------------+
*/
Static Function LIBPED02()
Private oReport   := Nil
Private oSection1 := Nil

//Variaveis usadas
Private cRemessa    := ''   
Private cPedido     := ''
Private cCliente    := ''  
//Private cLoja		:= ''
Private cNome 		:= ''
Private cProd	    := ''
Private cBloq		:= ''  
Private cClasse		:= ''
Private cArmazem	:= '' 
Private cCodcom		:= ''
Private nQtdLib     := 0.00  
Private nPrcVen		:= 0.00 
Private nTotPro     := 0.00
Private cData       := ''


 // montagem do relatório e chamada de campos
oReport := TReport():New("LIBPED","Valor de Pedidos Liberados","LIBPED",{|oReport| LIBPED03(oReport)},"Valor de Pedidos Liberados")
oReport:SetLandscape()

	If _emp == '01'

		oSection1 := TRSection():New(oReport,  "Itens",{"QRY"}, nil, .F., .F.)
		TRCell():New(oSection1, "Remessa GAUSS","QRY", "Remessa GAUSS"  , Nil, 6, .F., {|| cRemessa})
		TRCell():New(oSection1, "Pedido", 		"QRY", "Pedido"  		, Nil, 6, .F., {|| cPedido}) 
		TRCell():New(oSection1, "Cliente",		"QRY", "Cliente"  		, Nil, 6, .F., {|| cCliente})
		TRCell():New(oSection1, "Nome Cliente", "QRY", "Nome"  			, Nil, 10, .F., {|| cNome})
		//TRCell():New(oSection1, "Loja",			"QRY", "Loja"  			, Nil, 4, .F., {|| cLoja})
		TRCell():New(oSection1, "Produto", 		"QRY", "Produto"	  	, Nil, 4, .F., {|| cProd}  )
		TRCell():New(oSection1, "Cod. Comer.",  "QRY", "Cod. Comercial"	, Nil, 4, .F., {|| cCodcom}  )
		TRCell():New(oSection1, "Qtd. Liberada","QRY", "Qtd. Liberada"  , "@E 999999.99", 10, .F.,  {|| nQtdLib}) 
		TRCell():New(oSection1, "Prc. Venda"   ,"QRY", "Prc. Venda"     , "@E 999999.99", 10, .F.,  {|| nPrcVen})
		TRCell():New(oSection1, "Vlr.Tot.Prod.","QRY", "Vlr.Tot.Prod."  , "@E 999999.99", 10, .F.,  {|| nTotPro}) 
		TRCell():New(oSection1, "Liberação", 	"QRY", "Liberação"  	, Nil, 10, .F., {|| cData})
		TRCell():New(oSection1, "Bloq Est", 	"QRY", "Bloqueio"	  	, Nil, 4, .F., {|| cBloq}  )
		TRCell():New(oSection1, "Classe", 		"QRY", "Classe"	  		, Nil, 4, .F., {|| cClasse}  )
		TRCell():New(oSection1, "Armazem", 		"QRY", "Armazem"	  	, Nil, 4, .F., {|| cArmazem}  )

	Elseif _emp == '02'

		oSection1 := TRSection():New(oReport,  "Itens",{"QRY"}, nil, .F., .F.)
		TRCell():New(oSection1, "Remessa CDG", 	"QRY", "Remessa CDG"  	, Nil, 6, .F., {|| cRemessa})
		TRCell():New(oSection1, "Pedido", 		"QRY", "Pedido"  		, Nil, 6, .F., {|| cPedido}) 
		TRCell():New(oSection1, "Cliente",		"QRY", "Cliente"  		, Nil, 6, .F., {|| cCliente})
		TRCell():New(oSection1, "Nome Cliente", "QRY", "Nome"  			, Nil, 10, .F., {|| cNome})
		//TRCell():New(oSection1, "Loja",			"QRY", "Loja"  			, Nil, 2, .F., {|| cLoja})
		TRCell():New(oSection1, "Produto", 		"QRY", "Produto"	  	, Nil, 20, .F., {|| cProd}  )
		TRCell():New(oSection1, "Cod. Comer.",  "QRY", "Cod. Comercial"	, Nil, 4, .F., {|| cCodcom}  )
		TRCell():New(oSection1, "Qtd. Liberada","QRY", "Qtd. Liberada"  , "@E 999999.99", 10, .F.,  {|| nQtdLib}) 
		TRCell():New(oSection1, "Prc. Venda"   ,"QRY", "Prc. Venda"     , "@E 999999.99", 10, .F.,  {|| nPrcVen})
		TRCell():New(oSection1, "Vlr.Tot.Prod.","QRY", "Vlr.Tot.Prod."  , "@E 999999.99", 10, .F.,  {|| nTotPro}) 
		TRCell():New(oSection1, "Liberação", 	"QRY", "Liberação"  	, Nil, 10, .F., {|| cData})
		TRCell():New(oSection1, "Bloq Est", 	"QRY", "Bloqueio"	  	, Nil, 4, .F., {|| cBloq}  )
		TRCell():New(oSection1, "Classe", 		"QRY", "Classe"	  		, Nil, 4, .F., {|| cClasse}  )
		TRCell():New(oSection1, "Armazem", 		"QRY", "Armazem"	  	, Nil, 4, .F., {|| cArmazem}  )

	Else
	
		oSection1 := TRSection():New(oReport,  "Itens",{"QRY"}, nil, .F., .F.)
		TRCell():New(oSection1, "Remessa SPG", 	"QRY", "Remessa SPG"  	, Nil, 12, .F., {|| cRemessa})
		TRCell():New(oSection1, "Pedido", 		"QRY", "Pedido"  		, Nil, 6, .F., {|| cPedido}) 
		TRCell():New(oSection1, "Cliente",		"QRY", "Cliente"  		, Nil, 6, .F., {|| cCliente})
		TRCell():New(oSection1, "Nome Cliente", "QRY", "Nome"  			, Nil, 10, .F., {|| cNome})
		//TRCell():New(oSection1, "Loja",			"QRY", "Loja"  			, Nil, 2, .F., {|| cLoja})
		TRCell():New(oSection1, "Produto", 		"QRY", "Produto"	  	, Nil, 20, .F., {|| cProd}  )
		TRCell():New(oSection1, "Cod. Comer.",  "QRY", "Cod. Comercial"	, Nil, 4, .F., {|| cCodcom}  )
		TRCell():New(oSection1, "Qtd. Liberada","QRY", "Qtd. Liberada"  , "@E 999999.99", 10, .F.,  {|| nQtdLib}) 
		TRCell():New(oSection1, "Prc. Venda"   ,"QRY", "Prc. Venda"     , "@E 999999.99", 10, .F.,  {|| nPrcVen})
		TRCell():New(oSection1, "Vlr.Tot.Prod.","QRY", "Vlr.Tot.Prod."  , "@E 999999.99", 10, .F.,  {|| nTotPro}) 
		TRCell():New(oSection1, "Liberação", 	"QRY", "Liberação"  	, Nil, 10, .F., {|| cData})
		TRCell():New(oSection1, "Bloq Est", 	"QRY", "Bloqueio"	  	, Nil, 4, .F., {|| cBloq}  )
		TRCell():New(oSection1, "Classe", 		"QRY", "Classe"	  		, Nil, 4, .F., {|| cClasse}  )
		TRCell():New(oSection1, "Armazem", 		"QRY", "Armazem"	  	, Nil, 4, .F., {|| cArmazem}  )

	EndIf
Return(oReport)



/*
+----------------------------------------------------------------------------+
! Função    ! LIBPED03     ! Autor ! Enzo Piovesan	    ! Data !  05/08/2020 !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Impressão Relatório.										 	 !
+-----------+----------------------------------------------------------------+
*/
Static Function LIBPED03(oReport)   

Local TRT01       := GetNextAlias() 
Local aGarc 	  := {}
Local nx
Private oSection1 := oReport:Section(1)
	
BeginSql Alias TRT01
  SELECT 
	  	C9_XXSEPAR,
		C9_PEDIDO, 
		C9_CLIENTE,  
		C9_PRODUTO, 
		C9_QTDLIB, 
		(C9_PRCVEN * C9_QTDLIB) TOTAL,
		C9_PRCVEN,
        C9_DATALIB,
		C9_BLEST, 
		C9_LOCAL,
		B3_CLASSE,
		A1_NOME,
		B1_CODCOM
	FROM %table:SC9% SC9
	INNER JOIN %table:SA1% SA1
	ON SA1.A1_COD = SC9.C9_CLIENTE
	AND SA1.A1_LOJA = SC9.C9_LOJA
	AND SA1.D_E_L_E_T_ <> '*'
	INNER JOIN %table:SB3% SB3
	ON SB3.B3_COD = SC9.C9_PRODUTO
	AND SB3.B3_FILIAL = SC9.C9_FILIAL
	AND SB3.D_E_L_E_T_ <> '*'
	INNER JOIN %table:SB1% SB1
	ON SB1.B1_COD = SC9.C9_PRODUTO
	AND SB1.D_E_L_E_T_ <> '*'
	WHERE SC9.D_E_L_E_T_ <> '*'
	AND C9_LOCAL between %Exp:MV_PAR01% and %Exp:MV_PAR02% 
	AND C9_CLIENTE between %Exp:MV_PAR05% and %Exp:MV_PAR06%
	AND C9_PRODUTO between %Exp:MV_PAR07% and %Exp:MV_PAR08%
    AND C9_DATALIB between %Exp:DTOS(MV_PAR03)% and %Exp:DTOS(MV_PAR04)%
	AND C9_NFISCAL = ' '
	ORDER BY C9_PEDIDO DESC
 	
EndSql        
oSection1:EndQuery()

// Inclui informações das tabelas em um array

While !(TRT01)->(EOF())
  	 	AADD(aGarc,{(TRT01)->C9_XXSEPAR;
		   		   ,(TRT01)->C9_PEDIDO;
				   ,(TRT01)->C9_CLIENTE;
				   ,(TRT01)->A1_NOME;
				   ,(TRT01)->C9_PRODUTO;
				   ,(TRT01)->B1_CODCOM;
				   ,(TRT01)->C9_QTDLIB;     
				   ,(TRT01)->C9_PRCVEN;
				   ,(TRT01)->TOTAL;
                   ,STOD((TRT01)->C9_DATALIB);
				   ,(TRT01)->C9_BLEST;
				   ,(TRT01)->B3_CLASSE;
				   ,(TRT01)->C9_LOCAL})
	(TRT01)->(DbSkip())
EndDo              
        
oSection1:Init()  

// Percorre o Array para impressão.  

	For nX := 1 to Len(aGarc)   

			cRemessa    := aGarc[nX][1]
			cPedido     := aGarc[nX][2]
			cCliente    := aGarc[nX][3]
			cNome		:= aGarc[nX][4]
			cProd       := aGarc[nX][5]
			cCodcom		:= aGarc[nX][6]
			nQtdLib     := aGarc[nX][7]
			nPrcVen	    := aGarc[nX][8]
			nTotPro	    := aGarc[nX][9]
            cData	    := aGarc[nX][10]
			cBloq	    := aGarc[nX][11]
			cClasse	    := aGarc[nX][12]
			cArmazem	:= aGarc[nX][13]
			
		      
	oSection1:PrintLine()
	Next nX	                                               
	oSection1:Finish()

Return()
