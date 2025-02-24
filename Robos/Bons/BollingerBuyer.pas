/////////////////////////////////////////////////////////
//                                                     //
//                  Bollinger Buyer                    //
//                                                     //
//                 by: Rafael Peres                    //
//                                                     //
//     Parâmetros      Período: 20                     //
//                     Desvio: 3.0                     //
//                     Aritmético 0 - Exponencial 1    //
//                     Welles Wilder 2 - Ponderada 3   //
//                                                     //
/////////////////////////////////////////////////////////

input
Periodo(20);
Desvio(3.0);
Mode(3);

begin
  // Verifica se possui posição vendida em aberto
  if (IsSold) then
    begin
      // Cobre a posição com uma compra a mercado
      if (Close <= Media(Periodo, Close)) or (SellPrice < Close[1])  then
        BuyToCoverAtMarket;
                          
    end     
  // Verifica se possui posição comprada em aberto
  else if (IsBought) then
    begin
      // Cobre a posição com uma venda a mercado
      if (Close >= Media(Periodo, Close)) or (BuyPrice < Close[1]) then
        SellToCoverAtMarket;
                           
    end

  // Verifica se deve abrir uma posição     
  else if (Close < BollingerBands(Desvio, Periodo, Mode)|1|) or (Minima <= BollingerBands(Desvio, Periodo, Mode)|1|) then
    BuyAtMarket
  else if (Close > BollingerBands(Desvio, Periodo, Mode)|0|) or (Maxima >= BollingerBands(Desvio, Periodo, Mode)|0|) then
    SellShortAtMarket;
end;








