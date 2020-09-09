#include "rwmake.ch" 
#INCLUDE "topconn.ch"

//Rotina para ZERAR Valor SB9 quando quantidade igual 00, devido a sujeira processo (rotina não identificada)
//@paulooliveira
//b2_rotina
//17/07/20

User function ZeraVlrSB9Qtd0() 

    _okA:= "S"
    _ames	:=month(ddatabase) - 1 
    _ano	:=YEAR(DDATABASE)
    _cano	:=strzero(_ano,4)
    _cmes	:=strzero(_ames,2)
    _cdta1:=_cano+_cmes

   // alert(_cdta1)

    
    Processa({|| okAtub9()})  // Atualiza Vlr com Qtd 00 Sb9

Return	

Static function okAtub9()   
    
	_Qry1 := "UPDATE "  + RetSqlName('SB9') + "  SET B9_VINI1 = '0', B9_CUSTD = '0' "
	_Qry1 += "WHERE B9_QINI = '0'  AND B9_VINI1 <> '0'  AND (LEFT(B9_DATA,6) >= '" +  _cdta1 +"') AND  D_E_L_E_T_ = ''" 
   	
	TcSqlExec(_Qry1)
 	TcRefresh(_Qry1)     

   	If TCSqlExec(_Qry1) < 0
      			Alert("Ocorreu um erro ao tentar atualizar os registros SB9")
      			_okA:= "N"
               Return .f.
    Endif
	
Return

