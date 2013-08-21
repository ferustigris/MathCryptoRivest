//алгоритм проверки является ли число простым
unit simple;
interface
uses Windows, SysUtils, bnumber;

Function  Simple_number2(n:longint; var i:longint):boolean;
Function  Simple_number(n:TBNumber; var i:TBNumber):boolean;

implementation

Function  Simple_number2(n:longint; var i:longint):boolean;
Var simp : boolean   { simp=false, если встретился делитель числа n} ;
begin
  i:=2;
  if n=2 then Simple_number2:=true
  else if n mod 2 = 0 then Simple_number2:=false
  else
    begin
      simp:=true;
      i:=3;
      while (i<=(n div 3)) and  simp do
        if n mod i =0 then simp:=false else i:=i+2;
      if simp then Simple_number2:=true else Simple_number2:=false
    end
end;

Function  Simple_number(n:TBNumber; var i:TBNumber):boolean;
Var
 simp : boolean   { simp=false, если встретился делитель числа n} ;
 h, h_mod, h_div : TBNumber;
 j : integer;
begin
  h := TBNumber.create('2');
  i.sum(h);
  if n.cmp(TBNumber.create('2'))=0 then Simple_number:=true
  else
    begin
      n.sub(h, h_div, h_mod);
      if h_mod.cmp(TBNumber.create('0'))=0 then Simple_number:=false
      else
        begin
          simp:=true;
          i.sum(TBNumber.create('1'));
          n.sub(i, h_div, h_mod);
          while (i.cmp(h_div)<=0) and  simp do
            begin
              n.sub(i, h_div, h_mod);
              if h_mod.cmp(TBNumber.create('0'))=0 then simp:=false else i.sum(h);
            end;
          if simp then Simple_number:=true else Simple_number:=false
        end;
    end;
end;

end.
