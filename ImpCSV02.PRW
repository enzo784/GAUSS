#INCLUDE "rwmake.ch"    

//IMportacao de arquivos CSV Tabela de Preco - Controladoria
//13-08-2020
//Enzo Piovesan

User Function IMPCSV2()      
	count:=0
	iF MsgNoYes ( "Atualiza ?", "Tabela Preço??? " ) == .t.
		Processa({|| okSegue()})
		alert("atualizados " + str(count))
	endif	

RETURN

Static function okSegue()

	//INICIO DA LEITURA DO TXT
	nHandle := FT_FUse("C:\varios\TABELAPRECO\TabPRC.csv")

	// Se houver erro de abertura abandona processamento
	if nHandle = -1 
		alert("Erro C:\varios\TABELAPRECO\TabPRC.csv")
		return
	endif

	// Posiciona na primeria linha
	FT_FGoTop()

	// Retorna o n�mero de linhas do arquivo
	nLast := FT_FLastRec()

//BEGIN TRANSACTION 
count:=1
While !FT_FEOF() 
	
	cLine := FT_FReadLn() // Retorna a linha corrente
	if empty(cLine)  
	   	FT_FSKIP()  
		loop
   	endif           
   
	nRecno := FT_FRecno() // Retorna o recno da Linha
    cTextArr:= cLine //"Primeiro;Segundo;Terceiro" 
    aRet    := StrTokArr(cLine,";") // Resultado: aRet[1]="Primeiro" / aRet[2]="Segundo" / aRet[3]="Terceiro" 
	ctab	:=	strzero(val(aRet[2]),3) //tabela preco
	prod	:=	aRet[1]
    cValor1 := 	strtran(aRet[3],",",".") 
	seq:= strzero(count,4)

	Dbselectarea("DA1")
	dBGOTOP()
	if DBSEEK( xfilial('  ')+ctab+PROD) == .t.

		Reclock("DA1",.f.)
		DA1->DA1_PRCVEN := val(cValor1)
		MsUnlock()

	Endif	

   	FT_FSKIP()
	count := count +1

End                  
   
Return	
