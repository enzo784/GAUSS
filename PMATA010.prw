#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

//Rotina de Replica��o Cadastro de Produto GAUSS PARA CDG E SPG
//@PAULO.OLIVEIRA
//01/07/2020
//FunName() $ 'PMata010' - relacao com o CodProd(sx3)
user function PMata010()

	_cOrig	:= "2" 				//Origem CDG e SPG sempre 2
	_emp	:= sm0->m0_codigo	//Empresa Logada
	_proc	:=	0 //processados
	_msg	:= ""

	if  _emp =='01' 
		alert("Rotina de replicacao somente na CDG ou SPG !!!")
	elseif _emp == '02'
		_msg := "Replicar Produtos na CDG?"
	else 
		_msg := "Replicar Produtos na SPG?"
	endif	
	 
	iF _emp <> '01' .and. MsgNoYes ( _msg, "Produto " ) == .t.
		Processa({|| okSegue()})
	endif	

Return

//-------------------------------------
   Static Function okSegue()            
//-------------------------------------  

	okCArrega()

	dbSelectArea("QRY_SB1")  
	dbGoTop()		 
	Procregua(lastrec())
	While !eof()
	//alert(QRY_SB1->_COD)

		aVetor := {}
		lMsErroAuto := .F.

		aVetor:= { {"B1_COD" ,QRY_SB1->_COD ,NIL},;
		{"B1_CODCOM" ,QRY_SB1->_CODCOM ,NIL},;
		{"B1_DESC" ,QRY_SB1->_DESC ,NIL},;
		{"B1_DESCSEC" ,QRY_SB1->_DESCSEC ,NIL},;
		{"B1_TIPO" ,QRY_SB1->_TIPO ,Nil},;
		{"B1_MARCA" ,QRY_SB1->_MARCA ,Nil},;
		{"B1_SEQ" ,QRY_SB1->_SEQ ,Nil},;
		{"B1_TIPPRO" ,QRY_SB1->_TIPPRO ,Nil},;
		{"B1_UM" ,QRY_SB1->_UM ,Nil},;
		{"B1_LOCPAD" ,QRY_SB1->_LOCPAD ,Nil},;
		{"B1_POSIPI" ,QRY_SB1->_POSIPI ,Nil},;
		{"B1_CONTA" ,QRY_SB1->_CONTA ,Nil},;
		{"B1_ITEMCC" ,QRY_SB1->_ITEMCC ,Nil},;
		{"B1_GRUPO" ,QRY_SB1->_GRUPO ,Nil},;
		{"B1_ORIGEM" ,_cOrig ,Nil},;
		{"B1_RASTRO" ,QRY_SB1->_RASTRO ,Nil},;
		{"B1_MRP" ,QRY_SB1->_MRP ,Nil},;
		{"B1_CODBAR" ,QRY_SB1->_CODBAR ,Nil},;
		{"B1_X_TPSP" ,QRY_SB1->_X_TPSP ,Nil},;
		{"B1_GARANT" ,QRY_SB1->_GARANT ,Nil},;
		{"B1_IMPORT" ,QRY_SB1->_IMPORT ,Nil},;
		{"B1_RASTRO" ,QRY_SB1->_RASTRO ,Nil},;
		{"B1_PESO" ,QRY_SB1->_PESO ,Nil},;
		{"B1_PESBRU" ,QRY_SB1->_PESBRU ,Nil},;
		{"B1_QTDCX " ,QRY_SB1->_QTDCX ,Nil},;
		{"B1_XXDIMBA" ,QRY_SB1->_XXDIMBA ,Nil},;
		{"B1_XXDIMBL" ,QRY_SB1->_XXDIMBL ,Nil},;
		{"B1_XXDIMBC" ,QRY_SB1->_XXDIMBC ,Nil},;
		{"B1_XXQTEMB" ,QRY_SB1->_XXQTEMB ,Nil},;
		{"B1_EX_NBM" ,QRY_SB1->_EX_NBM ,Nil},;
        {"B1_SEGUM" ,QRY_SB1->_SEGUM ,Nil},;
        {"B1_MSBLQL" ,QRY_SB1->_MSBLQL ,Nil},;
        {"B1_TOLER" ,QRY_SB1->_TOLER ,Nil},;
        {"B1_APROPRI" ,QRY_SB1->_APROPRI ,Nil},;
        {"B1_XXMULTB" ,QRY_SB1->_XXMULTB ,Nil},;
        {"B1_PRVALID" ,QRY_SB1->_PRVALID ,Nil},;
        {"B1_QTDFARD" ,QRY_SB1->_QTDFARD ,Nil},;
        {"B1_LOCALIZ" ,QRY_SB1->_LOCALIZ ,Nil},;
        {"B1_EX_NCM" ,QRY_SB1->_EX_NCM ,Nil}}
		//{"B1_CODANT" ,QRY_SB1->_CODANT ,Nil},;	
		// {"B1_XXLANCA" ,QRY_SB1->_XXLANCA ,Nil},;

  
		dbSelectArea('SB1')
		dbSetOrder(1)
		DBGOTOP()
		IF DBSEEK( XFILIAL('SB1')+QRY_SB1->_COD)==.F.	
			MSExecAuto({|x,y| Mata010(x,y)},aVetor,3)
			_proc:=_proc +1
		ENDIF		
 
		If lMsErroAuto
			MostraErro()
		Endif
		
		dbSelectArea("QRY_SB1")  
		Dbskip()
		//incproc()

	EndDo
	dbSelectArea("QRY_SB1")  
	dbCloseArea()
	Alert("Incluido total de " + AllTrim(str(_proc)) + "produtos")

Return

Static function okCarrega()

		
	cQuery := " SELECT SB1.B1_MARCA _MARCA, SB1.B1_TIPPRO _TIPPRO, SB1.B1_TIPO _TIPO, SB1.B1_GRUPO _GRUPO, SB1.B1_SEQ _SEQ,SB1.B1_COD _COD, SB1.B1_DESC _DESC,SB1.B1_CODCOM _CODCOM,"
	cQuery += " SB1.B1_LOCPAD _LOCPAD, SB1.B1_CONTA  _CONTA, SB1.B1_ITEMCC _ITEMCC, SB1.B1_IMPORT _IMPORT, SB1.B1_UM _UM,SB1.B1_X_TPSP _X_TPSP,SB1.B1_DESCSEC _DESCSEC,"
	cQuery += " SB1.B1_POSIPI _POSIPI, SB1.B1_ORIGEM _ORIGEM,SB1.B1_MRP 	_MRP, SB1.B1_GARANT _GARANT, SB1.B1_RASTRO _RASTRO, SB1.B1_PESO _PESO, SB1.B1_PESBRU _PESBRU, SB1.B1_CODBAR _CODBAR," 
	cQuery += " SB1.B1_EX_NCM _EX_NCM, SB1.B1_EX_NBM _EX_NBM,SB1.B1_SEGUM 	_SEGUM, SB1.B1_DESBLOC _DESBLOC, SB1.B1_MSBLQL _MSBLQL, SB1.B1_TOLER _TOLER, SB1.B1_APROPRI _APROPRI, SB1.B1_XXMULTB _XXMULTB," 
	cQuery += " SB1.B1_XXQTEMB _XXQTEMB, SB1.B1_PRVALID _PRVALID,SB1.B1_CODANT _CODANT, SB1.B1_QTDFARD _QTDFARD, "
	cQuery += " SB1.B1_LOCALIZ _LOCALIZ, SB1.B1_EX_NCM _EX_NCM," 	
	cQuery += " SB1.B1_QTDCX  _QTDCX, SB1.B1_XXDIMBA _XXDIMBA, SB1.B1_XXDIMBL _XXDIMBL, SB1.B1_XXDIMBC _XXDIMBC "
	cQuery += " FROM DB_GAUSS.DBO.SB1010 SB1 "
	cQuery += " WHERE SB1.D_E_L_E_T_ <> '*' "

	if sm0->m0_codigo == '02'
		cQuery += "AND SB1.B1_XXEXP02 = '1' " 
	else
		cQuery += "AND SB1.B1_XXEXP03 = '1' " 
	endif		
	
	cQuery += "ORDER BY SB1.B1_COD "
	cQuery := ChangeQuery(cQuery)     
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cQuery),"QRY_SB1",.F.,.T.)

Return

	
	
	
	
 
	
	