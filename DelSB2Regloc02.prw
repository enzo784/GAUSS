#include "rwmake.ch" 

//Rotina para ZERAR Saldos em estoque do Local 00, devido a sujeiro(rotina não identificada)
//@paulooliveira
//b2_rotina
//16/07/20

User function DelLoc00SB2() 

_okA:= "S"
_okD:= "S"
_msg:= "Deseja depurar saldo SB2 Local == 00 ??? "	

	if SM0->M0_CODIGO	<>	'01'
	//	ALERT("Somente GAUSS")
		Return .f.  
	endif
    

  //  iF MsgNoYes ( _msg, "Produto " ) == .t.
		Processa({|| okAtu()})  // Atualiza Local 00
	    Processa({|| okDele()}) // Pack Local 00
//	else
 //      Return
  //  endif	
	
    if _okA == "N" .or. _okD == "N"
   //     alert("Processo NÃO realizado! ") 
    else     
    //    alert("Processo Realizado normalmente! ") 
	ENDIF	
Return	

Static function okAtu()   
    
	_Qry1 := "UPDATE "  + RetSqlName('SB2') + " SET B2_QFIM = '0' , B2_QATU = '0', B2_VFIM1 = '0', B2_VATU1 = '0', B2_CM1 = '0' "
	_Qry1 += "WHERE B2_LOCAL = '00'  AND  D_E_L_E_T_ = '' " 
   	
	TcSqlExec(_Qry1)
 	TcRefresh(_Qry1)     

//   	If TCSqlExec(_Qry1) < 0
//      			MsgBox("Ocorreu um erro ao tentar atualizar os registros Local 00 da tabela Sb2. A rotina sera abortada.","Inconsistencia - Passo 1")
//      			_okA:= "N"
////                Return .f.
//    Endif
	
Return

Static Function okDele()

	_Qry2 := "DELETE "  + RetSqlName('SB2')  
	_Qry2 += " WHERE B2_LOCAL = '00' AND D_E_L_E_T_ = '*' " 
   	
	TcSqlExec(_Qry2)
 	TcRefresh(_Qry2)     

 //  	If TCSqlExec(_Qry2) < 0
 //     			MsgBox("Ocorreu um erro ao tentar deletar os registros Local 00 da tabela Sb2. A rotina sera abortada.","Inconsistencia - Passo 1")
 //     			_okD:= "N"
 //                MsgBox("TCSQLError() " + TCSQLError())
 //                Return .f.
 //   Endif
 
 Return   
						 
		
			