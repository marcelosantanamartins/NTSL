input
  media_rapida(16);
  media_lenta(48);
  sinal(12);
var
  sFast,sSlow,sTrigger,sMACD : Float;
  a,b,c,d                    : Float;
begin
  sFast := MediaExp(media_rapida,Close);
  sSlow := MediaExp(media_lenta,Close);
  sTrigger := MediaExp(sinal,sFast - sSlow);
  sMACD := MACD(media_lenta,media_rapida,sinal);
  a := sTrigger;
  b := sFast - sSlow;
  c := b - a;
  begin
    if (c > 0.01) e (c > c[1]) then
      setplotcolor(1,clverde)
    senão if (c > 0.01) e (c < c[1]) then
      setplotcolor(1,clverdeclaro);
    if (c < - 0.01) e (c < c[1]) then
      setplotcolor(1,clvermelho)
    senão if (c < - 0.01) e (c > c[1]) then
      setplotcolor(1,rgb(255,167,167));

    if (c > 0.01) e (c > c[1]) then
      paintbar(clverde)
    senão if (c > 0.01) e (c < c[1]) then
      paintbar(clverdeclaro);
    if (c < - 0.01) e (c < c[1]) then
      paintbar(clvermelho)
    senão if (c < - 0.01) e (c > c[1]) then
      paintbar(rgb(255,167,167));
    plot(c);
  end;
end;
end;