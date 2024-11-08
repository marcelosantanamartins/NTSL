var
  currentColor, previousColor: Integer;
  movingAverage: Float;

begin
  // Calcula a média móvel de 51 períodos
  movingAverage := Media(51, Close);

  // Pinta os candles de acordo com a posição em relação à média móvel
  if (Close > movingAverage) then
  begin
    currentColor := rgb(0, 150, 0); // Verde
    PaintBar(currentColor);
    
    // Comprar quando o candle fechar verde e o Close for maior que a Open
    if not isBought and (Close > Open) then
    begin
      BuyAtMarket;
    end;
  end
  else if (Close < movingAverage) then
  begin
    currentColor := rgb(255, 0, 0); // Vermelho
    PaintBar(currentColor);
    
    // Vender quando o candle fechar vermelho e o Close for menor que a Open
    if not isSold and (Close < Open) then
    begin
      SellShortAtMarket;
    end;
  end
  else if (Close[1] > movingAverage) and (Close < Open) then
  begin
    currentColor := rgb(255, 255, 255); // Branco
    PaintBar(currentColor);
    
    // Sair da posição de compra quando o candle fecha branco
    if isBought then
    begin
      SellToCoverAtMarket;
    end;
  end
  else if (Close[1] < movingAverage) and (Close > Open) then
  begin
    currentColor := rgb(255, 255, 255); // Branco
    PaintBar(currentColor);
    
    // Sair da posição de venda quando o candle fecha branco
    if isSold then
    begin
      BuyToCoverAtMarket;
    end;
  end;

  // Verifica se a cor mudou
  if (previousColor <> currentColor) then
  begin
    // Sai da posição se a cor do candle mudar
    if isBought and (currentColor <> rgb(0, 150, 0)) then
    begin
      SellToCoverAtMarket;
    end
    else if isSold and (currentColor <> rgb(255, 0, 0)) then
    begin
      BuyToCoverAtMarket;
    end;
  end;

  // Atualiza a cor anterior
  previousColor := currentColor;

  Plot(movingAverage);
end;
