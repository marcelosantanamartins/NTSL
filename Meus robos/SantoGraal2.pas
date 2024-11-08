/////////////////////////////////////////////////////////
//                                                     //
//                  Bollinger Breakout                 //
//                                                     //
//                 by: Marcelo Santana                 //
//                                                     //
//     Parâmetros      Period: 20                      //
//                     Deviation: 1.0                  //
//                                                     //
//     tipo(Mode)      Aritmético 0                    //
//                     Exponencial 1                   //
//                     Welles Wilder 2                 //
//                     Ponderada 3                     //
//                                                     //
/////////////////////////////////////////////////////////
// WINFUT 8R

input
  Period(20);
  Deviation(1.0);
  Mode(2);
  MaxStop(30);
  ProfitTarget(20);

var
  EntryPrice : float;
  StopPrice  : float;
  CandleCount : integer;

begin
  if (time >= 1815) então
  begin
    ClosePosition;
  end
  else
  begin
    if (IsSold) então
    begin
      if (Close > Open) and (Close > Media(Period, Close)) então
        BuyToCoverAtMarket;

      if (CandleCount >= 2) então
      begin
        StopPrice := EntryPrice - (4 * MinPriceIncrement);
        BuyToCoverStop(StopPrice, StopPrice + MinPriceIncrement);
      end;

      if (Close <= EntryPrice - (50 * MinPriceIncrement)) então
      begin
        StopPrice := EntryPrice - (3 * MinPriceIncrement);
        BuyToCoverStop(StopPrice, StopPrice + MinPriceIncrement);
      end
      else if (Close <= EntryPrice - (10 * MinPriceIncrement)) então
      begin
        StopPrice := EntryPrice - (3 * MinPriceIncrement);
        if (EntryPrice - StopPrice > MaxStop * 5) então
          StopPrice := EntryPrice - (MaxStop * 5);
        BuyToCoverStop(StopPrice, StopPrice + MinPriceIncrement);
      end
      else if (Close <= EntryPrice - (ProfitTarget * MinPriceIncrement)) então
      begin
        BuyToCoverAtMarket;
      end
      else if (StopPrice <> 0) então
      begin
        StopPrice := High[1] + MinPriceIncrement;
        if (EntryPrice - StopPrice > MaxStop * 5) então
          StopPrice := EntryPrice - (MaxStop * 5);
        BuyToCoverStop(StopPrice, StopPrice + MinPriceIncrement);
      end;

      CandleCount := CandleCount + 1;
      if (CandleCount >= 2) and (Close >= High[2]) então
        ClosePosition;

      PaintBar(clRed);
    end
    else if (IsBought) então
    begin
      if (Close < Open) and (Close < Media(Period, Close)) então
        SellToCoverAtMarket;

      if (CandleCount >= 2) então
      begin
        StopPrice := EntryPrice + (4 * MinPriceIncrement);
        SellToCoverStop(StopPrice, StopPrice - MinPriceIncrement);
      end;

      if (Close >= EntryPrice + (50 * MinPriceIncrement)) então
      begin
        StopPrice := EntryPrice + (3 * MinPriceIncrement);
        SellToCoverStop(StopPrice, StopPrice - MinPriceIncrement);
      end
      else if (Close >= EntryPrice + (10 * MinPriceIncrement)) então
      begin
        StopPrice := EntryPrice + (3 * MinPriceIncrement);
        if (StopPrice - EntryPrice > MaxStop * 5) então
          StopPrice := EntryPrice + (MaxStop * 5);
        SellToCoverStop(StopPrice, StopPrice - MinPriceIncrement);
      end
      else if (Close >= EntryPrice + (ProfitTarget * MinPriceIncrement)) então
      begin
        SellToCoverAtMarket;
      end
      else if (StopPrice <> 0) então
      begin
        StopPrice := Low[1] - MinPriceIncrement;
        if (StopPrice - EntryPrice > MaxStop * 5) então
          StopPrice := EntryPrice + (MaxStop * 5);
        SellToCoverStop(StopPrice, StopPrice - MinPriceIncrement);
      end;

      CandleCount := CandleCount + 1;
      if (CandleCount >= 2) and (Close <= Low[2]) então
        ClosePosition;

      PaintBar(clGreen);
    end
    else if Close > BollingerBands(Deviation, Period, Mode)|0| então
    begin
      BuyAtMarket;
      EntryPrice := Close;
      StopPrice := 0;
      CandleCount := 0;
    end
    else if Close < BollingerBands(Deviation, Period, Mode)|1| então
    begin
      SellShortAtMarket;
      EntryPrice := Close;
      StopPrice := 0;
      CandleCount := 0;
    end;
  end;
end;
