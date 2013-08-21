unit bnumber;

interface
type
//class numbers
TString = record
  int: array of byte;
  //float: array of byte;
  sign: boolean;//not used
  intSize : Integer;
  //floatSize : Integer;
end;
//class number ops
TBNumber = class
public
  constructor create(num : String);overload;
  constructor create(num : TBNumber);overload;
  destructor destroy();override;
  function print() : String;
  procedure fromString(str : String);
  //function getValue() : TString;
//ops
  procedure sum(operator : TBNumber);
  procedure sub(operator : TBNumber; var int, remainder : TBNumber);
  function cmp(operator : TBNumber) : Integer;
  procedure product(operator : TBNumber);
private
  number : TString;
  procedure setNeedSize(newISize, newFSize : Integer);
end;
function test() : boolean;
implementation

uses SysUtils;
function test() : boolean;
var
 n,
 m, m_mod, m_div : TBNumber;
 str1, str2 : String;
 a,b : integer;
begin
  result := false;
  for a := 1 to 9 do
    for b := 999 to 1010 do
    begin
      n := TBNumber.create(IntToStr(a));
      m := TBNumber.create(IntToStr(b));
      n.sub(m, m_div, m_mod);
      str1 := IntToStr(a div b);
      str2 := m_div.print;
      if(str1 <> str2)then
        exit;
      str1 := IntToStr(a mod b);
      str2 := m_mod.print;
      if(str1 <> str2)then
        exit;
      n.sum(m);
      str1 := IntToStr(a + b);
      str2 := n.print;
      if(str1 <> str2)then
        exit;
      n.destroy;
      m.destroy;
      n := TBNumber.create(IntToStr(a));
      m := TBNumber.create(IntToStr(b));
      n.product(m);
      str1 := IntToStr(a * b);
      str2 := n.print;
      if(str1 <> str2)then
        exit;
      n.destroy;
      m.destroy;
    end;
  result := true;
end;
//construct
constructor TBNumber.create(num : TBNumber);
var
  i:integer;
begin
  //number.floatSize := 0;
  number.intSize := num.number.intSize;
  SetLength(number.int,number.intSize);
  for i := 0 to num.number.intSize-1 do
    number.int[i] := num.number.int[i];
  number.sign := num.number.sign;
end;
//construct
constructor TBNumber.create(num : String);
begin
  //number.floatSize := 0;
  number.intSize := 0;
  fromString(num);
end;
//destruct
destructor TBNumber.destroy();
begin
  SetLength(number.int, 0);
  //SetLength(number.float, 0);
end;
//print out
function TBNumber.print() : String;
var
  i : Integer;
begin
  {for i := 0 to number.floatSize-1 do
  begin
    result := IntToStr(number.float[i]) + result;
  end;
  result := ',' + result;}
  result := '';
  for i := 0 to number.intSize-1 do
  begin
    result := IntToStr(number.int[i]) + result;
  end;
  if(not number.sign)then
    result := '-' + result;
end;
//get by string
procedure TBNumber.fromString(str : String);
const
  INTEGER_DIGITS = 0;
  FLOAT_DIGITS = 1;
var
  curDigits,
  strlen,
  floatnum,
  i :Integer;
  digits: set of char;
begin
  number.sign := true;
  digits := ['0','1'..'9'];
  repeat
    strlen := Length(str);
    if(strlen = 0)then
      str := '0'
    else
    {if((StrScan(PChar(str), '.') = nil)and(StrScan(PChar(str), ',') = nil))then
      str := str + ',0';}
    if(str[1] = '-')then
    begin
      str := strPos(PChar(str), '-')+1;
      number.sign := false;
      strlen := 0;
    end
    else
    if(str[1] = '+')then
    begin
      str := strPos(PChar(str), '+')+1;
      strlen := 0;
    end;
  until(strlen > 0);
  //curDigits := FLOAT_DIGITS;
  curDigits := INTEGER_DIGITS;
  floatnum := 0;
  if(strlen > 0)then
  begin
    for i:=0 to strlen - 1 do
    begin
      if(str[strlen - i] in digits)then
      begin
        case(curDigits)of
          INTEGER_DIGITS:
          begin
            setNeedSize(i - floatnum + 1, 0);
            number.Int[i - floatnum] := StrToInt(str[strlen - i]);
          end;
          {FLOAT_DIGITS:
          begin
            setNeedSize(0, i + 1);
            floatnum := i + 1;
            number.float[i] := StrToInt(str[strlen - i]);
          end;}
        end;
      end
      {else if((str[strlen - i] = ',')or(str[strlen - i] = '.')) then
      begin
        curDigits := INTEGER_DIGITS;
        floatnum := i + 1;
        continue;
      end}
      else raise Exception.Create('No valid number!');
    end
  end;
end;
//get by string
procedure TBNumber.setNeedSize(newISize, newFSize : Integer);
begin
  if(number.intSize <> newISize)and(newISize <> 0)then
  begin
    number.intSize := newISize;
    SetLength(number.int, newISize);
  end;
  {if(number.floatSize <> newFSize)and(newFSize <> 0)then
  begin
    number.floatSize := newFSize;
    SetLength(number.float, newFSize);
  end;}
end;
//for ops
{function TBNumber.getValue() : TString;
begin
  result := number;
end;}
//sum
procedure TBNumber.sum(operator : TBNumber);
var
  sum : Array of byte;
  size,
  tmp, val,
  i,
  max,
  min : Integer;
  op1, op2 : TString;
  minus: boolean;
begin
  minus := false;
  if(number.sign <> operator.number.sign)then
  begin
    i := cmp(operator);
    if(i = -1)then
      number.sign := operator.number.sign
    else
    if(i = 0)then
    begin
      fromString('');
      exit;
    end;
    minus := true;
  end;
if(minus)then
begin
  tmp := 0;
{  if(operator.getValue().floatSize > number.floatSize)then
  begin
    max := operator.getValue().floatSize;
    min := number.floatSize;
    op2 := number;
    op1 := operator.getValue();
  end
  else
  begin
    op2 := operator.getValue();
    op1 := number;
    max := number.floatSize;
    min := operator.getValue().floatSize;
  end;
  size := max;
  SetLength(sum, size);
  for i := 0 to size-1 do
  begin
    sum[i] := op1.float[i];
  end;
  i := 0;
  while(i < min)do
  begin
    tmp := op1.float[max - min + i] + op2.float[i] + tmp;
    sum[max - min + i] := tmp mod 10;
    tmp := tmp div 10;
    i := i + 1;
  end;
  setNeedSize(0, size);
  for i := 0 to size-1 do
  begin
    number.float[i] := sum[i];
  end;
  SetLength(sum, 0);
}

  size := 0;
  SetLength(sum, size);
  if(cmp(operator) = -1)then
  begin
    max := operator.number.intSize;
    min := number.intSize;
    op2 := number;
    op1 := operator.number;
  end
  else
  begin
    op2 := operator.number;
    op1 := number;
    max := number.intSize;
    min := operator.number.intSize;
  end;
  size := max;
  SetLength(sum, size);
  i := 0;
  while(i < min)do
  begin
    {while(op1.int[i] < abs(tmp))do
    begin
      op1.int[i] := op1.int[i] + 1;
      tmp := tmp * 10;
    end;}
    tmp := op1.int[i] - op2.int[i] + tmp;
    if(tmp < 0)then
    begin
        val := tmp mod 10;
        while(val < 0)do
          val := val + 10;
        sum[i] := val;
    end
    else
      sum[i] := tmp mod 10;
    if(tmp < 0)then
      tmp := -1
    else
      tmp := tmp div 10;
    i := i + 1;
  end;
  while((tmp <> 0)or(max > i))do
  begin
    if(size <= i)then
    begin
      size := i + 1;
      SetLength(sum, size);
    end;
    if(max > i)then
      tmp := op1.int[i] + tmp;
    if(tmp < 0)then
    begin
        val := tmp mod 10;
        while(val < 0)do
          val := val + 10;
        sum[i] := val;
    end
    else
      sum[i] := tmp mod 10;
    if(tmp < 0)and(tmp div 10 <> 0)then
      tmp := -1
    else
      tmp := tmp div 10;
    inc(i);
  end;
  i:= size-1;
  while(sum[i] = 0)do
  begin
    dec(size); 
    dec(i);
  end;
  setNeedSize(size, 0);
  for i := 0 to size-1 do
  begin
    number.int[i] := sum[i];
  end;
  SetLength(sum, 0);
end
else
begin
  tmp := 0;
  {if(operator.number.floatSize > number.floatSize)then
  begin
    max := operator.number.floatSize;
    min := number.floatSize;
    op2 := number;
    op1 := operator.number;
  end
  else
  begin
    op2 := operator.number;
    op1 := number;
    max := number.floatSize;
    min := operator.number.floatSize;
  end;
  size := max;
  SetLength(sum, size);
  for i := 0 to size-1 do
  begin
    sum[i] := op1.float[i];
  end;
  i := 0;
  while(i < min)do
  begin
    tmp := op1.float[max - min + i] + op2.float[i] + tmp;
    sum[max - min + i] := tmp mod 10;
    tmp := tmp div 10;
    i := i + 1;
  end;
  setNeedSize(0, size);
  for i := 0 to size-1 do
  begin
    number.float[i] := sum[i];
  end;
  SetLength(sum, 0);
  }

  size := 0;
  SetLength(sum, size);
  if(operator.number.intSize > number.intSize)then
  begin
    max := operator.number.intSize;
    min := number.intSize;
    op2 := number;
    op1 := operator.number;
  end
  else
  begin
    op2 := operator.number;
    op1 := number;
    max := number.intSize;
    min := operator.number.intSize;
  end;
  size := max;
  SetLength(sum, size);
  i := 0;
  while(i < min)do
  begin
    tmp := op1.int[i] + op2.int[i] + tmp;
    sum[i] := tmp mod 10;
    tmp := tmp div 10;
    i := i + 1;
  end;
  while((tmp <> 0)or(max > i))do
  begin
    if(size <= i)then
    begin
      size := i + 1;
      SetLength(sum, size);
    end;
    if(max > i)then
      tmp := op1.int[i] + tmp;
    sum[i] := tmp mod 10;
    tmp := tmp div 10;
    i := i + 1;
  end;
  setNeedSize(size, 0);
  for i := 0 to size-1 do
  begin
    number.int[i] := sum[i];
  end;
  SetLength(sum, 0);
end;

end;
//competition absolute values
function TBNumber.cmp(operator : TBNumber) : Integer;
var
  i : Integer;
  op1, op2 : TString;
begin
  result := 0;
  op1 := number;
  op2 := operator.number;
  if(op1.intSize = op2.intSize)then
  begin
    i := op1.intSize - 1;
    while(i >= 0)do
    begin
      if(op1.int[i] < op2.int[i])then
      begin
        result := -1;
        exit;
      end
      else
      if(op1.int[i] > op2.int[i])then
      begin
        result := 1;
        exit;
      end;
      i := i - 1;
    end;

    {if(op1.floatSize > op2.floatSize)then
      min := op2.floatSize
    else
      min := op1.floatSize;
    i := 0;
    while(i < min)do
    begin
      if(op1.float[op1.floatSize - i - 1] < op2.float[op2.floatSize - i - 1])then
      begin
        result := -1;
        exit;
      end
      else
      if(op1.float[op1.floatSize - i - 1] > op2.float[op2.floatSize - i - 1])then
      begin
        result := 1;
        exit;
      end;
      i := i + 1;
    end;
    if(op1.floatSize > op2.floatSize)then
      result := 1
    else
      result := -1;
    exit;}
  end
  else
  if(op1.intSize > op2.intSize)then
    result := 1
  else
  if(op1.intSize < op2.intSize)then
    result := -1;
end;
//subvision
procedure TBNumber.sub(operator : TBNumber; var int, remainder : TBNumber);
var
  m : TBNumber;
begin
  //if(int <> nil)then int.destroy;
  int := TBNumber.create('0');
  //if(remainder <> nil)then remainder.destroy;
  if(cmp(operator) = 0)then
  begin
    int.fromString('1');
    remainder := TBNumber.create('0');
    exit;
  end
  else
  if(cmp(operator) < 0)then
  begin
    remainder := TBNumber.create(Self);
    exit;
  end;
  m := TBNumber.create('0');
  m.sum(operator);
  while(cmp(m) >= 0)do
  begin
    int.sum(TBNumber.create('1'));
    m.sum(operator);
  end;
  remainder := TBNumber.create(m);
  remainder.number.sign := not number.sign;
  remainder.sum(Self);
  remainder.number.sign := not operator.number.sign;
  remainder.sum(operator);
  remainder.number.sign := true;
  m.destroy;
end;

//product
procedure TBNumber.product(operator : TBNumber);
var
  product_number,product_temp : TBNumber;
  size,
  tmp, val,
  i, j, k : Integer;
  op1, op2 : TString;
begin
  product_number := TBNumber.create('0');
  product_temp := TBNumber.create('0');
  if(number.sign <> operator.number.sign)then
    number.sign := false
  else
    number.sign := true;
  tmp := 0;
  op1 := number;
  op2 := operator.number;
  j := 0;
  while(j < op2.intSize) do
  begin
    k := 0;
    while (k < j) do
    begin
      product_temp.setNeedSize(k+1, 0);
      product_temp.number.int[k] := 0;
      k := k+1;
    end;
    tmp := 0;
    i := 0;
    while (i < op1.intSize) do
    begin
      tmp := op1.int[i] * op2.int[j] + tmp;
      product_temp.setNeedSize(i+j+1, 0);
      product_temp.number.int[i+j] := tmp mod 10;
      tmp := tmp div 10;
      i := i + 1;
    end;
    if (tmp <> 0) then
    begin
      product_temp.setNeedSize(i+j+1, 0);
      product_temp.number.int[i+j] := tmp;
    end;
    product_number.sum(product_temp);
    j := j + 1;
  end;

  setNeedSize(product_number.number.intSize, 0);
  for i := 0 to product_number.number.intSize-1 do
  begin
    number.int[i] := product_number.number.int[i];
  end;
  product_temp.destroy;
  product_number.destroy;
end;

end.
