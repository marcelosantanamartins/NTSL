////////////////////////////////////
//
// salvar em formato psf ou 
// editar no editor de estrategias(recomendado)
//
////////////////////////////////////
{
 indicador 

}
 /////////////////////////////////////////////////////////
//                                                     //
//                  Bollinger Breakout                 //
//                                                     //
//                 by: Rafael Peres                    //
//                                                     //
//     Par�metros      Per�odo: 20                     //
//                     Desvio: 1.0                     //
//                                                     //
//     tipo(Mode)      Aritm�tico 0                    //
//                     Exponencial 1                   //
//                     Welles Wilder 2                 //
//                     Ponderada 3                     //
//                                                     //
/////////////////////////////////////////////////////////

input
Periodo(20);
Desvio(1.0);
Mode(0);

begin
  // Verifica se possui posi��o vendida em aberto
  if (IsSold) then
    begin
      // Cobre a posi��o com uma compra � mercado
      if (Close > Open) and (Close > Media(Periodo, Close)) then
        BuyToCoverAtMarket;
                          
    end     
  // Verifica se possui posi��o comprada em aberto
  else if (IsBought) then
    begin
      // Cobre a posi��o com uma venda � mercado
      if (Close < Open) and (Close < Media(Periodo, Close)) then
        SellToCoverAtMarket;
                           
    end

  // Verifica se deve abrir uma posi��o     
  else if Close > BollingerBands(Desvio, Periodo, Mode)|0| then
    BuyAtMarket
  else if Close < BollingerBands(Desvio, Periodo, Mode)|1| then
    SellShortAtMarket;
end;

