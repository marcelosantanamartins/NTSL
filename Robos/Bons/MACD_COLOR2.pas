{
  WDOFUT 6R
}
input
  Slow(26);
  Fast(12);
  Sinal(9);
var
  sNewIND                 : Float;
  entryPrice,trailingStop : Float;
begin
  if Time < 1800 then
    begin
      sNewIND := MACD(Slow,Fast,Sinal)|1|;
      Plot(sNewIND);
      Plot2(Media(1,sNewIND));
      Plot3(Media(3,sNewIND));
      if (Media(1,sNewIND) - Media(3,sNewIND)) > 0 then
        begin
          PaintBar(clVerde);
          // Comprar quando o candle fechar verde e não há uma compra ativa
          if not isBought and not isSold then
            begin
              BuyAtMarket;
              entryPrice := Close;
              trailingStop := Low[2];
              // Define o stop no Close do segundo candle anterior
            end;
        end
      else 
        begin
          PaintBar(clVermelho);
          // Vender quando o candle fechar vermelho e não há uma venda ativa
          if not isSold and not isBought then
            begin
              SellShortAtMarket;
              entryPrice := Close;
              trailingStop := High[2];
              // Define o stop no Close do segundo candle anterior
            end;
        end;
      // Fechar a posição de compra quando o preço fechar abaixo da média ou atingir o trailing stop
      if isBought and (((Media(1,sNewIND) - Media(3,sNewIND)) < 0) or (Low <= trailingStop)) then
        begin
          SellToCoverAtMarket;
        end;
      // Fechar a posição de venda quando o preço fechar acima da média ou atingir o trailing stop
      if isSold and (((Media(1,sNewIND) - Media(3,sNewIND)) > 0) or (High >= trailingStop)) then
        begin
          BuyToCoverAtMarket;
        end;
    end
  else 
    ClosePosition;
end;




