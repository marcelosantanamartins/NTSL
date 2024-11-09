input
  Media(10);
var
  _media : float;

/////////////////////////////////////////////////
// Check if Volume is Higher than MediaExp(10) //
/////////////////////////////////////////////////
function isVolumeHigh(vol : float;
med : float) : boolean;
begin
  if (vol > med) then
    Result := true
  else 
    Result := false;
end;

//////////////////////////
// Get the candle color //
//////////////////////////
function CandleColor(ActualClose : float;
LastClose : float) : integer;
begin
  if (Close > Close[1]) then
    Result := clLime;
  if (Close < Close[1]) then
    Result := clRed;
end;


begin
  if (Low < Close[1]) then
    begin
      _media := MediaExp(Media,Volume);

      if isVolumeHigh(Volume,_media) then
        begin
          PaintBar(CandleColor(Close, Close[1]));
        end;
    end;
end;