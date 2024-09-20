input
  PeriodoDonchian(11);
  PeriodoATR(20);
  MultATR(2.0);
  PeriodoReentrada(55);
  Capital(50000);
  RiscoMax(0.02);
  HorarioInicio(900);
  HorarioFim(1800);

var
  donchianUpper, donchianLower : Real;
  atr, PrecoEntrada            : Real;
  CandleEntrada                : Integer;  // Variável para armazenar o candle da entrada

Begin
  donchianUpper := DonchianCh(PeriodoDonchian)|1|;
  donchianLower := DonchianCh(PeriodoDonchian)|2|;
  atr := AvgTrueRange(PeriodoATR, 0);

  if (Time >= HorarioInicio) and (Time < HorarioFim) then
  begin
    // Rompimento superior para compra
    if (Close > donchianUpper[1]) then
    begin
      if (not HasPosition) then
      begin
        BuyAtMarket;
        PrecoEntrada := BuyPrice;
        CandleEntrada := ContadorDeCandle;  // Gravar o candle da entrada
        SellToCoverStop(PrecoEntrada - (MinPriceIncrement * 1)); // Stop com 1 tick abaixo
        ConsoleLog("Comprando ao romper limite superior. Preço de entrada: " + PrecoEntrada);
      end;
      PaintBar(clLime);
    end;

    // Rompimento inferior para venda
    if (Close < donchianLower[1]) then
    begin
      if (not HasPosition) then
      begin
        SellShortAtMarket;
        PrecoEntrada := SellPrice;
        CandleEntrada := ContadorDeCandle;  // Gravar o candle da entrada
        BuyToCoverStop(PrecoEntrada + (MinPriceIncrement * 1)); // Stop com 1 tick acima
        ConsoleLog("Vendendo ao romper limite inferior. Preço de entrada: " + PrecoEntrada);
      end;
      PaintBar(clRed);
    end;
  end;

  // Se houver posição, verificar saída no candle contrário
  if IsBought then
  begin
    // Candle de baixa durante uma compra (fechar posição)
    if (Close < Open) then
    begin
      ConsoleLog("Candle de baixa após compra. Fechando posição.");
      ClosePosition;
    end;
  end;

  if IsSold then
  begin
    // Candle de alta durante uma venda (fechar posição)
    if (Close > Open) then
    begin
      ConsoleLog("Candle de alta após venda. Fechando posição.");
      ClosePosition;
    end;
  end;

  // Plot do Canal de Donchian
  plot(donchianUpper);
  plot2(donchianLower);
  SetPlotColor(1, clBlue);
  SetPlotColor(2, clBlue);

End.
