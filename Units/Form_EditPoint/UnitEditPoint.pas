unit UnitEditPoint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ColorGrd, StdCtrls, UnitPoint, Buttons;

type
  TFormEditPoint = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edX: TEdit;
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
    FPoint : TMyPointClass;
  end;

var
  FormEditPoint: TFormEditPoint;

implementation
uses UnitBaseClass;
{$R *.dfm}

procedure TFormEditPoint.FormCreate(Sender: TObject);
begin
  FPoint:=Nil;
end;

procedure TFormEditPoint.FormActivate(Sender: TObject);
begin
  if Assigned (FPoint)
  then
    begin
      edName.Text:=FPoint.FigureName;
      edX.Text:=TMyPointToStr(FPoint.PointA);
    end;
end;

procedure TFormEditPoint.brnOkClick(Sender: TObject);
var W, C : Integer;
    wC : TMyPoint;
   Msg : String;
begin
  ModalResult:=mrNone;

  if Length(Trim(edName.Text))=0 then raise Exception.Create('”кажите наименование фигуры');
  wC:=StrToTMyPoint (Trim(edX.Text));
  FPoint.FigureName:=Trim(edName.Text);
  
  ModalResult:=mrOk;
end;

end.
