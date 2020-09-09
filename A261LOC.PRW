User Function A261LOC( )

Local cProduto := ParamIXB[1] //-- Codigo do Produto
Local cLocInf  := ParamIXB[2] //-- Local Informado
Local nOriDest := ParamIXB[3] //-- 1 - Origem / 2 - Destino

If nOriDest == 2   
    CriaSB2(cProduto,cLocInf) //-- Cria registro no SB2 referente a produto e local inexistente
EndIf

Return Nil
