{
+-----------------------------------------------------------------------------+
|                             CANDLESTICKTYPE.PSF                             |
+-----------------------------------------------------------------------------+
|                                                                             |
| Autor....: Alessandro Renner                                                |
|                                                                             |
| Descri��o: Script utilizado para marcar os "tipos" de candlestick: martelo, |
|            martelo invertido e doji em gr�ficos Heikin Ashi sobre o  Renko. |
|            Apresenta a utiliza��o da fun��o HeikinAshi().                   |
|                                                                             |
| Licen�a..: Apenas para uso pessoal e estudos, n�o deve ser  utilizada  para |
|            fins comerciais sem a expressa autoriza��o do autor.             |
|                                                                             |
| Vers�o...: 1.0 (publica��o inicial)                                         |
|                                                                             |
+-----------------------------------------------------------------------------+

Fun��o HeikinAshi()

A fun��o (indicador) HeikinAshi(), retorna um valor do tipo float,  de  acordo 
com a m�dia, o tipo da m�dia e o dado desejado.

Sintaxe
HeikinAshi(M�dia, Tipo da m�dia)|Dado Desejado|.

Par�metros
� M�dia: 
  M�dia utilizada no momento do c�lculo do indicador;

� Tipo de M�dia: 
  Determina o tipo da m�dia utilizada, onde: 
  - "0" � Aritm�tica, 
  - "1" � Exponencial, 
  - "2" � Welles Wilder e 
  - "3" � Ponderada; 

� Dado Desejado: 
  Determina o dado desejado, onde: 
  - Open   = 0
  - M�xima     = 2
  - M�nima     = 3 
  - Close = 1
}

var
  VlrAbr : float;   //valor da Open   (O)
  VlrMxm : float;   //valor da m�xima     (H)
  VlrMnm : float;   //valor da m�nima     (L)
  VlrFch : float;   //valor do Close (C)

  SmbSpr : float;   //sombra superior
  SmbInf : float;   //sombra inferior
  
  CrpCnd : float;   //corpo do candle (tamanho)

begin
  
  //obtendo o pre�o Heilin Ashi
  //{
  VlrAbr := HeikinAshi(1,0)|0|;
  VlrMxm := HeikinAshi(1,0)|2|;
  VlrMnm := HeikinAshi(1,0)|3|;
  VlrFch := HeikinAshi(1,0)|1|;
  //}
  
  //c�lculo do tamanho do candle e das sombras
  //{
  CrpCnd := ABS(VlrAbr-VlrFch);
  
  SmbSpr := VlrMxm-VlrAbr;
  SmbInf := VlrFch-VlrMnm;
  
  if 
    (VlrAbr < VlrFch)
  then
    begin
      SmbSpr := VlrMxm-VlrFch;
      SmbInf := VlrAbr-VlrMnm;
    end;   
  //}

  //---------------------------------------------------------------------------

  //{
  //doji
  if
    (CrpCnd < (VlrMxm-VlrMnm)*0.025)
  then
    begin
      PaintBar (RGB(000,000,255));
    end;
  //} 
  
  //{
  //martelo
  if
        (VlrAbr > VlrFch)
    and (CrpCnd > (VlrMxm-VlrMnm)*0.025)
    and (SmbInf > SmbSpr*1.5)
    and (CrpCnd < SmbInf)
  then
    begin
      PaintBar (RGB(000,128,000));
    end;
  
  //}
  
  //martelo invertido
  if
        (VlrAbr < VlrFch)
    and (CrpCnd > (VlrMxm-VlrMnm)*0.025)
    and (SmbSpr > SmbInf*1.5)
    and (CrpCnd < SmbSpr)
  then
    begin
      PaintBar (RGB(255,000,000));
    end;
  //}
end;
