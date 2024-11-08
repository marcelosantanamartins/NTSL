{
WINFUT 17R
WDOFUT
}
input
  PeriodoDEMA(21);
  Source(close);
var
  DEMA            : Float;
  isBought,isSold : Boolean;
begin
  if time < 1800 then
    begin
      DEMA := (2 * MediaExp(PeriodoDEMA,Source)) - MediaExp(PeriodoDEMA,MediaExp(PeriodoDEMA,Source));
      if Close > DEMA then
        begin
          PaintBar(clLime);
          // Compra quando o candle fechar verde e não há uma compra ativa
          if not isBought then
            begin
              BuyAtMarket;
              isBought := True;
              isSold := False;
            end;
        end
      else if Close < DEMA then
        begin
          PaintBar(clRed);
          // Venda quando o candle fechar vermelho e não há uma venda ativa
          if not isSold then
            begin
              SellShortAtMarket;
              isSold := True;
              isBought := False;
            end;
        end;
      // Fechar a posição de compra quando o preço fechar abaixo da DEMA ou no sentido inverso (candle vermelho)
      if isBought and (Close < DEMA) or (Close < DEMA) then
        begin
          SellToCoverAtMarket;
          isBought := False;
        end;
      // Fechar a posição de venda quando o preço fechar acima da DEMA ou no sentido inverso (candle verde)
      if isSold and (Close > DEMA) or (Close > DEMA) then
        begin
          BuyToCoverAtMarket;
          isSold := False;
        end;
      Plot(DEMA);
    end
  else 
    ClosePosition;
end;