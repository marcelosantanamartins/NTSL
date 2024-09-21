input
  PeriodoBollinger(20);  // Período para as Bandas de Bollinger
  TipoMediaBollinger(0); // Tipo de média (0 para Aritmética, 1 para Exponencial, 2 para Welles Wilder, 3 para Ponderada)
  DesvioPadrao(2.0);     // Desvio padrão para as Bandas de Bollinger
  Capital(50000);        // Capital total para cálculo de risco
  RiscoMax(0.02);        // Percentual de risco máximo por operação (2%)
  RelacaoRiscoRecompensa(2.0); // Relação de risco-recompensa desejada

var
  bollingerUpper, bollingerLower: Real;
  PrecoEntrada, StopLoss: Real;
  contadorCandles: Integer;

inicio
  // Cálculo das Bandas de Bollinger
  bollingerUpper := BollingerBands(DesvioPadrao, PeriodoBollinger, TipoMediaBollinger)|0|;
  bollingerLower := BollingerBands(DesvioPadrao, PeriodoBollinger, TipoMediaBollinger)|1|;

  // Monitorar o toque nas Bandas de Bollinger
  if (Close < bollingerLower) and (not HasPosition) then
  begin
    // Aguardar um candle contrário
    contadorCandles := 0;
    while contadorCandles < 1 do
    begin
      contadorCandles := contadorCandles + 1;
    end;

    // Calcular o stop loss
    StopLoss := (PrecoEntrada - Close) * RelacaoRiscoRecompensa;

    // Entrar na operação de compra
    BuyAtMarket;
    PrecoEntrada := BuyPrice;
    SellToCoverStop(PrecoEntrada - StopLoss);
  end
  else if (Close > bollingerUpper) and (HasPosition) then
  begin
    // Sair da operação quando ocorrer um candle na direção oposta
    contadorCandles := 0;
    while contadorCandles < 1 do
    begin
      contadorCandles := contadorCandles + 1;
    end;

    ClosePosition;
  end;

  plot(bollingerUpper);
  plot2(bollingerLower);
  SetPlotColor(1, clBlue);
  SetPlotColor(2, clBlue);
end.
