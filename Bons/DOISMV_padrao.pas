{
WDOFUT 8R
}
Inicio
  if time < 1800 then
    begin
      if (IsSold) then
        Inicio
          if (Close > MediaExp(20,high)) then
            begin
              BuyToCoverAtMarket;
            end;
        Fim
      else if (IsBought) then
        Inicio
          if (Close < MediaExp(20,low)) then
            SellToCoverAtMarket;
        Fim
      else 
        Inicio
          if (Close > MediaExp(20,high)) then
            BuyAtMarket
          else if (Close < MediaExp(20,low)) then
            SellShortAtMarket;
        end;
    end
  else 
    begin
      ClosePosition;
    end;
end;








