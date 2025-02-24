// WINFUT 7 Kagi

input
  MinTicksToMoveStop(7);
  StopLossTicks(3);

var
  entryPrice : float;
  lastColor : integer;
  painted : boolean;

function Buy : float;
begin
  BuyAtMarket;
  Result := Close;
end;

function Sell : float;
begin
  SellShortAtMarket;
  Result := Close;
end;

procedure ClosePosition;
begin
  if isBought then
    SellToCoverAtMarket
  else if isSold then
    BuyToCoverAtMarket;
end;

begin
  // Regras para pintar os candles e entrar nas operações
  if (Close > Open[1]) and (Low < Close[1]) then
  begin
    PaintBar(clYellow);
    if (not isBought) and (not isSold) then
    begin
      entryPrice := Buy;
      lastColor := clYellow;
      painted := true;
    end;
  end
  else if (Open < Close[1]) and (High > Open[1]) then
  begin
    PaintBar(clPurple);
    if (not isBought) and (not isSold) then
    begin
      entryPrice := Sell;
      lastColor := clPurple;
      painted := true;
    end;
  end;

  // Regras para fechar a posição
  if painted then
  begin
    if (isBought and (lastColor = clYellow) and (Open < Close) and (High > Open)) then
    begin
      PaintBar(clPurple);
      lastColor := clPurple;
      ClosePosition;
      painted := false;
    end
    else if (isSold and (lastColor = clPurple) and (Close > Open) and (Low < Close)) then
    begin
      PaintBar(clYellow);
      lastColor := clYellow;
      ClosePosition;
      painted := false;
    end;
  end;

  // Verificar e ajustar o stop loss
  if isBought then
  begin
    if (Close - entryPrice) >= MinTicksToMoveStop * MinPriceIncrement then
    begin
      SellToCoverLimit(Close - StopLossTicks * MinPriceIncrement);
    end;
  end
  else if isSold then
  begin
    if (entryPrice - Close) >= MinTicksToMoveStop * MinPriceIncrement then
    begin
      BuyToCoverLimit(Close + StopLossTicks * MinPriceIncrement);
    end;
  end;
end;
