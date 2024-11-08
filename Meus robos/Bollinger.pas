input
  PeriodoBollinger(20);
  TipoMediaBollinger(0);
  DesvioPadrao(2.0);
  TicksStop(4);
  TicksLucro(5);  

var
  bollingerUpper, bollingerLower, bollingerMiddle: Float;
  PrecoEntrada, StopLoss, TrailingStop: Float;
  ValidaOperacao, status: Boolean;

/////////////////////////////////////////////////
// Função para calcular and atualizar o stop loss
/////////////////////////////////////////////////
function ExecuteStopLoss(
  Entry: Float;
  MaxStopLoss: Float;
  MBol: Float;
  isBuyOperation: Boolean
): Float;
var
  _ticksLucro: Integer;
  _stopLoss: Float;
begin
  _ticksLucro := 5;  // Definindo 5 ticks para lucro
  _stopLoss := MaxStopLoss;

  if isBuyOperation then
  begin
    // Se o preço avançou menos de 5 ticks, mantém o stop loss inicial
    if Price < (Entry + (_ticksLucro * MinPriceIncrement)) then
      _stopLoss := Max(_stopLoss, Entry - MinPriceIncrement);

    // Se o preço ultrapassou a média das Bandas, ajusta o stop para 4 ticks abaixo do preço atual
    if Price >= MBol then
      _stopLoss := Max(_stopLoss, Price - (4 * MinPriceIncrement));
  end
  else
  begin
    // Operações de venda: ajuste o stop conforme os critérios análogos
    if Price > (Entry - (_ticksLucro * MinPriceIncrement)) then
      _stopLoss := Min(_stopLoss, Entry + MinPriceIncrement);

    if Price <= MBol then
      _stopLoss := Min(_stopLoss, Price + (4 * MinPriceIncrement));
  end;

  // Retorna o novo stop loss, garantindo que ele não retroceda
  Result := _stopLoss;
end;

inicio
  bollingerUpper := BollingerBands(DesvioPadrao, PeriodoBollinger, TipoMediaBollinger)|0|;
  bollingerLower := BollingerBands(DesvioPadrao, PeriodoBollinger, TipoMediaBollinger)|1|;
  bollingerMiddle := (bollingerUpper + bollingerLower) / 2;

  // Condição para habilitar a operação após o preço furar a banda
  if (Close[1] < bollingerLower) or (Close[1] > bollingerUpper) then
    ValidaOperacao := true;

  // Impedir entrada se o preço já cruzou a linha do meio das Bandas
  if ValidaOperacao and (Close >= bollingerMiddle) then
    ValidaOperacao := false;

  // Entrada na operação de compra: preço furou a banda inferior and voltou para dentro
  if ValidaOperacao and (Close > bollingerLower) and (Close < bollingerMiddle) and (Close >= Open) then
  begin
    ValidaOperacao := false; 
    if not HasPosition then
    begin
      PaintBar(clLime); 
      BuyLimit(Close);
      PrecoEntrada := Close;
      StopLoss := Low - (TicksStop * MinPriceIncrement);
    end;
  end;

  // Ajuste do stop loss para 1 tick positivo após 5 ticks de lucro and trailing stop
  if HasPosition then
  begin
    StopLoss := ExecuteStopLoss(PrecoEntrada, StopLoss, bollingerMiddle, IsBought);
    if IsBought then
      SellShortLimit(StopLoss) 
    else
      BuyLimit(StopLoss);
  end;

  // Plotagem das Bandas de Bollinger
  Plot(bollingerUpper);
  Plot2(bollingerLower);
  Plot3(bollingerMiddle);
  SetPlotColor(1, clRed);
  SetPlotColor(2, clLime);
  SetPlotColor(3, clYellow);
end.
