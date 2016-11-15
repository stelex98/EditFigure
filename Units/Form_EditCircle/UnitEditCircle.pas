unit UnitEditCircle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ColorGrd, StdCtrls, Buttons,
  UnitCircle;

type
  TFormEditCircle = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edXY: TEdit;
    Label3: TLabel;
    edXr: TEdit;
    brnOk: TBitBtn;
    btnCansel: TBitBtn;
    Label5: TLabel;
    edName: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure brnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FCircle : TMyCircleClass;
  end;

var
  FormEditCircle: TFormEditCircle;

implementation
uses UnitBaseClass;
{$R *.dfm}

procedure TFormEditCircle.FormCreate(Sender: TObject);
begin
  FCircle:=Nil;
end;

procedure TFormEditCircle.FormActivate(Sender: TObject);
begin
  if Assigned (FCircle)
  then
    begin
      edName.Text:=FCircle.FigureName;
      edXY.Text:=TMyPointToStr(FCircle.Center);
      edXr.Text:=IntToStr (FCircle.Radius);
    end;
end;

procedure TFormEditCircle.brnOkClick(Sender: TObject);
var rX, W, C : Integer;
   CP : TMyPoint;
   Msg : String;
begin
  ModalResult:=mrNone;
  try
    if Length(Trim(edName.Text))=0 then raise Exception.Create('”кажите наименование фигуры');
    CP:=StrToTMyPoint (Trim(edXY.Text));
    rX:=StrToInt (Trim(edXr.Text));

    FCircle.FigureName:=Trim(edName.Text);
    FCircle.Center:=CP;
    FCircle.Radius:=rX;
    ModalResult:=mrOk;

  except
    on E: Exception do
      begin
         with Application do
         begin
           NormalizeTopMosts;
           msg:=E.Message;
           MessageBox(@msg[1], 'ќшибка', MB_OK+MB_ICONSTOP);
           RestoreTopMosts;
         end;
      end;
  end;
end;

end.
