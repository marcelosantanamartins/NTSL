Parametro
  Periodos(3);
Var
  tf,x,y : Real;
Inicio
  //detecta o topo/fundo atual e guarda em memoria
  tf := TopBottomDetector(Periodos);
  if (tf <> 0) then
    inicio
      if (x = 0) then
        x := tf
      Senao 
        y := tf;
    end;
  if (x <> 0) e (y <> 0) then
    inicio
      if (y > x) then
        paintbar(clvermelho)
      else if (y < x) then
        paintbar(clLime);
      x := y;
      y := 0;
    end;
end;