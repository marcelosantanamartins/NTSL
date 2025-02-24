{
  Developed by Marcelo Santana Martins
}

var
  meioCandle: Float;

begin
  if not LastBarOnChart then
  begin
    meioCandle := (High + Low) / 2;

    if (Close > Open) and (Close <= High[1]) then
      PlotText("  🔸 ", clWhite, 0, 7)    // Gatilho em alta
    else if (Close < Open) and (Close >= Low[1]) then
        PlotText("  🔸 ", clWhite, 0, 7);   // Gatilho em baixa
    end;
  end;
end;






