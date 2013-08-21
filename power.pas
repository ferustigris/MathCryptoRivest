//алгоритм возведения числа a в степень n по модулю m
unit power;
interface
uses Windows, SysUtils, bnumber;

Function  Power_number2(a,n,m:longint):longint;
Function  Power_number(a,n,m:TBNumber):TBNumber;

implementation

Function  Power_number2(a,n,m:longint):longint;
var
 p, q : longint;
begin
  p:=1;
  q:=a;
  while (n>0) do
  begin
    if ((n mod 2 )=1) then p:=(p*q) mod m;
    q:= q*q;
    q:=q mod m;
    n:=n div 2;
  end;
  Power_number2:=p;
end;

Function  Power_number(a,n,m:TBNumber):TBNumber;
var
  p, q, n_div, n_mod, m_div, m_mod : TBNumber;
begin
  p:=TBNumber.create('1');
  q:=TBNumber.create(a);
  while (n.cmp(TBNumber.create('0'))>0) do
  begin
    n.sub(TBNumber.create('2'), n_div, n_mod);
    if (n_mod.cmp(TBNumber.create('1'))=0) then
    begin
      p.product(q);
      p.sub(m, m_div, m_mod);
      p:=m_mod;
    end;
    q.product(q);
    q.sub(m, m_div, m_mod);
    q:=m_mod;
    n:=n_div;
  end;
  Power_number:=p;
end;

end.


