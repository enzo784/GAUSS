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
!Nome              ! GARCRT1                                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! Fonte para relatório de carteiras de pedidos para CDG (TESTES)  !
+------------------+---------------------------------------------------------+
!Autor             ! Nilson Gonçalves                                        !
+------------------+---------------------------------------------------------+
!Data de Criacao   !     26/04/2016                                          !
+------------------+---------------------------------------------------------+
*/

#include "topconn.ch"
#include "tbiconn.ch"
#include "rwmake.ch"
#include "ap5mail.ch"
#include 'protheus.ch'

/*
+----------------------------------------------------------------------------+
! Função    ! GARCRCT01     ! Autor ! Nilson Gonçalves   ! Data !  12/04/2016 !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! 														         !
+-----------+----------------------------------------------------------------+
*/
User Function GARCRZ1()
Local _lRet := .T.
Private aGarc := {}    
Private aTot := {} 
Private aTot2 := {}    
Private aFinal := {}  
Private cSB2 := GetNextAlias()
//Private aGarc := {}

If TRepInUse()
	Pergunte("GARCRZ1",.F.)
	oReport := GARCRC02()
	oReport:PrintDialog()
EndIf

Return(_lRet)

/*
+----------------------------------------------------------------------------+
! Função    ! GARCRC02     ! Autor ! Nilson Gonçalves   ! Data !  12/04/2016 !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Impressão Relatório.										 	 !
+-----------+----------------------------------------------------------------+
*/
Static Function GARCRC02()
Private oReport   := Nil
Private oSection1 := Nil



Private _CdPedG:=''  
Private _CdPedC:=''
Private _CdCLiC:=''
Private _NmCliC:=''

Private _CodPed := ''
Private _CodCli:= ''
Private _CodCom	  := ''
Private _NmCLiente:=''
Private _CodProd := ''
Private _QtdVen := 0
Private _DtEmis := ''
Private _DtuFat	  := ''
Private _NmFat := ''  
Private _DtEnt := ''
Private _CodNat:= ''
Private _QtEstD:=0
Private _VlTotalP:=0.00
Private _QtdDisp:= 0
Private _VlDisp :=0.00
Private _Nvlpcdg := 0.00    
Private _cRepres:='' 
Private _Transport:=''    
Private _Municipio:=''
Private _Liberado:='' 
Private _TpFrete :=''    
Private _DescPag :=''
Private _Redespacho :=''
Private _cBloqueado:=''
//Private _Nvltitem   

// trabalho para coluna calculada
Private CdPedG:=''     //_CdPedG     
Private CdPedC               //_CdPedC
Private NmCLiente:=''
Private CodProd := ''
Private QtdVen := 0
Private DtEmis := ''
Private DtuFat	  := ''
Private NmFat := ''  
Private DtEnt := ''
Private CodNat:= ''
Private QtEstD:=0
Private VlTotalP:=0.00
Private QtdDisp:= 0
Private VlDisp :=0.00
Private Nvlpcdg := 0.00  
Private CLocCdg := 0.00
                            
Private VlParc:= 0.00  
Private VlParcAux:= 0.00     
Private VlParcAux2:= 0.00    
Private _CLocCdg:=''
Private CLocalAx:=''
Private QtdEstAx:=0.0  
Private QtdMultCx:=0.0 
Private _QtdMultCx:=0.0   
Private cRepres:=''
Private cTransport:=''   
Private cMunicipio:=''
Private cLiberado:='' 
Private cTpFrete:=''  

Private cDescPag :=''
Private cRedespacho :=''
Private cBloqueado:=''


//
    // alert("carteira")


 // montagem do relatório e chamada de campos
oReport := TReport():New("GARCRZ1","Relatório de Carteiras de Pedidos","GARCRZ1",{|oReport| GARCRC03(oReport)},"Relatório de carteira de pedidos")
oReport:SetLandscape()

oSection1 := TRSection():New(oReport,  "Itens"   ,{"QRY","SC6"}, nil, .F., .F.)

TRCell():New(oSection1, "Emissao", "QRY", "Emissao"	, Nil, 10, .F., {|| DtEmis})
TRCell():New(oSection1, "Ultima Fat", "QRY", "Ultima Fat"	, Nil, 10, .F., {|| DtuFat})
TRCell():New(oSection1, "Pedido"  , "QRY", "Pedido"  	, Nil, 10, .F., {|| CdPedG}) 
TRCell():New(oSection1, "Validado"  , "QRY", "Validado"  	, Nil, 10, .F., {|| cLiberado})   
TRCell():New(oSection1, "Cliente Bloqueado"  , "QRY", "Cliente Bloqueado"  	, Nil, 10, .F., {|| cBloqueado})
TRCell():New(oSection1, "Natureza"	, "QRY", "Natureza"	, Nil, 10, .F., {|| CodNat})
TRCell():New(oSection1, "Fatura"	, "QRY", "Fatura"	, Nil, 10, .F., {|| NmFat})
TRCell():New(oSection1, "Cond. Pagto."	, "QRY", "Cond. Pagto."	, Nil, 10, .F., {|| cDescPag})
//TRCell():New(oSection1, "PO. Cdg", "QRY", "PO. Cdg"	, Nil, 10, .F., {|| CdPedC}) 
TRCell():New(oSection1, "Codigo" , "QRY", "Codigo", Nil, 10, .F., {|| CdCLiC})


 
TRCell():New(oSection1, "Cliente" , "QRY", "Cliente", Nil, 20, .F., {|| NmCliC}) 
TRCell():New(oSection1, "Municipio"	, "QRY", "Municipio"	, Nil, 18, .F., {|| cMunicipio})   
TRCell():New(oSection1, "Estado"	, "QRY", "Estado"	, Nil, 10, .F., {|| CLocCdg})  
TRCell():New(oSection1, "Vlr. Total disp"	, "QRY", "Vlr. Total disp"	, "@E 999,999,999.99", 10, .F., {|| VlParc})    
TRCell():New(oSection1, "Vlr. Total do Pedido"	, "QRY", "Vlr. Total do Pedido"	, "@E 999,999,999.99", 10, .F., {|| Nvlpcdg})
TRCell():New(oSection1, "Transportadora"	, "QRY", "Transportadora"	, Nil, 18, .F., {|| cTransport})   
TRCell():New(oSection1, "Frete"	, "QRY", "Frete"	, Nil, 18, .F., {|| cTpFrete}) 
TRCell():New(oSection1, "Redespacho"	, "QRY", "Redespacho"	, Nil, 18, .F., {|| cRedespacho})
TRCell():New(oSection1, "Estoque Auxiliar"	, "QRY", "Estoque Auxiliar"	, Nil, 10, .F., {|| CLocalAx})  
TRCell():New(oSection1, "Produto", "QRY", "Produto", Nil, 10, .F., {|| CodProd})
TRCell():New(oSection1, "Cod. Comercial", "QRY", "Cod. Comercial", Nil, 10, .F., {|| Codcom})
TRCell():New(oSection1, "Qtd. Estoque"	, "QRY", "Qtd. Estoque"	, "@E  99999", 10, .F., {|| QtdEstAx}) 
TRCell():New(oSection1, "Multiplo CX"	, "QRY", "Multiplo CX"	, "@E  99999", 10, .F., {|| QtdMultCx})
TRCell():New(oSection1, "Qtd. Vendas", "QRY", "Qtd. Vendas", "@E 99999", 10, .F., {|| QtdVen})
TRCell():New(oSection1, "Estq. Disp"	, "QRY", "Estq. Disp"	, "@E  99999", 10, .F., {|| QtdDisp})  
TRCell():New(oSection1, "Entrega"	, "QRY", "Entrega"	, Nil, 12, .F., {|| DtEnt})
TRCell():New(oSection1, "Representante"	, "QRY", "Representante"	, Nil, 10, .F., {|| cRepres})
//
 


Return(oReport)

/*
+----------------------------------------------------------------------------+
! Função    ! GARCRC02     ! Autor ! Nilson Gonçalves   ! Data !  12/04/2016 !
+-----------+--------------+-------+--------------------+------+-------------+
! Parâmetros! N/A                                                            !
+-----------+----------------------------------------------------------------+
! Descricao ! Impressão Relatório.										 	 !
+-----------+----------------------------------------------------------------+
*/
Static Function GARCRC03(oReport)   

Local TRT01     := GetNextAlias() 
Local TRT02     := GetNextAlias()
//Local TRT03     := GetNextAlias()
Local TRT04     := GetNextAlias() // temporario do total do pedido.
//Local TRT05    := GetNextAlias() // Analise de saldo na gauss
Local nSaldoT   := 0.00   
Local nSaldoD   := 0.00   
Local cProdAx   :=''          
Local CFilialAx:=''   
local nPos:=0
local nPos2:=0 
Local cAux1:=''
Local cAxFilial:=''
Local cAxLocal :=''
Local _QtdEstAx:=0.0
Local _CLocalAx:=''
Local nAxQtd   :=0.0
Local nx
Local nt
Private oSection1 := oReport:Section(1)
Private cLocSug   := MV_PAR03 //Armazém Sugerido.
Private _cCodigo  := ''             
Private cNomeRep  :=''


//CALCULO DE VALOR TOTAL COM ESTOQUE
	oSection1:BeginQuery()
	
 BeginSql Alias TRT04   
 	SELECT  C6_NUM ,
 					C6_PRODUTO,
					AVG((c6cdg.C6_QTDVEN - c6cdg.C6_QTDENT)*c6cdg.C6_PRCVEN)CDG_TOT 
				FROM SC6020 c6cdg, SC5020 c5cdg 
					WHERE c6cdg.D_E_L_E_T_=''
					and c5cdg.D_E_L_E_T_=''
					and C5_FILIAL = C6_FILIAL
					and C5_NUM = C6_NUM    
					and C5_FILIAL <>'03'
					and C6_LOCAL ='04'
					and C6_QTDEMP=0
					AND C5_XXLIB<>'2'  
					and C5_NOTA not like '%XX%'
					AND c6cdg.C6_QTDENT< c6cdg.C6_QTDVEN  
					AND c6cdg.C6_ENTREG>=20180101     
					and c6cdg.C6_BLQ<>'R'
			GROUP BY C6_NUM,C6_PRODUTO
			order by C6_PRODUTO,C6_NUM
			
			
 
 EndSql
 	oSection1:EndQuery()        
 	
 While !(TRT04)->(EOF())
	
  	AADD(aTot2,{(TRT04)->C6_NUM;
  				,(TRT04)->C6_PRODUTO;	  
  				,(TRT04)->CDG_TOT}) 
  				
  				
 	(TRT04)->(DbSkip())
EndDo	
 		

//criação de tabela temporária para encontrar o ultimo faturamento de cada pedido.
oSection1:BeginQuery()
 
 BeginSql Alias TRT01
 

 SELECT		C6_NUM ,
			SUM((c6cdg.C6_QTDVEN - c6cdg.C6_QTDENT)*c6cdg.C6_PRCVEN)CDG_TOT,
			C6_LOCAL,
			(SELECT MAX(F4_TEXTO) FROM SF4020 CDF4 WHERE CDF4.D_E_L_E_T_='' AND F4_CODIGO = MAX(C6_TES)) F4_TEXTO		
			FROM SC6020 c6cdg 
			WHERE c6cdg.D_E_L_E_T_=''
			and c6cdg.C6_QTDENT< c6cdg.C6_QTDVEN  
			and c6cdg.C6_ENTREG>=20180101 
			and c6cdg.C6_FILIAL ='01'   
			and C6_BLQ<>'R
		  group by C6_NUM,C6_LOCAL
		  order by C6_NUM
		  
						    
        EndSql        
        
                 

oSection1:EndQuery()  

While !(TRT01)->(EOF())
	
  	AADD(aTot,{(TRT01)->C6_NUM;  
  				,(TRT01)->CDG_TOT;
  				,(TRT01)->C6_LOCAL;
  				,(TRT01)->F4_TEXTO}) 
  				
  				
 	(TRT01)->(DbSkip())
EndDo
  				
  //tabela Principal
  BeginSql Alias TRT02
    SELECT 
		C6_FILIAL
		,C6_NUM
		,C6_ITEM 
		,C6_PRODUTO
	
		,C6_CLI
		,	(case
				when C6_CLI ='000203'and C5_TIPO = 'D' then 'GAUSS INDUSTRIA'
				else RTRIM(A1_NOME)
				end)A1_NOME
		,CONVERT(DATETIME,C5_EMISSAO) C5_EMISSAO
		,CONVERT(DATETIME,C6_ENTREG) C6_ENTREG
		,C6_CODCOM
		, C5_NOTA
		,C5_CONDPAG
		,C5_SERIE
		,C6_BLQ
		
		,C6_QTDVEN
		,C6_QTDENT
		,C6_QTDVEN-C6_QTDENT C6_SALDO
		,C6_CF
		,C6_TES 
		,C6_DATFAT
		,C6_VALOR 	
	   ,C5_VEND1  
	   	,(SELECT SUM((C6B.C6_QTDVEN - C6B.C6_QTDENT)*C6B.C6_PRCVEN)FROM %table:SC6% C6B WHERE C6B.%notdel% AND C6B.C6_NUM = SC6.C6_NUM 
								AND C6B.C6_FILIAL = SC6.C6_FILIAL  )TOT_VALOR	    
		,A1_EST 
		,F4_TEXTO
		


 
		,(SELECT CASE 
  				 WHEN MAX(C6C.C6_DATFAT) = '' THEN NULL 
   				 ELSE max(CAST(C6C.C6_DATFAT AS DATETIME) )
				END  FROM SC6020 C6C WHERE C6C.D_E_L_E_T_='' AND C6C.C6_NUM = SC6.C6_NUM AND
											C6C.C6_FILIAL = SC6.C6_FILIAL )	AS ULTDATFAT  
	    , B1_QTDCX     
	    ,(SELECT A3_NOME from SA3020 A3 WHERE A3.D_E_L_E_T_='' AND C5_VEND1 = A3_COD)A3_NOME 
	    ,A4_NREDUZ
	    ,A1_MUN   
	    ,C5_XXLIB
	    ,C5_TPFRETE                    
	    ,(SELECT MAX(E4_COND) FROM %table:SE4% E4  WHERE E4.D_E_L_E_T_='' AND E4_CODIGO = C5_CONDPAG) DESC_PAG
	    ,(SELECT MAX(A4_NOME) FROM %table:SA4% E4  WHERE E4.D_E_L_E_T_='' AND A4_COD = C5_REDESP) DESC_REDES,
	    A1_MSBLQL
	
FROM %table:SC6% SC6
	INNER JOIN %table:SA1% SA1 ON A1_COD=C6_CLI AND A1_LOJA=C6_LOJA  AND SA1.%notdel%
	INNER JOIN %table:SB2% SB2 ON C6_PRODUTO = B2_COD AND B2_FILIAL=C6_FILIAL AND C6_LOCAL = B2_LOCAL  AND SB2.%notdel%
	INNER JOIN %table:SF4% F4  ON C6_TES = F4_CODIGO AND F4.%notdel%  
	INNER JOIN %table:SC5% C5 ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL and C5.%notdel%
	INNER JOIN %table:SB1% B1  ON B1_COD = C6_PRODUTO AND B1.%notdel% 
	INNER JOIN %table:SA4% A4 ON   A4.%notdel%  AND C5_TRANSP = A4_COD
	WHERE   SC6.%notdel%
		AND C6_ENTREG>=20161001
		AND C6_ENTREG<=20201231
		AND F4_ESTOQUE ='S'   
		AND SC6.C6_LOCAL IN ('04')//,'08')
		AND C6_QTDEMP = 0  
		AND C6_BLQ<>'R'     
	   	AND (C6_QTDVEN-C6_QTDENT)>0
		AND C5.C5_EMISSAO between %Exp:DTOS(MV_PAR01)% and %Exp:DTOS(MV_PAR02)%
	order by C6_PRODUTO,C6_NUM	
		EndSql
     //Fim TRT02

	// Inclui informações das tabelas em um array
    //		AND C5_XXLIB<>'2'   
While !(TRT02)->(EOF())
  	   
		
  	AADD(aGarc,{(TRT02)->C6_NUM;
  				,(TRT02)->C6_NUM; // Código do pedido da CDG 
  				,(TRT02)->C6_CLI;// Código do cliente
  				,(TRT02)->A1_NOME; 
  				,(TRT02)->C6_CODCOM;
  				,(TRT02)->C6_PRODUTO;
  				,(TRT02)->C6_QTDVEN;
  				,(TRT02)->C5_EMISSAO;
  				,(TRT02)->C6_VALOR;
  				,(TRT02)->C6_SALDO;//10
  				,(TRT02)->C5_CONDPAG;
  				,(TRT02)->C6_ENTREG;//,(TRT02)->F4_TEXTO;  				
  				,(TRT02)->A1_NOME;
  				,(TRT02)->C6_FILIAL;
  				,(TRT02)->TOT_VALOR;
  				,(TRT02)->A1_EST; //16
  			    ,(TRT02)->F4_TEXTO;
  			    ,(TRT02)->ULTDATFAT;
  			    ,(TRT02)->B1_QTDCX;
  			    ,(TRT02)->A3_NOME;
  			    ,(TRT02)->A4_NREDUZ;
  			    ,(TRT02)->A1_MUN;
  			    ,(TRT02)->C5_XXLIB;
  			    ,(TRT02)->C5_TPFRETE;
  			    ,(TRT02)->DESC_PAG;
  			    ,(TRT02)->DESC_REDES;
  			    ,(TRT02)->A1_MSBLQL})//;
		                                  
	(TRT02)->(DbSkip())
EndDo              

    
		
//oSection1:Init()
      

	//nSaldoD
// Percorre o Array para impressão.
For nX := 1 to Len(aGarc) 
//saldo atual do item 
  	dbSelectArea("SB2")
  	dbSeek(xfilial("SB2")+aGarc[nX][6]+"04")
  	
  	nSaldoT := SaldoSb2() 
//fim Saldo atual Item   

		_QtdEstAx :=0.0
		_CLocalAx :='' 
		
  
  	if  aGarc[nX][6] <> cProdAx// .or. Empty(cProdAx) 
  	 
 	 nSaldoD := nSaldoT - aGarc[nX][7]  
 	
 	 _QtdDisp := nSaldoD      
 	 
 	 _QtdTot := nSaldoT
		if _QtdDisp<0
			if SB2->B2_QACLASS<>0
			_QtdEstAx:= SB2->B2_QACLASS
			_CLocalAx:='CDG 04'
			elseIf 	POSICIONE("SB2",1,xfilial("SB2")+aGarc[nX][6]+"09","B2_QATU")<>0
				_QtdEstAx := ((SB2->B2_QATU-SB2->B2_RESERVA)-SB2->B2_QACLASS)
				_CLocalAx :='CDG 09' 				
		  /*	elseif _QtdEstAx == 0 .and. _CLocalAx<>''
				   BEGINSQL ALIAS "TRT05"
						SELECT top 1 B2_FILIAL,B2_LOCAL, ((B2_QATU-B2_RESERVA)-B2_QACLASS+B2_QACLASS)as B2_QATU  
						FROM DB_GAUSS.dbo.SB2010 SB2 
						WHERE SB2.D_E_L_E_T_=''
						AND B2_COD =%Exp:aGarc[nX][6]% 
						AND B2_LOCAL ='04'
						AND B2_QATU <>0
						ORDER BY B2_FILIAL  
					ENDSQL
					TRT05->( dbGoTop() )
					cAxFilial := TRT05->B2_FILIAL 
					cAxLocal  := TRT05->B2_LOCAL
					nAxQtd    :=TRT05->B2_QATU
					TRT05->( dbCloseArea() )
					_QtdEstAx :=nAxQtd        
			
				 	if (!empty(cAxFilial)  .or.cAxFilial<>'') .and. nAxQtd <>0
					_CLocalAx:= 'Gauss '+cAxFilial+' '+cAxLocal
					ENDIF 
				
          */
				
			endif
		
		endIf
		
	
     
    endif
    If aGarc[nX][6] == cProdAx 
     
      
     nSaldoD := nSaldoD - aGarc[nX][7]
     
     _QtdDisp = nSaldoD 
	 
		if _QtdDisp <0
			if SB2->B2_QACLASS<>0
			_QtdEstAx:= SB2->B2_QACLASS 
			_CLocalAx:='CDG 04'
			elseIf 	!empty(POSICIONE("SB2",1,xfilial("SB2")+aGarc[nX][6]+"09","B2_QATU"))//<>0
		
				_QtdEstAx := ((SB2->B2_QATU-SB2->B2_RESERVA)-SB2->B2_QACLASS)//(SB2->B2_QATU-(SB2->B2_RESERVA+SB2->B2_QACLASS))
				_CLocalAx :='CDG 09'  
				
			/*elseIF  _QtdEstAx==0 .and. empty(_CLocalAx)
				   BEGINSQL ALIAS "TRT05"
						SELECT top 1 B2_FILIAL,B2_LOCAL, ((B2_QATU-B2_RESERVA)-B2_QACLASS+B2_QACLASS)as B2_QATU 
						FROM DB_GAUSS.dbo.SB2010 SB2 
						WHERE SB2.D_E_L_E_T_=''
						AND B2_COD =%Exp:aGarc[nX][6]% 
						AND B2_LOCAL ='04'
						AND B2_QATU <>0                              
						ORDER BY B2_FILIAL  
					ENDSQL
					TRT05->( dbGoTop() )
					cAxFilial := TRT05->B2_FILIAL 
					cAxLocal  :=TRT05->B2_LOCAL
					nAxQtd    :=TRT05->B2_QATU
					TRT05->( dbCloseArea() )
					_QtdEstAx :=nAxQtd        
				  	if (!empty(cAxFilial)  .or.cAxFilial<>'') .and. nAxQtd <>0
					_CLocalAx:= 'Gauss'+cAxFilial+' '+cAxLocal
                    EndIf  
           	*/			
			endif
		
		endIf
     
    endif      
    nAxQtd:=0.0 
    cAxFilial:='' 
    cAxLocal:=''
    
  
	 
	  //DbCloseArea("SB2") 
           
	_CdPedG     := aGarc[nX][1]
	_CdPedC 	:= aGarc[nX][2] 
	_CdCLiC     := aGarc[nX][3]
	_NmCliC		:= aGarc[nX][4]	
	_CodCom	    := aGarc[nX][5]
	_CodProd 	:= aGarc[nX][6]
	_QtdVen 	:= aGarc[nX][7]    
	_DtEmis 	:= aGarc[nX][8]  
	_NmFat		:= aGarc[nX][11] 
	_DtEnt 		:= aGarc[nX][12]
	
  //	_CodNat		:= aGarc[nX][13]  //

	
	//campos auxiliares
	cFilialAx:= aGarc[nX][14]
	//CAMPO COM VALOR TOTAL DO PEDIDO CDG   
	 /*For nZ:= 1 to len(aTot) 
	        if aGarc[nX][2] == aTot[nZ][1] 
	        _Nvlpcdg := aTot[nZ][2] 
	        _ClocCdg := aTot[nZ][3] 
	        _CodNat	 := aTot[nZ][4]
	        endIf
	   next nZ    */
	   
	_Nvlpcdg := aGarc[nX][15]
	_ClocCdg := aGarc[nX][16]  
	_CodNat  := aGarc[nX][17]  
	_cRepres := aGarc[nX][20]
	   

	
	//uLTIMO FAT   
	
  /*	BeginSql Alias TRT03 

  SELECT MAX(CONVERT(DATETIME,C6_DATFAT))AS ULTDATFAT,C6_NUM  
        FROM   %table:SC6% SC6
        WHERE SC6.%notdel%
                AND C6_LOCAL IN ( '04', '08' ) 
               AND C6_QTDEMP = 0 
               AND C6_BLQ <> 'R' 
               AND C6_QTDENT >= 1              
               AND C6_FILIAL = '01'
               and C6_NUM =  %Exp:_CdPedG% 
               GROUP BY C6_NUM     
 	EndSql             */
	
	_DtuFat	  :=aGarc[nX][18]
	_QtdMultCx:=aGarc[nX][19]
	//FIM ULT FAT
	_VlTotalP := aGarc[nX][9] 
	 
	_Transport  := aGarc[nx][21]
	_Municipio  := aGarc[nx][22] 
	_Liberado   := aGarc[nx][23] 
	_TpFrete    := aGarc[nx][24]     
	_DescPag    := aGarc[nx][25] 
	_Redespacho := aGarc[nx][26]   
	_cBloqueado := aGarc[nx][27]
	

	
	
	//_VlDisp   := aGarc[nX][8]
	
   //TRT03->(DbCloseArea())    
   
 		//DbCloseArea("TRT03") 
  
     

     //Imprimi a linha
//oSection1:PrintLine()
   //variavel para gravar ultimo item                          
     cProdAx:= aGarc[nX][6]   
     
     
        
       //Array Final
        AADD(aFinal,{_CdPedG;
   					,_CdPedC;
   					,_CdCLiC;
   					,_NmCliC;
   					,_CodCom;  //5
   					,_CodProd;
   					,_QtdVen;
   					,_DtEmis;
   					,_NmFat;
   					,_DtEnt;      //10
   					,_CodNat;
   					,_DtuFat;
   					,_QtdDisp;
   					,_VlTotalP;   
   					,_Nvlpcdg;  //15
   					,_ClocCdg;
					,_QtdEstAx;
					,_CLocalAx;
					,_QtdMultCx; 
					,_cRepres; //20
					,_Transport;
					,_Municipio; 
					,_Liberado;
					,_TpFrete;    
					,_DescPag;
					,_Redespacho;
					,_cBloqueado;
   					})

       
       
       //
     
Next nX
	//oReport:EndPage()
	//oReport:StartPage() 
	oSection1:Init()  
	For nT:=1 to len(aFinal)

			CdPedG	:=aFinal[nT][1]
   			CdPedC	:=aFinal[nT][2]
   			CdCLiC	:=aFinal[nT][3]
   			NmCliC	:=aFinal[nT][4]
   			CodCom	:=aFinal[nT][5]
   			CodProd	:=aFinal[nT][6]      
   			QtdVen	:=aFinal[nT][7]
   			DtEmis	:=aFinal[nT][8]
   			NmFat	:=aFinal[nT][9]
   			DtEnt	:=aFinal[nT][10]
   			CodNat	:=aFinal[nT][11]
   			DtuFat	:=aFinal[nT][12]
   			QtdDisp	:=aFinal[nT][13]
   			VlTotalP:=aFinal[nT][14] 
   			Nvlpcdg :=aFinal[nT][15]
   			ClocCdg :=aFinal[nT][16]
			QtdEstAx:=aFinal[nT][17]
			CLocalAx:=aFinal[nT][18]   
			QtdMultCx:=aFinal[nT][19]
			cRepres:=aFinal[nT][20] 
			cTransport:=aFinal[nT][21]  
			cMunicipio:=aFinal[nT][22]     
			if aFinal[nT][23] == '1'
				cLiberado:='Sim'
			else
				cLiberado:='Nao'
			endIf             
			cTpFrete 	:= aFinal[nT][24]
			cDescPag	:= aFinal[nT][25]
			cRedespacho := aFinal[nT][26]      
			
			if aFinal[nT][27] =='1'
				cBloqueado :='Sim'
			else
				cBloqueado :='Nao'
			endif
			
			
   		   //	For nL:=1 to Len(aFinal)  
   		    VlParcAux:=0 
   		    VlParcAux2:=0  
   		    nPos :=0   
   	
				   
   		   // Calculo de total com estoque dos pedidos cdg.
   		      While nPos < len(aFinal)  
   		        nPos++ 
   		        	          		       
   			   		if  aFinal[nT][2]==aFinal[nPos][2]    			   	
   			   			if aFinal[nPos][13]>0   // se não  houver saldo
   			   				nPos2:=1 
   			   				cAux1:=''
   			              if len(aTot2)<=1
   			            	while nPos2 < len(aTot2)//percorre toda a tabela de itens com saldo na CDG    			                    			                 
   			                	if  aFinal[nPos][6]== aTot2[nPos2][2].and. aFinal[nPos][2]==aTot2[nPos2][1] .and. cAux1<>aTot2[nPos2][2]//empty(cAux1) 
   			                 		cAux1:= aTot2[nPos2][2]
   			   	  	   				VlParcAux:=VlParcAux+aTot2[nPos2][3] 
   			   	  	   			endIf
   			   	  	   	   		nPos2++
   			   	  	   		enddo   
   			   	  		  else
   			   	  		  	while nPos2 < len(aTot2)+1//percorre toda a tabela de itens com saldo na CDG    			                    			                 
   			                	if  aFinal[nPos][6]== aTot2[nPos2][2].and. aFinal[nPos][2]==aTot2[nPos2][1] .and. cAux1<>aTot2[nPos2][2]//empty(cAux1) 
   			                 		cAux1:= aTot2[nPos2][2]
   			   	  	   				VlParcAux:=VlParcAux+aTot2[nPos2][3] 
   			   	  	   			endIf
   			   	  	   	   		nPos2++
   			   	  	   		enddo   
   			   	  		  
   			   	  		  endif
   			   	   		else   			   	   		
   			   	   	  		VlParcAux:=VlParcAux 
   			   	   		endif			   					   				
   		            
   		  
   			  		endIf
   			   	   			  
   			  endDo  
    	VlParc:=VlParcAux 
   			 
	
	oSection1:PrintLine()
	Next nT	                                               
	oSection1:Finish()

Return()
