{
  Testar no winfut 17R e por media de 9 para comprar acima e vender abaixo
}

var
  xi,t : float;
begin
t:=0;
  if (Close > media(9,close)) and (BuyPosition = 0) then
    begin
      t := 1.00;
      paintBar(clazul);
      BuyStop(high,high);
    end;

    if(t=1)then
    begin
  xi := CalcTime(LastCalcTime,4);
    end;

  plot(xi);
  plot3(t+xi);
  if (LastCalcTime = xi) then
    begin
      PaintBar(clAmarelo);
    end;
end;

