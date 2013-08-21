//алгоритм Евклида
unit unod;
interface
uses Windows, SysUtils, bnumber;
function nod(x, y: TBNumber) : TBNumber;
implementation

function nod(x, y: TBNumber) : TBNumber;
var
  y_mod, y_div, x_mod, x_div: TBNumber;
begin
  while ((x.cmp(TBNumber.create('0'))<>0) and (y.cmp(TBNumber.create('0'))<>0)) do
  if (x.cmp(y)>0) then
    begin
      x.sub(y, y_div, y_mod);
      x:=y_mod;
    end
  else
    begin
      y.sub(x, x_div, x_mod);
      y:=x_mod;
    end;
  x.sum(y);
  nod:=x;
end;
end.
