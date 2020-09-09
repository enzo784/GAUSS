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
!Nome              ! GARTBP01                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Relatório para mostrar produtosXClientes com            !
!				   ! calculo de impostos									 !
+------------------+---------------------------------------------------------+
!Autor             ! Nilson Gonçalves                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   !     12/01/2018                                          !
+------------------+---------------------------------------------------------+
*/

#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
#include 'protheus.ch'

/*
+----------------------------------------------------------------------------+
! Função    ! GARTBP01     ! Autor ! Nilson Gonçalves   ! Data ! 12/01/2018  !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! 														         !
+-----------+----------------------------------------------------------------+
*/
User Function GARTBP01()
Local _lRet := .T.
Private aGarc := {}    
Private cPerg := "GARTBP01"
//ValidPerg()
//Private aGarc := {}

If TRepInUse()
	Pergunte("GARTBP",.F.)
	oReport := GARTBP02()
	oReport:PrintDialog()
EndIf

Return(_lRet)

/*
+----------------------------------------------------------------------------+
! Função    ! GARTBP02     ! Autor ! Nilson Gonçalves   ! Data !  12/01/2018  !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Impressão Relatório.										 	 !
+-----------+----------------------------------------------------------------+
*/
Static Function GARTBP02()
Private oReport   := Nil
Private oSection1 := Nil

//Variaveis usadas
Private cCODTAB     := ''
Private cCodCli     := ''
Private cNomeCli    := ''
Private cCodPro     := ''
Private cCodCom     := ''
Private cDescP      := ''
Private nPrcVen     := 0.00
Private nDesconto   := 0.00
Private nPrcTotal   := 0.00
Private cPosIpi     := ''
Private cB1Grtib    := ''
Private cOrigem     := ''
Private cEstado     := ''
Private nAliqIcms   := 0.00
Private cA1Grtib    := ''
Private cTes        := ''
Private cCFOP       := ''
Private nMargem     := 0.00
Private nAliqDst	:= 0.00
Private nBcSt  		:= 0.00  
Private nVlrIcms	:=0.0
Private nVlrSt	    := 0.00
Private nVlrBrut    := 0.00	   
Private nStMerc	    :=0.00






 // montagem do relatório e chamada de campos
oReport := TReport():New("GARTBP","Produto x Impostos - Clientes","GARTBP",{|oReport| GARTBP03(oReport)},"Produto x Impostos - Clientes")
oReport:SetLandscape()
	
	oSection1 := TRSection():New(oReport,  "Itens"   ,{"QRY","SC9"}, nil, .F., .F.)
	TRCell():New(oSection1, "Cod. Tabela"  , "QRY", "Cod. Tabela"  , Nil, 6, .F., {|| cCODTAB})
	TRCell():New(oSection1, "Cod. Cliente"  , "QRY", "Cod. CLiente"  , Nil, 10, .F., {|| cCodCli}) 
	TRCell():New(oSection1, "Cliente" , "QRY", "Cliente"  , Nil, 30, .F., {|| cNomeCli}) 
	TRCell():New(oSection1, "Cod. Produto"  , "QRY", "Cod. Produto"  	, Nil, 10, .F., {|| cCodPro}) 
	TRCell():New(oSection1, "Cod. Comercial"  , "QRY", "Cod. Comercial"  , Nil, 16, .F., {|| cCodCom}) 
	TRCell():New(oSection1, "Desc. Prod"  , "QRY", "Desc. Prod"  , Nil, 25, .F., {|| cDescP}) 
	TRCell():New(oSection1, "Preco Venda"  , "QRY", "Preco Venda"  ,   "@E 999.99", 10, .F., {|| nPrcVen})
	TRCell():New(oSection1, "Desconto"  , "QRY", "Desconto"  ,  "@E 999.99", 10, .F., {|| nDesconto}) 
	TRCell():New(oSection1, "Prc. Total"  , "QRY", "Prc. Total"  ,   "@E 999,999.99999", 8, .F., {|| nPrcTotal}) 
	TRCell():New(oSection1, "IPI"  , "QRY", "IPI"  ,   Nil, 18, .F., {|| cPosIpi}  )
	TRCell():New(oSection1, "GRUPO Produto"  , "QRY", "GRUPO Produto"  , Nil, 8, .F., {|| cB1Grtib}) 
	TRCell():New(oSection1, "Origem"  , "QRY", "Origem"  , Nil, 4, .F., {|| cOrigem})
	TRCell():New(oSection1, "Estado"  , "QRY", "Estado"  , Nil, 4, .F., {|| cEstado})
	TRCell():New(oSection1, "Aliq. ICMS"  , "QRY", "Aliq. ICMS"  ,   "@E 999.99", 9, .F., {|| nAliqIcms})
	TRCell():New(oSection1, "Grupo Cliente"  , "QRY", "Grupo Cliente"  , Nil, 8, .F., {|| cA1Grtib})
	TRCell():New(oSection1, "TES"  , "QRY", "TES"  , Nil, 8, .F., {|| cTes})
	TRCell():New(oSection1, "CFOP"  , "QRY", "CFOP"  , Nil, 8, .F., {|| cCFOP})
	TRCell():New(oSection1, "Margem"  , "QRY", "Margem"  , Nil, 8, .F., {|| nMargem})
	TRCell():New(oSection1, "AliqDST"  , "QRY", "AliqDST"  , Nil, 8, .F., {|| nAliqDst})  
	TRCell():New(oSection1, "Valor Icms"  , "QRY", "Valor Icms"  , Nil, 8, .F., {|| nVlrIcms})  
	TRCell():New(oSection1, "Base ST"  , "QRY", "Base ST"  , Nil, 8, .F., {|| nBcSt})   
	TRCell():New(oSection1, "Valor ST"  , "QRY", "Valor ST"  , Nil, 8, .F., {|| nVlrSt})       
	TRCell():New(oSection1, "Valor Bruto"  , "QRY", "Valor Bruto"  , Nil, 8, .F., {|| nVlrBrut})       
	TRCell():New(oSection1, "%St Sobre Merc"  , "QRY", "%St Sobre Merc"  , Nil, 8, .F., {|| nStMerc})
	






Return(oReport)

/*
+----------------------------------------------------------------------------+
! Função    ! GARTBP03     ! Autor ! Nilson Gonçalves   ! Data !  12/01/2018 !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Impressão Relatório.										 	 !
+-----------+----------------------------------------------------------------+
*/
Static Function GARTBP03(oReport)   

Local TRT01     := GetNextAlias() 
Local nX
Private oSection1 := oReport:Section(1)
Private _cCodigo  := '' 
Private nPar03 :=1


 		
 // If MV_PAR03==1  
 If nPar03 == 1
oSection1:BeginQuery()
  				
  //tabela Principal

   BeginSql Alias TRT01 
	  SELECT DA1_CODTAB,
		A1_COD,
		A1_NOME,
		DA1_CODPRO,
		B1_CODCOM,
		B1_DESC,
		DA1_PRCVEN,
		A1_DESC,
		(DA1_PRCVEN-(DA1_PRCVEN*(A1_DESC/100))) AS PRCTOTAL,
		B1_POSIPI,
		B1_GRTRIB,
		B1_ORIGEM,
		A1_EST,
	case
	when B1_ORIGEM In('1','2','3') and A1_EST <>'PR' then 4
	WHEN A1_EST ='PR' THEN 12
	WHEN A1_EST IN ('RS','RJ','SC','SP','MG')THEN 12
	else 
		7
	end
	as  ALIQ_ICMS,

		A1_GRPTRIB,
		FM_TS,
		F4_CF,
		F7_MARGEM,
		(F7_ALIQDST + CFC_ALQFCP) AS F7_ALIQDST 

 FROM %table:DA1% DA1
 	inner join %table:SB1% as b1 on DA1_CODPRO = B1_COD and b1.D_E_L_E_T_=''
 	inner join %table:SX5% as SX5 on SX5.X5_CHAVE = B1.B1_TIPPRO and SX5.D_E_L_E_T_='' and X5_TABELA='Z2' 
 	inner join %table:SA1% as A1 ON A1.D_E_L_E_T_='' AND A1_TABELA = DA1_CODTAB 
 	inner join %table:SFM% as fm on fm.D_E_L_E_T_='' and FM_GRPROD = B1_GRTRIB  AND FM_GRTRIB = A1_GRPTRIB	
 	inner join %table:SF4% as F4 on F4.D_E_L_E_T_='' and F4.F4_CODIGO = FM_TS
	inner join %table:CFC% as CF on CF.D_E_L_E_T_='' and CF.CFC_UFDEST = A1_EST
 	inner join	%table:SF7% as F7 on f7.D_E_L_E_T_='' and  F7.F7_EST = A1_EST AND F7.F7_GRTRIB = B1_GRTRIB AND F7.F7_GRPCLI = A1_GRPTRIB
	  	
 where  DA1.D_E_L_E_T_=''
	AND A1_MSBLQL<>'1'
	AND A1_COD  BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
	AND FM_TIPO ='01'
order by a1_cod,DA1_CODPRO


  	
  EndSql        
  oSection1:EndQuery()
else
oSection1:BeginQuery()
  				
  //tabela Principal

   BeginSql Alias TRT01
 SELECT DA1_CODTAB,
		A1_COD,
		A1_NOME,
		DA1_CODPRO,
		B1_CODCOM,
		B1_DESC,
		DA1_PRCVEN,
		A1_DESC,
		(DA1_PRCVEN-(DA1_PRCVEN*(A1_DESC/100))) AS PRCTOTAL,
		B1_POSIPI,
		B1_GRTRIB,
		B1_ORIGEM,
		A1_EST,
	case
	when B1_ORIGEM In('1','2','3','8') then 4
	else 
		12
	end
	as  ALIQ_ICMS,

		A1_GRPTRIB,
		FM_TS,
		F4_CF,
		F7_MARGEM,
		(F7_ALIQDST + CFC_ALQFCP) AS F7_ALIQDST 

 FROM %table:DA1% DA1
 	inner join %table:SB1% as b1 on DA1_CODPRO = B1_COD and b1.D_E_L_E_T_=''
 	inner join %table:SX5% as SX5 on SX5.X5_CHAVE = B1.B1_TIPPRO and SX5.D_E_L_E_T_='' and X5_TABELA='Z2' 
 	inner join %table:SA1% as A1 ON A1.D_E_L_E_T_=''
 	inner join %table:SFM% as fm on fm.D_E_L_E_T_='' and FM_GRPROD = B1_GRTRIB  AND FM_GRTRIB = A1_GRPTRIB	
 	inner join %table:SF4% as F4 on F4.D_E_L_E_T_='' and F4.F4_CODIGO = FM_TS
	inner join %table:CFC% as CF on CF.D_E_L_E_T_='' and CF.CFC_UFDEST = A1_EST
 	inner join	%table:SF7% as F7 on f7.D_E_L_E_T_='' and  F7.F7_EST = A1_EST AND F7.F7_GRTRIB = B1_GRTRIB AND F7.F7_GRPCLI = A1_GRPTRIB
	  	
 where  DA1.D_E_L_E_T_=''
	AND A1_MSBLQL<>'1'
	AND A1_COD = %Exp:MV_PAR01%
	AND FM_TIPO ='01'
	AND DA1_CODTAB='180'
order by a1_cod,DA1_CODPRO  
	
	EndSql        
  oSection1:EndQuery()
EndIF
     
	// Inclui informações das tabelas em um array

While !(TRT01)->(EOF())
  	 	AADD(aGarc,{(TRT01)->DA1_CODTAB;
  				,(TRT01)->A1_COD;
				,(TRT01)->A1_NOME; 
				,(TRT01)->DA1_CODPRO;
				,(TRT01)->B1_CODCOM;     //5
				,(TRT01)->B1_DESC; 
				,(TRT01)->DA1_PRCVEN; 
				,(TRT01)->A1_DESC;
				,(TRT01)->PRCTOTAL; 
				,(TRT01)->B1_POSIPI; //10
				,(TRT01)->B1_GRTRIB;
				,(TRT01)->B1_ORIGEM; 
				,(TRT01)->A1_EST; 
				,(TRT01)->ALIQ_ICMS;
				,(TRT01)->A1_GRPTRIB; 
				,(TRT01)->FM_TS;
				,(TRT01)->F4_CF; 
				,(TRT01)->F7_MARGEM; 
				,(TRT01)->F7_ALIQDST})			

                             
	(TRT01)->(DbSkip())
EndDo              

    
		

      
oSection1:Init()  

// Percorre o Array para impressão.  

	For nX := 1 to Len(aGarc)   
	

				cCODTAB     :=  aGarc[nX][1]
				cCodCli     :=  aGarc[nX][2]				
				cNomeCli    :=  aGarc[nX][3]				
				cCodPro     :=  aGarc[nX][4]	
				cCodCom     :=  aGarc[nX][5]
				cDescP      :=  aGarc[nX][6]
				nPrcVen     :=  aGarc[nX][7]
				nDesconto   :=  aGarc[nX][8]
				nPrcTotal   :=  aGarc[nX][9]
				cPosIpi     :=  aGarc[nX][10]
				cB1Grtib    :=  aGarc[nX][11]
				cOrigem     :=  aGarc[nX][12]
				cEstado     :=  aGarc[nX][13]
				nAliqIcms   :=  aGarc[nX][14]
				cA1Grtib    :=  aGarc[nX][15]
				cTes        :=  aGarc[nX][16]
				cCFOP       :=  aGarc[nX][17]
				nMargem     :=  aGarc[nX][18]
				nAliqDst	:=  aGarc[nX][19]  
				
			nVlrIcms := nPrcTotal*(nAliqIcms/100)
				
		if	substr(cCFOP,2,3)=='102'
			nBcSt :=0
		else
			nBcSt:=	nPrcTotal+(nPrcTotal*(nMargem/100))  
		EndIf	
			//if cB1Grtib $ "1/2/3" .and. cEstado <>"PR"
			
			
			
			
			
			if nBcSt == 0  .or. substr(cCFOP,2,3)=='102'
				nVlrSt := 0
			else
			    nVlrSt := (nBcSt*(nAliqDst/100))-nVlrIcms
			endIf	                           
		
			nVlrBrut := nPrcTotal+nVlrSt 
			
			if nVlrSt ==0
				nStMerc :=0 
			else		   
				nStMerc:=(nVlrSt/nPrcTotal)
			endIf 
					
	
	oSection1:PrintLine()
	Next nX	                                               
	oSection1:Finish()

Return()
