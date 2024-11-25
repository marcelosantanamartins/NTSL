input
  Media(10);

var
  _media : float;
  entryPrice : float;
  stopLevel : float; 

function isVolumeHigh(vol : float; med : float) : boolean;
begin
  if (vol > med) then
    Result := true
  else 
    Result := false;
end;

function CandleColor(ActualClose : float; LastClose : float) : integer;
begin
  if (ActualClose > LastClose) then
    Result := clLime
  else if (ActualClose < LastClose) then
    Result := clRed;
end;

procedure Buy;
begin
  BuyAtMarket;
end;

procedure Sell;
begin
  SellShortAtMarket;
end;

function CalculateStopLoss(isBuy : boolean) : float;
var
  i : integer;
  lowestLow, highestHigh : float;
begin
  lowestLow := High; // Inicializa com o valor máximo possível
  highestHigh := Low; // Inicializa com o valor mínimo possível

  for i := 1 to 10 do
  begin
    if Low[i] < lowestLow then
      lowestLow := Low[i];
    if High[i] > highestHigh then
      highestHigh := High[i];
  end;

  if isBuy then
    Result := lowestLow - MinPriceIncrement
  else
    Result := highestHigh + MinPriceIncrement;
end;

procedure PlaceStop(isBuy : boolean; stopPrice : float);
begin
  if isBuy then
    BuyToCoverStop(stopPrice)
  else
    SellToCoverStop(stopPrice);
end;

begin
  if time > 1820 then
    ClosePosition
  else
  begin
    if (Low < Close[1]) then
    begin
      _media := MediaExp(Media, Volume);

      if isVolumeHigh(Volume, _media) then
      begin
        PaintBar(CandleColor(Close, Close[1]));

        if (CandleColor(Close, Close[1]) = clLime) then
        begin
          if (isSold) then
            ReversePosition
          else if not isBought then
          begin
            Buy;
            entryPrice := Close; // Definir entryPrice no bloco principal
            stopLevel := CalculateStopLoss(true); // Calcular stop loss inicial
            PlaceStop(true, stopLevel);
          end;
        end
        else if (CandleColor(Close, Close[1]) = clRed) then
        begin
          if (isBought) then
            ReversePosition
          else if not isSold then
          begin
            Sell;
            entryPrice := Close; // Definir entryPrice no bloco principal
            stopLevel := CalculateStopLoss(false); // Calcular stop loss inicial
            PlaceStop(false, stopLevel);
          end;
        end;
      end;
    end;

    // Ajuste para colocar stop em caso de fechamento negativo mas não vermelho
    if isBought and (Close < Open) and (CandleColor(Close, Close[1]) <> clRed) then
    begin
      stopLevel := max(Low - MinPriceIncrement, entryPrice - 40 * MinPriceIncrement);
      PlaceStop(true, stopLevel);
    end
    else if isSold and (Close > Open) and (CandleColor(Close, Close[1]) <> clLime) then
    begin
      stopLevel := min(High + MinPriceIncrement, entryPrice + 40 * MinPriceIncrement);
      PlaceStop(false, stopLevel);
    end;

    // Ajuste para colocar stop loss a favor da operação após avanço de 10 MinPriceIncrement
    if isBought and ((Close - entryPrice) >= 10 * MinPriceIncrement) then
    begin
      stopLevel := max(Close - 3 * MinPriceIncrement, entryPrice - 40 * MinPriceIncrement);
      PlaceStop(true, stopLevel);
    end
    else if isSold and ((entryPrice - Close) >= 10 * MinPriceIncrement) then
    begin
      stopLevel := min(Close + 3 * MinPriceIncrement, entryPrice + 40 * MinPriceIncrement);
      PlaceStop(false, stopLevel);
    end;

  end;
end;
