unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit5: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Edit6: TEdit;
    Button4: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Edit7: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Edit8: TEdit;
    Label15: TLabel;
    Edit9: TEdit;
    Button6: TButton;
    Label16: TLabel;
    Button5: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses bnumber,simple,unod,power;
{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
begin
  if(not test()) then ShowMessage('Ошибка при операциях с БЧ!');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 n, m, i : TBNumber;
 temp : String;
begin
  n:=TBNumber.create(Edit1.Text);
  m:=TBNumber.create(Edit2.Text);
  i:=TBNumber.create('0');
  if Simple_number(n,i) then temp:='Число '+n.print+' простое. '
  else temp:='Число '+n.print+' составное, делится на ' +i.print()+'. ';
  i.destroy;
  i:=TBNumber.create('0');
  if Simple_number(m,i) then temp:=temp+'Число '+m.print+' простое.'
  else temp:=temp+'Число '+m.print+' составное, делится на ' +i.print()+'.';
  ShowMessage(temp);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 p, q : TBNumber;
 temp : String;
begin
  //вычисляем произведение p на q
  p:=TBNumber.create(Edit1.Text);
  q:=TBNumber.create(Edit2.Text);
  p.product(q);
  Edit3.Text:=p.print;
  p.destroy;
  q.destroy;
  //вычисляем фунцию Эйлера
  p:=TBNumber.create(Edit1.Text);
  q:=TBNumber.create(Edit2.Text);
  p.sum(TBNumber.create('-1'));
  q.sum(TBNumber.create('-1'));
  p.product(q);
  Edit4.Text:=p.print;
  p.destroy;
  q.destroy;
  button3.Enabled:=true;
  button4.Enabled:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  f, e, n : TBNumber;
  temp : String;
begin
  //e и функция Эйлера должны быть взаимнопросты
  f:=TBNumber.create(Edit4.Text);
  e:=TBNumber.create(Edit5.Text);
  n:=nod(f, e);
  if (n.cmp(TBNumber.create('1'))=0) then
    temp:='Взаимнопросты'
  else
    temp:='НОД e и функции Эйлера равен ' + n.print();
  ShowMessage(temp);
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  f, a, e, e_div, e_mod: TBNumber;
begin
  //необходимо найти d такое, что de=1(mod f(n))
  f:=TBNumber.create(edit4.Text);
  e:=TBNumber.create(edit5.Text);
  a:=f;
  a.sum(f);
  a.sum(TBNumber.create('1'));
  a.sub(e, e_div, e_mod);
  while (e_mod.cmp(TBNumber.create('0'))<>0) do
  begin
    a.sum(f);
    a.sub(e, e_div, e_mod);
  end;
  edit6.Text:=e_div.print;
  button6.Enabled:=true;
end;

procedure TForm1.Button6Click(Sender: TObject);
var
 m, e, n : TBNumber;
 temp : String;
begin
  m:=TBNumber.create(edit7.Text);
  e:=TBNumber.create(edit5.Text);
  n:=TBNumber.create(edit3.Text);
  edit8.Text:=Power_number(m,e,n).print;
  m.destroy;
  e.destroy;
  n.destroy;
  button5.Enabled:=true;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
 c, d, n : TBNumber;
 temp : String;
begin
  c:=TBNumber.create(edit8.Text);
  d:=TBNumber.create(edit6.Text);
  n:=TBNumber.create(edit3.Text);
  edit9.Text:=Power_number(c,d,n).print;
  c.destroy;
  d.destroy;
  n.destroy;
end;

end.
