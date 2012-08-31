unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ComCtrls, Buttons, ShellAPI,
  RxGIF, ExtCtrls;

type
  TfrmInfo = class(TForm)
    Image2: TImage;
    Memo1: TMemo;
    Image1: TImage;
    mailB: TSpeedButton;
    siteB: TSpeedButton;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure FormHide(Sender: TObject);
    procedure mailBClick(Sender: TObject);
    procedure siteBClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInfo: TfrmInfo;

implementation

uses Unit2, Unit1;

{$R *.dfm}

procedure TfrmInfo.FormHide(Sender: TObject);
begin
frmMain.Enabled:=true;
end;

procedure TfrmInfo.mailBClick(Sender: TObject);
begin
shellexecute(0,nil,'mailto:shurik83@mail.ru',nil,nil,0);
end;

procedure TfrmInfo.siteBClick(Sender: TObject);
begin
shellexecute(0,nil,'http://www.shurik83.narod.ru/',nil,nil,0);
end;

procedure TfrmInfo.Image1Click(Sender: TObject);
begin
frmInfo.Close;
end;

end.
