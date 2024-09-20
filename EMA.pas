var
  _EMA: float;
  _previousMedia: float;
  _currentMedia: integer;

begin
  _mediaDefault := 5;
  _EMA:= MediaExp(_mediaDefault, Close);
  _previousMedia := MediaExp(_mediaDefault, Close[1]);

  if (Time >= 901) and (Time < 1810) then
  begin
    if (_EMA > _previousMedia) and not IsBought then
    begin
      if IsSold then
        BuyToCoverAtMarket; 
      BuyAtMarket;
      PaintBar(clGreen);
    end;

    if (_EMA < _previousMedia) and not IsSold then
    begin
      if IsBought then
        SellShortAtMarket;
      SellShortAtMarket;
      PaintBar(clRed);
    end;
  end;

  Plot(_media);
end;

