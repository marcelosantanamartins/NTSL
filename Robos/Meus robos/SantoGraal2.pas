/////////////////////////////////////////////////////////
//                                                     //
//                  Bollinger Breakout                 //
//                                                     //
//                 by: Rafael Peres                    //
//                                                     //
//     Parâmetros      Período: 20                     //
//                     Desvio: 1.0                     //
//                                                     //
//     tipo(modo)      Aritmético 0                    //
//                     Exponencial 1                   //
//                     Welles Wilder 2                 //
//                     Ponderada 3                     //
//                                                     //
/////////////////////////////////////////////////////////
// WINFUT 8K / 5M / 10R

input
  Periodo(20);
  Desvio(1.0);
  Modo(2);
  MaxStop(30);
  AlvoLucro(20);
  StopStart(3);
  StopMove(8);

var
  EntryPrice: float;
  StopPrice: float;
  AlvoPreço: float;
  CandlesAvancados: Integer;
  CandleContra1: float;
  CandleContra2: float;

begin
  if (time >= 1810) then
  begin
    ClosePosition;
  end
  else
  begin  
    if (IsSold) then
    begin
      if (Close <= EntryPrice - (8 * MinPriceIncrement)) then
      begin
        StopPrice := EntryPrice - (StopStart * MinPriceIncrement);
        BuyToCoverStop(StopPrice, StopPrice + MinPriceIncrement);
      end;

      if (Close <= EntryPrice - (5 * MinPriceIncrement)) then
      begin
        StopPrice := EntryPrice - (3 * MinPriceIncrement);
        if (EntryPrice - StopPrice > MaxStop * 5) then
          StopPrice := EntryPrice - (MaxStop * 5);
        BuyToCoverStop(StopPrice, StopPrice + MinPriceIncrement);
      end
      else if (Close <= EntryPrice - (AlvoLucro * MinPriceIncrement)) then
      begin
        BuyToCoverAtMarket;
      end
      else
      begin
        if (StopPrice <> 0) then
        begin
          StopPrice := High[1] + MinPriceIncrement;
          if (EntryPrice - StopPrice > MaxStop * 5) then
            StopPrice := EntryPrice - (MaxStop * 5);
          BuyToCoverStop(StopPrice, StopPrice + MinPriceIncrement);
        end;
      end;

      if (CandlesAvancados >= 7) then
      begin
        if (Close > CandleContra2) then
        begin
          BuyToCoverAtMarket;
        end;
      end;

    end
    else if (IsBought) then
    begin
      if (Close >= EntryPrice + (8 * MinPriceIncrement)) then
      begin
        StopPrice := EntryPrice + (StopStart * MinPriceIncrement);
        SellToCoverStop(StopPrice, StopPrice - MinPriceIncrement);
      end;

      if (Close >= EntryPrice + (5 * MinPriceIncrement)) then
      begin
        StopPrice := EntryPrice + (3 * MinPriceIncrement);
        if (StopPrice - EntryPrice > MaxStop * 5) then
          StopPrice := EntryPrice + (MaxStop * 5);
        SellToCoverStop(StopPrice, StopPrice - MinPriceIncrement);
      end
      else if (Close >= EntryPrice + (AlvoLucro * MinPriceIncrement)) then
      begin
        SellToCoverAtMarket;
      end
      else
      begin
        if (StopPrice <> 0) then
        begin
          StopPrice := Low[1] - MinPriceIncrement;
          if (StopPrice - EntryPrice > MaxStop * 5) then
            StopPrice := EntryPrice + (MaxStop * 5);
          SellToCoverStop(StopPrice, StopPrice - MinPriceIncrement);
        end;
      end;

      if (CandlesAvancados >= 7) then
      begin
        if (Close < CandleContra2) then
        begin
          SellToCoverAtMarket;
        end;
      end;
    end
    else if (Fechamento > BollingerBands(Desvio, Periodo, Modo)|0|) then
    begin
      BuyAtMarket;
      EntryPrice := BuyPrice;
      StopPrice := 0;
      CandlesAvancados := 0; 
    end
    else if (Fechamento < BollingerBands(Desvio, Periodo, Modo)|1|) then
    begin
      SellShortAtMarket;
      EntryPrice := SellPrice;
      StopPrice := 0;
      CandlesAvancados := 0;
    end;
  end;

  if (IsBought or IsSold) then
  begin
    CandlesAvancados := CandlesAvancados + 1;
  end;

  if (CandlesAvancados >= 7) then
  begin
    CandleContra1 := Close[2]; 
    CandleContra2 := Close[3]; 
  end;

  Plot(BollingerBands(Desvio, Periodo, Modo)|1|);
end;
