unit UnitEditLine;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ColorGrd, StdCtrls, Buttons,
  UnitLine;

type
  TFormEditLine = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edXYh: TEdit;
    Label3: TLabel;
    edXYe: TEdit;
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
    FLine : TMyLineClass;
  end;

var
  FormEditLine: TFormEditLine;

implementation
uses UnitBaseClass;
{$R *.dfm}

procedure TFormEditLine.FormCreate(Sender: TObject);
begin
  FLine:=Nil;
end;

procedure TFormEditLine.FormActivate(Sender: TObject);
begin
  if Assigned (FLine)
  then
    begin
      edName.Text:=FLine.FigureName;
      edXYh.Text:=TMyPointToStr(FLine.PointA);
      edXYe.Text:=TMyPointToSTr(FLine.PointB);
    end;
end;

procedure TFormEditLine.brnOkClick(Sender: TObject);
var W, C : Integer;
    AP, BP : TMyPoint;
   Msg : String;
begin
  ModalResult:=mrNone;

  if Length(Trim(edName.Text))=0 then raise Exception.Create('”кажите наименование фигуры');
  AP:=StrToTMyPoint (Trim(edXYh.Text));
  BP:=StrToTMyPoint (Trim(edXYe.Text));
  FLine.FigureName:=Trim(edName.Text);
  FLine.PointA:=AP;
  FLine.PointB:=BP;
  
  ModalResult:=mrOk;
end;

end.
