{
Developed by Marcelo Santana Martins

Default:
=============================
Exibe_gatilho_colorido(1);
Cor_candle_neutro(16777215);    // Branco
Cor_positiva_clara(15073228);   // Verde claro
Cor_positiva_escura(9822781);   // Verde escuro
Cor_negativa_clara(11777023);   // Vermelho claro
Cor_negativa_escura(4008930);   // Vermelho escuro
Cor_gatilho_alta(15073228);     // Verde claro (gatilho alta)
Cor_gatilho_baixa(11777023);    // Vermelho claro (gatilho baixa)
}

const
  Data_Limite = 20250630;

input
  Exibe_gatilho_colorido(1);
  Cor_candle_neutro(16777215);    // Branco
  Cor_positiva_clara(15073228);   // Verde claro
  Cor_positiva_escura(9822781);   // Verde escuro
  Cor_negativa_clara(11777023);   // Vermelho claro
  Cor_negativa_escura(4008930);   // Vermelho escuro
  Cor_gatilho_alta(15073228);     // Verde claro (gatilho alta)
  Cor_gatilho_baixa(11777023);    // Vermelho claro (gatilho baixa)

var
  meioCandle: Float;

begin
  if CurrentDate <= Data_Limite then  // Só aplica até a data limite
  begin
    meioCandle := (High + Low) / 2;

    if LastBarOnChart then
    begin
      if (Close > Open) then
      begin
        if (Close >= meioCandle) then
          PaintBar(Cor_positiva_escura)  // Não é gatilho
        else if (Exibe_gatilho_colorido = 1) then
          PaintBar(Cor_gatilho_alta)     // Gatilho em alta com cor especial
        else
          PaintBar(Cor_positiva_escura); // Gatilho em alta com cor padrão
      end
      else if (Close < Open) then
      begin
        if (Close < meioCandle) then
          PaintBar(Cor_negativa_escura)  // Não é gatilho
        else if (Exibe_gatilho_colorido = 1) then
          PaintBar(Cor_gatilho_baixa)    // Gatilho em baixa com cor especial
        else
          PaintBar(Cor_negativa_escura); // Gatilho em baixa com cor padrão
      end
      else
      begin
        PaintBar(Cor_candle_neutro);    // Candle neutro
      end;
    end
    else
    begin
      if (Close > Open) then
      begin
        if (Close <= High[1]) and (Exibe_gatilho_colorido = 1) then
          PaintBar(Cor_gatilho_alta)     // Gatilho em alta
        else
          PaintBar(Cor_positiva_escura); // Não é gatilho
      end
      else if (Close < Open) then
      begin
        if (Close >= Low[1]) and (Exibe_gatilho_colorido = 1) then
          PaintBar(Cor_gatilho_baixa)    // Gatilho em baixa
        else
          PaintBar(Cor_negativa_escura); // Não é gatilho
      end
      else
      begin
        PaintBar(Cor_candle_neutro);    // Candle neutro
      end;
    end;
  end;
end;