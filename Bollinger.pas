input
  PeriodoBollinger(20);          // Período para as Bandas de Bollinger
  TipoMediaBollinger(0);         // Tipo de média (0 para Aritmética, 1 para Exponencial, 2 para Welles Wilder, 3 para Ponderada)
  DesvioPadrao(2.0);             // Desvio padrão para as Bandas de Bollinger
  TicksStop(4);                  // Número de ticks para o stop inicial
  TicksLucro(5);                 // Número de ticks para ajustar o stop para 1 tick positivo

var
  bollingerUpper, bollingerLower, bollingerMiddle: Real;
  PrecoEntrada, StopLoss, NovoStop: Real;

inicio
  // Cálculo das Bandas de Bollinger
  bollingerUpper := BollingerBands(DesvioPadrao, PeriodoBollinger, TipoMediaBollinger)|0|;
  bollingerLower := BollingerBands(DesvioPadrao, PeriodoBollinger, TipoMediaBollinger)|1|;
  bollingerMiddle := (bollingerUpper + bollingerLower) / 2;  // Linha do meio das bandas

  // Verificar condição de entrada de COMPRA: candle fecha fora da banda inferior e volta para dentro
  if (Close[1] < bollingerLower) and (Close > bollingerLower) and (not HasPosition) and (Close < bollingerMiddle) and (Close > Open) then
  begin
    // Entrar na operação de compra
    BuyLimit(Close);
    PrecoEntrada := BuyPrice;

    // Definir stop inicial 4 ticks abaixo do ponto de entrada
    StopLoss := PrecoEntrada - (TicksStop * MinPriceIncrement);
    SellToCoverStop(StopLoss);
  end;

  // Verificar condição de entrada de VENDA: candle fecha fora da banda superior e volta para dentro
  if (Close[1] > bollingerUpper) and (Close < bollingerUpper) and (not HasPosition) and (Close > bollingerMiddle) and (Close < Open) then
  begin
    // Entrar na operação de venda
    SellShortLimit(Close);
    PrecoEntrada := SellPrice;

    // Definir stop inicial 4 ticks acima do ponto de entrada
    StopLoss := PrecoEntrada + (TicksStop * MinPriceIncrement);
    BuyToCoverStop(StopLoss);
  end;

  // Ajuste do stop após atingir 5 ticks de lucro
  if (HasPosition) then
  begin
    if (PrecoEntrada + (TicksLucro * MinPriceIncrement) <= High) then
    begin
      // Ajustar stop para 1 tick positivo na compra
      StopLoss := Max(StopLoss, PrecoEntrada + (1 * MinPriceIncrement));
      SellToCoverStop(StopLoss);
    end
    else if (PrecoEntrada - (TicksLucro * MinPriceIncrement) >= Low) then
    begin
      // Ajustar stop para 1 tick positivo na venda
      StopLoss := Min(StopLoss, PrecoEntrada - (1 * MinPriceIncrement));
      BuyToCoverStop(StopLoss);
    end;
  end;

  // Ajuste do stop para a linha média das bandas com 4 ticks de margem
  if (HasPosition) then
  begin
    if (Close >= bollingerMiddle) then
    begin
      NovoStop := Max(StopLoss, bollingerMiddle - (TicksStop * MinPriceIncrement));
      SellToCoverStop(NovoStop);  // Stop de compra
    end
    else if (Close <= bollingerMiddle) then
    begin
      NovoStop := Min(StopLoss, bollingerMiddle + (TicksStop * MinPriceIncrement));
      BuyToCoverStop(NovoStop);   // Stop de venda
    end;
  end;

  // Continuar ajustando o stop conforme o preço avança
  if (HasPosition) then
  begin
    if (High > PrecoEntrada) then
    begin
      NovoStop := Max(StopLoss, High - (TicksStop * MinPriceIncrement));
      SellToCoverStop(NovoStop);  // Trailing stop na compra
    end
    else if (Low < PrecoEntrada) then
    begin
      NovoStop := Min(StopLoss, Low + (TicksStop * MinPriceIncrement));
      BuyToCoverStop(NovoStop);   // Trailing stop na venda
    end;
  end;

  // Plotar as bandas de Bollinger no gráfico
  Plot(bollingerUpper);
  Plot2(bollingerLower);
  Plot3(bollingerMiddle);
  SetPlotColor(1, clRed);
  SetPlotColor(2, clLime);
  SetPlotColor(3, clYellow);
end.
