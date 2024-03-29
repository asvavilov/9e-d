unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, Grids, Buttons, ExtCtrls, StdCtrls;

type
  TfrmID = class(TForm)
    igroki: TStringGrid;
    GroupBox1: TGroupBox;
    add: TSpeedButton;
    del: TSpeedButton;
    GroupBox2: TGroupBox;
    start: TSpeedButton;
    exit: TSpeedButton;
    cards: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure exitClick(Sender: TObject);
    procedure startClick(Sender: TObject);
    procedure addClick(Sender: TObject);
    procedure delClick(Sender: TObject);
    procedure saveTable;
    procedure igrokiKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure igrokiSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cardsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TGamer = record
    Name: String[15];
    KolGames: integer;
    Ball: integer;
    Koloda: String[11];
end;

var
  frmID: TfrmID;

implementation

uses Unit1;

{$R *.dfm}

procedure TfrmID.saveTable;
var
fres: file of TGamer;
gamer: TGamer;
i: integer;
begin
  AssignFile(fres,'result.tbl');
  rewrite(fres);
  for i:=1 to igroki.RowCount-1 do
    begin
    gamer.Name:=igroki.Cells[0,i];
    gamer.KolGames:=strtoint(igroki.Cells[1,i]);
    gamer.Ball:=strtoint(igroki.Cells[2,i]);
    gamer.Koloda:=igroki.Cells[3,i];
    Write(fres,gamer);
    end;
  CloseFile(fres);
end;

procedure TfrmID.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if messagebox(frmMain.Handle,'�� �������, ��� '+#10+#13
  +'������ �������� ���������?','�����',mb_okcancel+mb_iconquestion)
  = idok then
  begin
  saveTable;
  application.Terminate;
  end
  else
  action:=caNone;
end;

procedure TfrmID.exitClick(Sender: TObject);
begin
frmID.Close;
end;

procedure TfrmID.startClick(Sender: TObject);
begin
gindex:=igroki.Row;
ball:=strtoint(igroki.Cells[2,gindex]);
cardsn:='cards'+inttostr(cards.ItemIndex)+'\';
with frmMain do
  begin
  gamer0.Caption:=igroki.Cells[0,gindex];
  lbl0.Caption:=igroki.Cells[2,gindex];
  lblKon.Caption:='0';
  gamer0.Color:=clBlack;
  gamer1.Color:=clBlack;
  gamer2.Color:=clBlack;
  lbank.Color:=clGray;
  status.Caption:='��� ������ ���� ������� ������ "�������"';
  end;
frmMain.Show;
frmID.Hide;
end;

procedure TfrmID.addClick(Sender: TObject);
var newName: string;
begin
newName:=inputbox('���������� ������ ������','����� ���:','');
if (newName>'') and (length(newName)<=15) then
  begin
  igroki.RowCount:=igroki.RowCount+1;
  igroki.Cells[0,igroki.RowCount-1]:=newName;
  igroki.Cells[1,igroki.RowCount-1]:='0';
  igroki.Cells[2,igroki.RowCount-1]:='0';
  igroki.Cells[3,igroki.RowCount-1]:='�����������';
  igroki.Row:=igroki.RowCount-1;
  end
  else
  showmessage('��� �� ������ ���� ������ �������'
            +chr(10)+chr(13)+'��� ����� 15 ��������!');
end;

procedure TfrmID.delClick(Sender: TObject);
var i: integer;
begin
if igroki.Row>=2 then
  begin
  for i:=igroki.row to igroki.RowCount-1 do
    igroki.Rows[i]:=igroki.Rows[i+1];
  igroki.RowCount:=igroki.RowCount-1;
  end;
end;

procedure TfrmID.igrokiKeyPress(Sender: TObject; var Key: Char);
begin
if key=chr(13) then frmID.startClick(self);
end;

procedure TfrmID.FormCreate(Sender: TObject);
var fres: file of TGamer;
gamer: TGamer;
begin
igroki.Cells[0,0]:='��� ������';
igroki.Cells[1,0]:='���-�� ���';
igroki.Cells[2,0]:='����';
igroki.Cells[3,0]:='������';
igroki.Cells[0,1]:='�����';
igroki.Cells[1,1]:='0';
igroki.Cells[2,1]:='0';
igroki.Cells[3,1]:='�����������';

if FileExists('result.tbl') then
  begin
  AssignFile(fres,'result.tbl');
  Reset(fres);
  igroki.RowCount:=igroki.RowCount-1;
  while not(eof(fres)) do
    begin
    igroki.RowCount:=igroki.RowCount+1;
    if igroki.RowCount=2 then igroki.FixedRows:=1;
    Read(fres,gamer);
    igroki.Cells[0,igroki.RowCount-1]:=gamer.name;
    igroki.Cells[1,igroki.RowCount-1]:=inttostr(gamer.KolGames);
    igroki.Cells[2,igroki.RowCount-1]:=inttostr(gamer.Ball);
    igroki.Cells[3,igroki.RowCount-1]:=gamer.Koloda;
    end;
  CloseFile(fres);
  end;
if igroki.Cells[3,igroki.Row]='�����������' then
  cards.ItemIndex:=1
  else
  cards.ItemIndex:=0;

end;

procedure TfrmID.igrokiSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
if igroki.Cells[3,igroki.Row]='�����������' then
  cards.ItemIndex:=1
  else
  cards.ItemIndex:=0;

end;

procedure TfrmID.cardsClick(Sender: TObject);
begin
if igroki.Row>0 then
  if cards.ItemIndex=1 then
    igroki.Cells[3,igroki.Row]:='�����������';
  if cards.ItemIndex=0 then
    igroki.Cells[3,igroki.Row]:='�����������';

end;

end.
