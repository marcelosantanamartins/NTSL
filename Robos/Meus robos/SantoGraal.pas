var
  compra,venda                    : boolean;
  fechma,me,tb31,tb32, tb21, tb22 : float;

begin
  me     := (maxima + minima + Close + open / 4);
  fechma := (close + close[2] + open[1]);
  tb21   := TopBottomDetector(2);
  tb22   := TopBottomDetector(2)[2];
  tb31   := TopBottomDetector(3);
  tb32   := TopBottomDetector(3)[2];

  ////////////////////////////////////////////////////condição de venda
  venda := (tb31 > tb32) and (tb21 > tb22) and (me > me[3]) and ((ifr(9) > ifr(9)[1])) and (ifr(9) > 40);
  /////////////////////////////////////////////////////////condição de compra
  compra := (tb31 < tb32) and (tb21 < tb22) and (me < me[3]) and ((ifr(9) < ifr(9)[1])) and (ifr(9) < 50);
  
  if (time > 905) and (time < 1735) and (buyposition = 0) and (sellposition = 0) then
    begin
      if compra then
        BuyStop(close,close);
      if venda then
        SellShortstop(CLOSE,CLOSE);
      if venda then
        paintbar(clred);
     if compra then
        paintbar(clverde);
    end;


  if (sellposition = 1) then
    PaintBar(clred);
  if (buyposition = 1) then
    PaintBar(clverde);
  if (IsBought) then
    if (ifr(9) < 23) ou (tb31 > tb32) and (tb21 > tb22) then
      begin
        SellShortAtMarket;
        /////// BuyStop(close,close);
      end;
  if (IsSold) then
    if (ifr(9) > 69) ou (tb31 > tb32) and (tb21 > tb22) then
      begin
        BuyAtMarket;
        /////// SellShortstop(high,high);
      end;
  se time > 1736 then
    closeposition;
end;