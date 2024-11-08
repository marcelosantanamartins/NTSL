var
   vVolFin, vPrecoOpen  : float;
   vFlagOpen : boolean;
   vPlot : float;

begin  
   vVolFin := FinancialVol(false);

   if (date <> date[1]) then 
   begin
      vPrecoOpen := 0; 
      vFlagOpen := True;
   end;


   if ((vVolFin > 0) and vFlagOpen) then
   begin
      vPrecoOpen := open;
      vFlagOpen := False;
   end;  

   if (close < vPrecoOpen) then PaintBar(clVermelho)
   else PaintBar(clAzul);

   Plot(vPrecoOpen); 

end;
