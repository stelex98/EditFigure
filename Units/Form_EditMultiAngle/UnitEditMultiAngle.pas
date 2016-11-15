unit UnitEditMultiAngle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ColorGrd, StdCtrls, Buttons, UnitMultiAngle;

type
  TFormEditMultiAngle = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    brnOk: TBitBtn;
    btnCansel: TBitBtn;
    Label5: TLabel;
    edName: TEdit;
    memXY: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure brnOkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FMuliAngle : TMyMultiAngleClass;
  end;

var
  FormEditMultiAngle: TFormEditMultiAngle;

implementation
uses UnitBaseClass;
{$R *.dfm}

procedure MAngle5 (aLines : TStrings);
begin
   // Пятиугольник

(*
   aLines.Add ('30 30');
   aLines.Add ('20 50');
   aLines.Add ('40 60');
   aLines.Add ('60 50');
   aLines.Add ('50 30');
   // Звезда - плохая трианг
   (*
   aLines.Add ('30 30');
   aLines.Add ('40 0');

   aLines.Add ('50 30');
   aLines.Add ('80 40');

   aLines.Add ('60 50');
   aLines.Add ('70 70');

   aLines.Add ('40 60');
   aLines.Add ('10 70');

   aLines.Add ('20 50');
   aLines.Add (' 0 40');
*)

   // Звезда - Ок трианг
   aLines.Add ('200 320');
   aLines.Add ('241 257');

   aLines.Add ('314 257');
   aLines.Add ('267 178');

   aLines.Add ('271 103');
   aLines.Add ('200 130');

   aLines.Add ('129 103');
   aLines.Add ('133 178');

   aLines.Add ('86 237');
   aLines.Add ('159 257');
end;

procedure TFormEditMultiAngle.FormCreate(Sender: TObject);
begin
  FMuliAngle:=Nil;
end;

procedure TFormEditMultiAngle.FormActivate(Sender: TObject);
var i : Integer;
begin
  if Assigned (FMuliAngle)
  then
    begin
      edName.Text:=FMuliAngle.FigureName;
      memXY.Lines.BeginUpdate;
      try
        memXY.Lines.Clear;
      if FMuliAngle.VertexCount>0
      then
        for i:=0 to FMuliAngle.VertexCount-1 do
          memXY.Lines.Add(TMyPointToStr(FMuliAngle.Vertex[i]))
      else
        begin // Для отладки создаем Звезду
          MAngle5(memXY.Lines);
        end;
      finally memXY.Lines.EndUpdate; end;
    end
end;

procedure TFormEditMultiAngle.brnOkClick(Sender: TObject);
var X, Y, W, C, i : Integer;
    wP : TMyPoint;
    wA : TMyPolygonArray;
    s, Msg : String;
begin
  ModalResult:=mrNone;
  SetLength(wA,0);
  try
    if Length(Trim(edName.Text))=0 then raise Exception.Create('Укажите наименование фигуры');
    for i:=0 to memXY.Lines.Count-1 do
    begin
      s:=Trim(memXY.Lines[i]);
      if Length(S)>0 then
      begin
        wP:=StrToTMyPoint(s);
        SetLength(wA, Length(wA)+1);
        wA[High(wA)]:=wP;
      end
    end;
    if Length (wA)<3 then raise Exception.Create('Нужно минимум 3 вершины');
    FMuliAngle.ClearVertex;
    for i:=Low(wA) to High(wA) do FMuliAngle.AddVertex(wA[i]);

    FMuliAngle.FigureName:=Trim(edName.Text);
    ModalResult:=mrOk;

  finally wA:=Nil; end;
end;

end.
