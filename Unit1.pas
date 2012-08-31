unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, StdCtrls, Forms, Dialogs, StrUtils, jpeg,
  ShellAPI, Buttons, RxGIF, ExtCtrls, ComCtrls;
              
type
  TfrmMain = class(TForm)
    stol: TImage;
    kar: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lbl0: TLabel;
    btnStart: TSpeedButton;
    btnExit: TSpeedButton;
    gamer0: TLabel;
    gamer1: TLabel;
    gamer2: TLabel;
    pause: TTimer;
    idshow: TSpeedButton;
    sprav: TSpeedButton;
    igrok1: TImage;
    igrok2: TImage;
    igrok0: TImage;
    Panel1: TPanel;
    lbank: TLabel;
    bank: TImage;
    lblKon: TLabel;
    status: TStaticText;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    procedure FormCreate(Sender: TObject);
    procedure razdrub();
    procedure btnStartClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure pauseTimer(Sender: TObject);
    procedure idshowClick(Sender: TObject);
    procedure spravClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image3Click(Sender: TObject);

  private
    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure kartaClick(Sender: TObject);
    procedure Games;
    procedure hod1;
    procedure hod2;
    procedure prvibr1;
    procedure prvibr2;
    procedure sort;
    procedure wait;
    procedure saveTable;
    procedure StartClr;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;
cardsn: string; //колода
curIgrok: byte; //сходивший игрок
curIndex: byte; //карта, кот. сходили
gindex: integer; //индекс игрока в таблице
karta: array[0..2,0..11] of TImage;{0..2 - игрок, 0..11 - карты}
filedir: string;
filerub, karti: String;
pole: array[1..9, 1..4] of byte;
vibor: String;
nhod: byte;
vibr, vibr1, vibr2: integer;
kar1, kar2: byte; //кол-во карт игроков
chhod: byte;
ball: integer; //очки игрока
dball: byte; //плата за пропуск
kon: byte; //кон
kol: byte; //счетчик, ожидание
data: array[0..108] of string[5] = //массив рейтингов (из файла variant.dbc)
('00000',     '', '0000',     '',  '000',     '',   '00',     '',
     '0',     '',    '1',   '10',   '11',  '100',  '110',  '111',
  '1000', '1100', '1110', '1111','10000','11000','11100','11110',
 '11111',     '',  '101',     '', '1010',     '', '1101',     '',
  '1011',     '', '1001',     '','10100',     '','11010',     '',
 '10110',     '','10010',     '','11101',     '','11011',     '',
 '10111',     '','11001',     '','10101',     '','10011',     '',
 '10001',     '',   '01',     '',  '011',     '', '0111',     '',
 '01111',     '',  '010',     '', '0100',     '', '0110',     '',
  '0101',     '','01000',     '','01100',     '','01010',     '',
 '01110',     '','01001',     '','01101',     '','01011',     '',
 '00100',     '', '0010',     '',  '001',     '','00110',     '',
  '0011',     '','00111',     '','00101',     '','00010',     '',
  '0001',     '','00011',     '','00001');

implementation

uses Unit2, Unit3;

const
  MenuItem=wm_user+1;//добавление в системное меню

{$R *.dfm}
//=================================================================
function decode(b: byte): string;
var s: string;
begin
//декодирует десятичное число(byte) в двоичное (string)
while (b<>1) and (b<>0) do
  begin
  s:=inttostr(b mod 2)+s;
  b:=b div 2;
  end;
result:=inttostr(b)+s;
end;

//=================================================================
function f1(k: byte): integer;
begin
//вырезает первую цифру из karta[].tag - карта
result:=strtoint(MidStr(inttostr(k), 1, 1));
end;

//=================================================================
function f2(k: byte): integer;
begin
//вырезает вторую цифру из karta[].tag - масть
result:=strtoint(MidStr(inttostr(k), 2, 1));
end;

//=================================================================
function ife(g: byte; k: byte; m: byte): string;
var i: byte;
begin
//возвращаемые значения:
//0 - нет карты на данное место
//1 - есть карта на данное место
result:='0';
for i:=0 to 11 do
  if karta[g,i].Enabled=true then
    if karta[g,i].Tag=k*10+m then result:='1';
end;

//=================================================================
procedure TfrmMain.Games;
var n: byte;
begin

if pause.Enabled=true then exit;

vibr := -1;
vibr1 := -1;
vibr2 := -1;

lbl0.Caption:=inttostr(ball);
lblKon.Caption:=inttostr(kon);

If kar.Tag = 12 Then
  begin
  //все карты выложены выиграл 0 игрок
  btnStart.Enabled:=true;
  kar.Enabled:=false;
  vibr:=12;
  vibr1:=12;
  vibr2:=12;
  status.Color:=clAqua;
  status.Caption:='Вы выиграли! Поздравляем!';
  ball:=ball+kon;
  kon:=0;
  saveTable;
  Exit;
  end;

If kar1 = 12 Then
  begin
  //все карты выложены выиграл 1 игрок
  btnStart.Enabled:=true;
  kar.Enabled:=false;
  vibr:=12;
  vibr1:=12;
  vibr2:=12;
  status.Color:=clAqua;
  status.caption:='Выиграла Sonya.';
  kon:=0;
  saveTable;
  Exit;
  end;

If kar2 = 12 Then
  begin
  //все карты выложены выиграл 2 игрок
  btnStart.Enabled:=true;
  kar.Enabled:=false;
  vibr:=12;
  vibr1:=12;
  vibr2:=12;
  status.Color:=clAqua;
  status.caption:='Выиграла Tanya.';
  kon:=0;
  saveTable;
  Exit;
  end;

lbank.Color:=clGray;
gamer0.Color:=clBlack;
gamer1.Color:=clBlack;
gamer2.Color:=clBlack;
case chhod of
  0: gamer0.Color:=clGreen;
  1: gamer1.Color:=clGreen;
  2: gamer2.Color:=clGreen;
end;

if chhod=0 then
  begin
  vibor := '';
  For n := 0 To 11 do
    begin
    If karta[0,n].Enabled = true Then
      Case f1(karta[0,n].Tag) of
        1..3:
          If pole[f1(karta[0,n].Tag) + 1, f2(karta[0,n].Tag)] <> 0 Then vibor := vibor + RightStr('0' + IntToStr(n), 2);
        4:
          vibor := vibor + RightStr('0' + IntToStr(n), 2);
        5..9:
          If pole[f1(karta[0,n].Tag) - 1, f2(karta[0,n].Tag)] <> 0 Then vibor := vibor + RightStr('0' + IntToStr(n), 2);
      end;
    end;
  If vibor = '' Then
    begin
    //нет карт чтобы сходить
    gamer0.Color:=clRed;
    lbank.Color:=clBlue;
    status.caption:='У Вас нет карт, чтобы ходить.';
    ball:=ball-dball;
    kon:=kon+dball;
    vibr := 12;
    chhod := chhod + 1;
    wait;
    games;
    vibr := -1;
    //wait;
    Exit;
    end;
  status.caption:='Ваш ход.';
  end;

if chhod=1 then
  begin
  status.Caption:='Ходит Sonya.';
  hod1;
  exit;
  end;
if chhod=2 then
  begin
  status.Caption:='Ходит Tanya.';
  hod2;
  exit;
  end;

end;

//=================================================================
procedure TfrmMain.btnExitClick(Sender: TObject);
begin
frmMain.Close;
end;

//=================================================================
procedure TfrmMain.FormCreate(Sender: TObject);
var
f: file of byte;
i, j, c, b, bl: byte;
begin
AppendMenu(GetSystemMenu(Handle, FALSE), MF_SEPARATOR, 0, '');
AppendMenu(GetSystemMenu(Handle, FALSE), MF_STRING, MenuItem,'Автор: Вавилов Александр');
AppendMenu(GetSystemMenu(Handle, FALSE), MF_STRING, MenuItem+1,'e-mail: shurik83@mail.ru');
AppendMenu(GetSystemMenu(Handle, FALSE), MF_STRING, MenuItem+2,'сайт: http://www.shurik83.narod.ru/');

//frmMain.Width:=800;
//frmMain.Height:=600;

filedir:=extractfiledir(application.ExeName);
for i:=0 to 11 do
begin
karta[0,i]:=TImage.Create(self);
karta[0,i].Parent:=frmMain.kar;
  karta[0,i].Width:=65;
karta[0,i].Height:=97;
karta[0,i].Stretch:=true;
karta[0,i].AutoSize:=false;
  karta[0,i].Left:=i*65+7;
  karta[0,i].Top:=10;
karta[0,i].ComponentIndex:=i;
karta[0,i].OnClick:=kartaClick;
  karta[0,i].Cursor:=crHandPoint;
end;

for j:=1 to 2 do
  begin
  for i:=0 to 11 do
    begin
    karta[j,i]:=TImage.Create(self);
    karta[j,i].Parent:=frmMain;
    karta[j,i].Width:=65;
    karta[j,i].Height:=97;
    karta[j,i].Stretch:=true;
    karta[j,i].AutoSize:=false;
    karta[j,i].Visible:=false;
    end;
  end;

dball:=1;

//если файл существует, то
//чтение из файла variant.dbc, расшифровка и запись в массив
if fileexists(filedir+'\variant.dbc') then
  begin
  c:=0;
  assignfile(f,filedir+'\variant.dbc');
  reset(f);
  while not(eof(f)) do
    begin
    read(f,bl);//длина
    read(f,b);//двоичный код
    if b=255 then
      begin
      data[c]:='';
      end
      else
      begin
      data[c]:=decode(b);
      data[c]:=rightstr('0000'+data[c],bl);
      end;
    inc(c);
    end;
  end;

razdrub();
end;

//=================================================================
procedure TfrmMain.kartaClick(Sender: TObject);
var index, n1: byte;
label en, sh, exitif;
begin
index:=(sender as timage).ComponentIndex;

{откл. таймера и можно ходить, если ход игрока0}
if pause.Enabled=true then
  begin
  pause.Enabled:=false;
  if curIgrok<4 then
    karta[curIgrok,curIndex].Visible:=true;
  curIgrok:=4;
  kol:=0;
  games;
  end;
if chhod<>0 then exit;

If (vibr > -1) And (vibr < 12) Then GoTo en;
If (vibr <> 12) And (Index <> 12) Then
  vibr := Index
  Else
  GoTo sh;

For n1:= 1 To (Length(vibor) div 2) do //Step 2
  If strtoint(MidStr(vibor, n1*2-1, 2)) = Index Then
    begin
    vibor:= 'mozhno';
    goto exitif;
    end;

exitif:
If vibor <> 'mozhno' Then GoTo en;
karta[0,index].Parent:=frmMain;
karta[0,Index].Left:= stol.Left + stol.Width div 9 * (f1(karta[0,Index].Tag)- 1);
karta[0,Index].Top:= stol.Top + stol.Height div 4 * (f2(karta[0,Index].Tag) - 1);
karta[0,Index].Enabled := False;
If f1(karta[0,Index].Tag) < 4 Then
karta[0,Index].BringToFront
Else
karta[0,Index].SendToBack;

status.Caption:='';
pole[f1(karta[0,Index].Tag), f2(karta[0,Index].Tag)] := karta[0,index].Tag;
kar.Tag := kar.Tag + 1;//счетчик ходов игрока
//выделять карту
curIgrok:=0;
curIndex:=index;
wait;

sh:
//kar.Enabled:=false;
chhod := chhod + 1;
If chhod = 3 Then chhod := 0;
If chhod <> 0 Then games;

en:
    vibr := -1;

end;

//=================================================================
procedure TfrmMain.razdrub;
var i: byte;
begin
if fileexists(filedir+'\rub.jpg') then
    for i:=0 to 11 do
      karta[0,i].Picture.LoadFromFile(filedir+'\rub.jpg')
  else
    for i:=0 to 11 do
      karta[0,i].Picture:=stol.Picture;

end;

//=================================================================
procedure TfrmMain.btnStartClick(Sender: TObject);
var karti: string;
i, j, r: byte;
begin
btnStart.Enabled:=false;//кнопка "Раздать" недоступна на время игры
kar.Enabled:=true;

StartClr;

karti:='111213142122232431323334414243445152535461626364717273748182838491929394';
randomize;

for j:=0 to 2 do
  for i:=0 to 11 do
    begin
    r:=random(length(karti) div 2)*2+1;
    karta[j,i].Tag:=strtoint(karti[r]+karti[r+1]);
    if karta[j,i].Tag=41 then chhod:=j;
    delete(karti,r,2);
    end;

sort;
games;

end;

//=================================================================
procedure TfrmMain.sort;
var
i, j, minK, mid: byte;
begin
for j:=0 to 10 do
  begin
  minK:=j;
  for i:=j+1 to 11 do
    if reversestring(inttostr(karta[0,minK].Tag))>reversestring(inttostr(karta[0,i].Tag)) then
      minK:=i;
    mid:=karta[0,minK].Tag;
    karta[0,minK].Tag:=karta[0,j].Tag;
    karta[0,j].Tag:=mid;
  end;

//загрузка колоды:
for j:=0 to 11 do
  karta[0,j].Picture.LoadFromFile(cardsn+inttostr(karta[0,j].tag)+'.jpg');
//inttostr(frmID.cards.ItemIndex)+

end;

//=================================================================
procedure TfrmMain.hod1;
label nach, en;
begin
If vibr1 <> -1 Then GoTo en;
nach:
prvibr1;
If vibr1 = 12 Then GoTo en;
If karta[1,vibr1].Visible = true Then GoTo nach;
curIgrok:=1;
curIndex:=vibr1;
karta[1,vibr1].Picture.LoadFromFile(cardsn+inttostr(karta[1,vibr1].tag)+'.jpg');
karta[1,vibr1].Left:=stol.Left + stol.Width div 9 * (f1(karta[1,vibr1].Tag) - 1);
karta[1,vibr1].Top:=stol.Top + stol.Height div 4 * (f2(karta[1,vibr1].Tag) - 1);
karta[1,vibr1].Visible := true;
If f1(karta[1,vibr1].Tag) < 4 Then
  karta[1,vibr1].BringToFront
  Else
  karta[1,vibr1].SendToBack;

pole[f1(karta[1,vibr1].Tag), f2(karta[1,vibr1].Tag)] := karta[1,vibr1].Tag;
kar1 := kar1 + 1;

en:
chhod := chhod + 1;
If chhod = 3 Then chhod := 0;
games;
End;

//=================================================================
procedure TfrmMain.hod2;
label nach, en;
begin
If vibr2 <> -1 Then GoTo en;
nach:
prvibr2;
If vibr2 = 12 Then GoTo en;
If karta[2,vibr2].Visible = true Then GoTo nach;
curIgrok:=2;
curIndex:=vibr2;
karta[2,vibr2].Picture.LoadFromFile(cardsn+inttostr(karta[2,vibr2].tag)+'.jpg');
karta[2,vibr2].Parent:=frmMain;
karta[2,vibr2].Left:= stol.Left + stol.Width div 9 * (f1(karta[2,vibr2].Tag) - 1);
karta[2,vibr2].Top:= stol.Top + stol.Height div 4 * (f2(karta[2,vibr2].Tag) - 1);
karta[2,vibr2].Visible := true;
If f1(karta[2,vibr2].Tag) < 4 Then
  karta[2,vibr2].BringToFront
  Else
  karta[2,vibr2].SendToBack;

pole[f1(karta[2,vibr2].Tag), f2(karta[2,vibr2].Tag)] := karta[2,vibr2].Tag;
kar2 := kar2 + 1;

en:
chhod := chhod + 1;
If chhod = 3 Then chhod := 0;
games;
End;

//=================================================================
procedure TfrmMain.prvibr1;
var n, ni, k, m, i, rnd, r, rayting: byte;
s, max, maxs: string;
vibors: array of array of string;{хранит индексы карт}
                                 {и рейтинги из 0 и 1}
begin                            {и рейтинги 0..?}
vibor := '';
setlength(vibors,3,12);
ni:=0;
For n := 0 To 11 do
  If karta[1,n].Visible = false Then
    Case f1(karta[1,n].Tag) of
      1..3:
        If pole[f1(karta[1,n].Tag) + 1, f2(karta[1,n].Tag)] <> 0 Then
          begin
          vibors[0,ni]:=inttostr(n);
          ni:=ni+1;
          end;
      4:
        begin
        vibors[0,ni]:=inttostr(n);
        ni:=ni+1;
        end;
      5..9:
        If pole[f1(karta[1,n].Tag) - 1, f2(karta[1,n].Tag)] <> 0 Then
          begin
          vibors[0,ni]:=inttostr(n);
          ni:=ni+1;
          end;
    End;//end case

If ni=0 Then
  begin
  //нет карт чтобы сходить
  gamer1.Color:=clRed;
  lbank.Color:=clBlue;
  status.Caption:='Sonya пропускает ход и платит штраф.';
  vibr1 := 12;
  kon:=kon+dball;
  wait;
  Exit;
  end;

For n := 0 To ni-1 do
  begin
  k:=f1(karta[1,strtoint(vibors[0,n])].Tag);
  m:=f2(karta[1,strtoint(vibors[0,n])].Tag);
  case k of
    1: vibors[1,n]:='1';
    2: vibors[1,n]:=ife(1,k-1,m);
    3: vibors[1,n]:=ife(1,k-1,m)+ife(1,k-2,m);
    4: vibors[1,n]:=ife(1,k-1,m)+ife(1,k-2,m)+ife(1,k-3,m)
       +ife(1,k+1,m)+ife(1,k+2,m)+ife(1,k+3,m)+ife(1,k+4,m)+ife(1,k+5,m);
    5: vibors[1,n]:=ife(1,k+1,m)+ife(1,k+2,m)+ife(1,k+3,m)+ife(1,k+4,m);
    6: vibors[1,n]:=ife(1,k+1,m)+ife(1,k+2,m)+ife(1,k+3,m);
    7: vibors[1,n]:=ife(1,k+1,m)+ife(1,k+2,m);
    8: vibors[1,n]:=ife(1,k+1,m);
    9: vibors[1,n]:='1';
  end;
  end;

rayting:=0;
for r:=0 to 108 do
  begin
  s:=data[r];
  for i:=0 to ni-1 do
    begin
    if (s='') and (i=0) then inc(rayting);//шаг увеличения зависит от ni
    if s=vibors[1,i] then vibors[2,i]:=inttostr(rayting);
    if f1(karta[1,strtoint(vibors[0,i])].Tag)=4 then
      begin
      if s=midstr(vibors[1,i],1,3) then
        vibors[2,i]:=rightstr('000'+inttostr(rayting),3)+vibors[2,i];
      if s=midstr(vibors[1,i],4,5) then
        vibors[2,i]:=vibors[2,i]+rightstr('000'+inttostr(rayting),3);
      if length(vibors[2,i])=6 then
        if leftstr(vibors[2,i],3)>=rightstr(vibors[2,i],3) then
          vibors[2,i]:=inttostr(strtoint(leftstr(vibors[2,i],3)))
          else
          vibors[2,i]:=inttostr(strtoint(rightstr(vibors[2,i],3)));
      end;
    end;
  end;

max:=rightstr('000'+vibors[2,0],3);
if ni=1 then
  maxs:=rightstr('00'+vibors[0,0],2)
  else
  maxs:=rightstr('00'+vibors[0,0],2);
  begin
  for i:=1 to ni-1 do
    begin
    if strtoint(max)<strtoint(vibors[2,i]) then
      begin
      max:=rightstr('000'+vibors[2,i],3);
      maxs:=rightstr('00'+vibors[0,i],2);
      end;
    if strtoint(max)=strtoint(vibors[2,i]) then
      begin
      maxs:=maxs+rightstr('00'+vibors[0,i],2);
      end;
    end;
  end;

randomize;
rnd:=((random(length(maxs))) div 2)*2+1;
vibr1:=strtoint(midstr(maxs,rnd,2));
wait;
{showmessage('1 игрок:'+#13+
    vibors[0,0]+'_'+vibors[0,1]+'_'+vibors[0,2]+'_'+vibors[0,3]+#13+
    vibors[1,0]+'_'+vibors[1,1]+'_'+vibors[1,2]+'_'+vibors[1,3]+#13+
    vibors[2,0]+'_'+vibors[2,1]+'_'+vibors[2,2]+'_'+vibors[2,3]);
 }
end;

//=================================================================
procedure TfrmMain.prvibr2;
var n, ni, k, m, i, rnd, r, rayting: byte;
s, max, maxs: string;
vibors: array of array of string;{хранит индексы карт}
                                 {и рейтинги из 0 и 1}
begin                            {и рейтинги 0..?}
vibor := '';
setlength(vibors,3,12);
ni:=0;
For n := 0 To 11 do
  If karta[2,n].Visible = false Then
    Case f1(karta[2,n].Tag) of
      1..3:
        If pole[f1(karta[2,n].Tag) + 1, f2(karta[2,n].Tag)] <> 0 Then
          begin
          vibors[0,ni]:=inttostr(n);
          ni:=ni+1;
          end;
      4:
        begin
        vibors[0,ni]:=inttostr(n);
        ni:=ni+1;
        end;
      5..9:
        If pole[f1(karta[2,n].Tag) - 1, f2(karta[2,n].Tag)] <> 0 Then
          begin
          vibors[0,ni]:=inttostr(n);
          ni:=ni+1;
          end;
    End;

If ni=0 Then
  begin
  //нет карт чтобы сходить
  gamer2.Color:=clRed;
  lbank.Color:=clBlue;
  status.Caption:='Tanya пропускает ход и платит штраф.';
  vibr2 := 12;
  kon:=kon+dball;
  wait;
  Exit;
  end;

For n := 0 To ni-1 do
  begin
  //выбор лучшей карты из списка доступных номеров
  k:=f1(karta[2,strtoint(vibors[0,n])].Tag);
  m:=f2(karta[2,strtoint(vibors[0,n])].Tag);
  case k of
    1: vibors[1,n]:='1';
    2: vibors[1,n]:=ife(2,k-1,m);
    3: vibors[1,n]:=ife(2,k-1,m)+ife(2,k-2,m);
    4: vibors[1,n]:=ife(2,k-1,m)+ife(2,k-2,m)+ife(2,k-3,m)
       +ife(2,k+1,m)+ife(2,k+2,m)+ife(2,k+3,m)+ife(2,k+4,m)+ife(2,k+5,m);
    5: vibors[1,n]:=ife(2,k+1,m)+ife(2,k+2,m)+ife(2,k+3,m)+ife(2,k+4,m);
    6: vibors[1,n]:=ife(2,k+1,m)+ife(2,k+2,m)+ife(2,k+3,m);
    7: vibors[1,n]:=ife(2,k+1,m)+ife(2,k+2,m);
    8: vibors[1,n]:=ife(2,k+1,m);
    9: vibors[1,n]:='1';
  end;
  end;

rayting:=0;
for r:=0 to 108 do
  begin
  s:=data[r];
  for i:=0 to ni-1 do
    begin
    if (s='') and (i=0) then inc(rayting);
    if s=vibors[1,i] then vibors[2,i]:=inttostr(rayting);
    if f1(karta[2,strtoint(vibors[0,i])].Tag)=4 then
      begin
      if s=midstr(vibors[1,i],1,3) then
        vibors[2,i]:=rightstr('000'+inttostr(rayting),3)+vibors[2,i];
      if s=midstr(vibors[1,i],4,5) then
        vibors[2,i]:=vibors[2,i]+rightstr('000'+inttostr(rayting),3);
      if length(vibors[2,i])=6 then
        if leftstr(vibors[2,i],3)>=rightstr(vibors[2,i],3) then
          vibors[2,i]:=inttostr(strtoint(leftstr(vibors[2,i],3)))
          else
          vibors[2,i]:=inttostr(strtoint(rightstr(vibors[2,i],3)));
      end;
    end;
  end;

max:=rightstr('000'+vibors[2,0],3);
if ni=1 then
  maxs:=rightstr('00'+vibors[0,0],2)
  else
  maxs:=rightstr('00'+vibors[0,0],2);
  begin
  for i:=1 to ni-1 do
    begin
    if strtoint(max)<strtoint(vibors[2,i]) then
      begin
      max:=rightstr('000'+vibors[2,i],3);
      maxs:=rightstr('00'+vibors[0,i],2);
      end;
    if strtoint(max)=strtoint(vibors[2,i]) then
      begin
      maxs:=maxs+rightstr('00'+vibors[0,i],2);
      end;
    end;
  end;

randomize;
rnd:=((random(length(maxs))) div 2)*2+1;
vibr2:=strtoint(midstr(maxs,rnd,2));
wait;
{
showmessage('2 игрок:'+#13+
    vibors[0,0]+'_'+vibors[0,1]+'_'+vibors[0,2]+'_'+vibors[0,3]+#13+
    vibors[1,0]+'_'+vibors[1,1]+'_'+vibors[1,2]+'_'+vibors[1,3]+#13+
    vibors[2,0]+'_'+vibors[2,1]+'_'+vibors[2,2]+'_'+vibors[2,3]);
 }
end;

//=================================================================
procedure TfrmMain.WMSysCommand(var Msg: TWMSysCommand);
begin
case Msg.CmdType of
MenuItem, MenuItem+1: shellexecute(0,nil,'mailto:shurik83@mail.ru',nil,nil,0);
MenuItem+2: shellexecute(0,nil,'http://www.shurik83.narod.ru/',nil,nil,0);
else
inherited;
end;

end;

//=================================================================
procedure TfrmMain.wait;
begin
kol:=0;
pause.Enabled:=true;
end;

//=================================================================
procedure TfrmMain.pauseTimer(Sender: TObject);
begin
inc(kol);
if curIgrok<4 then
  karta[curIgrok,curIndex].Visible:=
                            not(karta[curIgrok,curIndex].Visible);
if kol>9 then
  begin
  if curIgrok<4 then karta[curIgrok,curIndex].Visible:=true;
  pause.Enabled:=false;
  curIgrok:=4;
  kol:=0;
  games;
  exit;
  end;

end;

//=================================================================
procedure TfrmMain.idshowClick(Sender: TObject);
begin
if messagebox(frmMain.WindowHandle,'Текущая игра будет прервана!',
      'Сменить игрока?', mb_okcancel+mb_iconwarning)=1 then
  begin
  frmMain.Hide;
  btnStart.Enabled:=true;
  kar.Enabled:=false;
  StartClr;
  razdrub;
  frmID.Show;
  end;
end;

//=================================================================
procedure TfrmMain.saveTable;
begin
if gindex>1 then
  begin
  frmID.igroki.Cells[2,gindex]:=inttostr(ball);
//           ((strtoint(frmID.igroki.Cells[2,gindex]) + ball) div 2);
  frmID.igroki.Cells[1,gindex]:=inttostr
            (strtoint(frmID.igroki.Cells[1,gindex])+1);
  end;
end;

//=================================================================
procedure TfrmMain.spravClick(Sender: TObject);
begin
frmMain.Enabled:=false;
frmInfo.Show;
end;

//=================================================================
procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if messagebox(frmMain.WindowHandle,'Вы уверены, что '+#13+#10
  +'хотите покинуть программу?','Выход',mb_okcancel+mb_iconquestion)
  = idok then
  begin
  frmID.saveTable;
  application.Terminate;
  end
  else
  action:=caNone;
end;

//=================================================================
procedure TfrmMain.StartClr;
var i, j2, i2: byte;
begin

pause.Enabled:=false;
kon:=0;
vibr := -1;
vibr1 := -1;
vibr2 := -1;
kar.Tag := 0;
kar1 := 0;
kar2 := 0;
vibor:='';
nhod := 0;
kol:=0;
CurIgrok:=4;

for j2:=1 to 4 do
  for i2:=1 to 9 do pole[i2,j2]:=0;

for i:=0 to 11 do
  begin
  karta[0,i].Parent:=frmMain.kar;
  karta[0,i].Enabled:=true;
  karta[0,i].Top:=10;
  karta[0,i].Left:=i*65+7;
  karta[0,i].Visible:=true;
  karta[1,i].Visible:=false;
  karta[2,i].Visible:=false;
  end;

status.Color:=clWhite;

end;

//=================================================================
procedure TfrmMain.Image3Click(Sender: TObject);
begin
if pause.Enabled=true then
  begin
  pause.Enabled:=false;
  if curIgrok<4 then karta[curIgrok,curIndex].Visible:=true;
  curIgrok:=4;
  kol:=0;
  games;
  exit;
  end;

end;

end.

