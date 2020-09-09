User Function A261LO1( )

Local cProduto := M->QEK_PRODUTO //-- Codigo do Produto
Local cLocInf  := M->D7_LOCDEST //-- Local Informado
Local nOriDest := 2 //-- 1 - Origem / 2 - Destino
Local aRet     := .T.

If nOriDest == 2   
    CriaSB2(cProduto,cLocInf) //-- Cria registro no SB2 referente a produto e local inexistente
EndIf

Return aRet
