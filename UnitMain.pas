unit UnitMain;

interface

uses
  Windows, SysUtils, Graphics, StdCtrls, Controls, ComCtrls, Buttons,
  Classes, ExtCtrls, Forms,
  UnitBaseClass;

type
  TFormMain = class(TForm)
    imgWin: TImage;           // ����-����� ��� ���������
    lvFigures: TListView;     // ������ ��������� ������������� �����
    GroupBox1: TGroupBox;     // ����� "�������������� ������"
    Label1: TLabel;           // ���������� ����� - ����� "��������"
    Label2: TLabel;           //                  - ����� "�������"
    Label3: TLabel;           //                  - ����� "����� ����"
    lblPloschad: TLabel;      // ���������� ����� ��� ������
    lblPerimetr: TLabel;      // ������������� ������� ������
    lblCentr: TLabel;         // (��������, �������, �����)
    btnPoint: TSpeedButton;   // ������ "������� ������ �����"
    btnLine: TSpeedButton;    // ������ "������� ������ �����"
    btnSquare: TSpeedButton;  // ������ "������� ������ �������"
    btnMulty: TSpeedButton;   // ������ "������� ������ �������������"
    btnCircle: TSpeedButton;  // ������ "������� ������ ����"
    btnEdit: TSpeedButton;    // ������ "������������� ������"
    bntDel: TSpeedButton;     // ������ "������� ������"
    btnTransf: TSpeedButton;
    cbPaintTriangles: TCheckBox;  // ������ "���������������� ������"
    // ��� �������� ��� �������� �����
    procedure FormCreate(Sender: TObject);
    // ��� �������� ��� ���������� �����
    procedure FormDestroy(Sender: TObject);
    // ��� �������� ��� ��������� ������� ����� (����)
    procedure FormResize(Sender: TObject);
    // �������� �� �������� ����� � ������ �����
    procedure lvFiguresDblClick(Sender: TObject);
    // �������� ��� ��������� ������ ������
    procedure lvFiguresSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    // ���������� ������ ������ �������� �������
    procedure ButtonClickHandler(Sender: TObject);
    procedure cbPaintTrianglesClick(Sender: TObject);
  private
    { Private declarations }
    // ������������� ����� ��� ��������� - ���������� ������ �� ����,
    // ����� ������� ������� ������ ���������� � ���� �����������
    FBitMap : TBitmap;
    // �������� ����� ������
    procedure CreateNewFigure (aFT : TFigureType);
    // �������������� ������������
    procedure EditFigureParams;
    // �������� ������������
    procedure DeleteFigure;
    // ������������� ������
    procedure TransformFigure;
  public
    { Public declarations }
    // ��������� ���������-������� �� ���������� � ������
    procedure OnTransformateEventHandler (Sender: TObject);
  end;

var
  FormMain: TFormMain;

implementation
uses UnitEditTransform,  Unit_Triangulate,
     UnitPoint, UnitLine, UnitSquare, UnitMultiAngle, UnitCircle,
     UnitEditPoint, UnitEditLine, UnitEditCircle,UnitEditSquare,
     UnitEditMultiAngle;

{$R *.dfm}
// ��� �������� ��� �������� �����
procedure TFormMain.FormCreate(Sender: TObject);
begin
  DoubleBuffered := TRUE;
  lblPloschad.Caption:='';
  lblPerimetr.Caption:='';
  lblCentr.Caption:='';
  FBitMap:=TBitMap.Create;
  DEBUG_BMP:=Nil;
end;
// ��� �������� ��� ����������� �����
procedure TFormMain.FormDestroy(Sender: TObject);
var i : Integer;
begin
  // ���������� ��� ��������� ���������� ������� �����
  for i:=0 to lvFigures.Items.Count-1 do
    TMy2DFigureBaseClass(lvFigures.Items[i].Data).Free;
  FBitMap.Free;
end;
// ��� ��������� �������� �����
procedure TFormMain.FormResize(Sender: TObject);
begin
  // �������� ������� ����-������ ��� ���������
  imgWin.Picture.Bitmap.Height:=imgWin.Height;
  imgWin.Picture.Bitmap.Width:=imgWin.Width;
  imgWin.Picture.Bitmap.Canvas.Rectangle(0,0,imgWin.Width, imgWin.Height);
  FBitMap.Width:=imgWin.Picture.Bitmap.Width;
  FBitMap.Height:=imgWin.Picture.Bitmap.Height;
  // ������������ ��������� ���������� ������� �����
  OnTransformateEventHandler(Self);
end;

// ����������� ������� ��������� lvFigures, ���������-��������� �������� � ��������

// �������� ��� ��������� ������� ������ � ������ �����
procedure TFormMain.lvFiguresSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected
  then  // �������� ������ Item
    begin
      // ��������� ����� �����-������������� ������ (�������� �� �����)
      lblPloschad.Caption:=IntToStr(Round(TMy2DFigureBaseClass(Item.Data).Ploschad));
      lblPerimetr.Caption:=IntToStr(Round(TMy2DFigureBaseClass(Item.Data).Perimetr));
      lblCentr.Caption:=TMyPointToStr (TMy2DFigureBaseClass(Item.Data).MassCenter);
      if TMy2DFigureBaseClass(Item.Data).FigureType=ftMultiAngle
      then
        begin
          lblPloschad.Caption:=lblPloschad.Caption+' (�� '+
                IntToStr(Round(TMyMultiAngleClass(Item.Data).Ploschad3))+')';
          lblCentr.Caption:=lblCentr.Caption+' (�� '+
                TMyPointToStr (TMyMultiAngleClass(Item.Data).MassCenter3)+')';
        end
      else
        if TMy2DFigureBaseClass(Item.Data).FigureType=ftSquare
        then
          begin
            lblPloschad.Caption:=lblPloschad.Caption+' (�� '+
                  IntToStr(Round(TMySquareClass(Item.Data).Ploschad3))+')';
            lblCentr.Caption:=lblCentr.Caption+' (�� '+
                  TMyPointToStr (TMySquareClass(Item.Data).MassCenter3)+')';
          end
    end
  else  // ����� ��������� �� ������ Item
    begin
      // ������� ����� �����-������������� ������
      lblPloschad.Caption:='';
      lblPerimetr.Caption:='';
      lblCentr.Caption:='';
    end;
end;

// ���������� ������� �� ����������� ������������� ���� �������
procedure TFormMain.OnTransformateEventHandler (Sender: TObject);
var i : Integer;
    R : TRect;
begin
  // ������ ����
  FBitMap.Canvas.Brush.Style:=bsSolid;
  FBitMap.Canvas.Rectangle(0,0,FBitMap.Width, FBitMap.Height);
  // ������ ������� ����� ����������
  FBitMap.Canvas.Brush.Style:=bsClear;
  // �������������� ��������� ������
  R:=Rect(0,0, FBitMap.Width, FBitMap.Height);
  for i:=0 to lvFigures.Items.Count-1 do
    TMy2DFigureBaseClass(lvFigures.Items[i].Data).Paint(FBitmap.Canvas);
  imgWin.Picture.Bitmap.Canvas.CopyRect(R, FBitMap.Canvas, R);
  imgWin.Repaint;
end;
// �������������� ���������� ��� ������������ �����-����������� ����� �������
procedure TFormMain.EditFigureParams;
var LI : TListItem;
MSG : STRING;
begin
  if not Assigned (lvFigures.Selected)
  then raise Exception.Create('�� ������� ������ ��� ��������������.')
  else
  begin
    LI:=lvFigures.Selected;
    case TMy2DFigureBaseClass(LI.Data).FigureType of
      ftPoint: begin
                 FormEditPoint.FPoint:=LI.Data;
                 if FormEditPoint.ShowModal<>mrOk then exit;
                 LI.Caption:=FormEditPoint.FPoint.FigureName;
               end;
      ftLine: begin
                 FormEditLine.FLine:=LI.Data;
                 if FormEditLine.ShowModal<>mrOk then exit;
               end;
     ftCircle: begin
                 FormEditCircle.FCircle:=LI.Data;
                 if FormEditCircle.ShowModal<>mrOk then exit;
               end;
     ftMultiAngle: begin
                 FormEditMultiAngle.FMuliAngle:=LI.Data;
                 if FormEditMultiAngle.ShowModal<>mrOk then exit;
               end;
     ftSquare: begin
                 FormEditSquare.FSquare:=LI.Data;
                 if FormEditSquare.ShowModal<>mrOk then exit;
               end;
      else raise Exception.Create('�������������� : ����������� ����� ������.')
    end;
    LI.Caption:=TMy2DFigureBaseClass(LI.Data).FigureName;
    // �������������� ����
    OnTransformateEventHandler(Self);
    // ������������ ��������� ������
    lvFiguresSelectItem(lvFigures, LI, True);
  end;
end;
// ����������� ������
procedure TFormMain.DeleteFigure;
var LI : TListItem;
     k : Integer;
begin
  if not Assigned (lvFigures.Selected)
  then raise Exception.Create('�� ������� ������ ��� ��������.')
  else
  begin
    LI:=lvFigures.Selected;
    // ���� ����������
    k:=lvFigures.Items.IndexOf(LI);
    if k>=0 then
    begin
      // ���������� ��� ��������� ������
      TMy2DFigureBaseClass(LI.Data).Free;
      // ������� ������ �� ������� �����
      lvFigures.Items.Delete(k);
    end;
  end;
  // �������������� ����-�����
  OnTransformateEventHandler(Self);
end;

procedure TFormMain.lvFiguresDblClick(Sender: TObject);
begin
  TransformFigure;
end;

procedure TFormMain.TransformFigure;
begin
  if not Assigned (lvFigures.Selected)
    then raise Exception.Create('�� ������� ������ ��� �����������������.');
  FormEditTransform.FFigure:=lvFigures.Selected.Data;
  FormEditTransform.ShowModal;
  lvFiguresSelectItem(lvFigures, lvFigures.Selected, True)
end;

procedure TFormMain.ButtonClickHandler(Sender: TObject);
var Tag : Integer;
begin
  // ��������� �������� ��������� TSpeedButton ? (������ ������)
  if Sender is TSpeedButton then Tag:=TSpeedButton(Sender).Tag
    else exit; // ���������� ��� ������ - ������� �� ������
  case Tag of
    101 : CreateNewFigure (ftPoint);
    102 : CreateNewFigure (ftLine);
    105 : CreateNewFigure (ftSquare);
    106 : CreateNewFigure (ftMultiAngle);

    108 : CreateNewFigure (ftCircle);

    201 : EditFigureParams;
    301 : DeleteFigure;
    401 : TransformFigure;
  end;
end;

procedure TFormMain.CreateNewFigure (aFT : TFigureType);
var LI : TListItem;
       wPoint : TMyPointClass;
        wLine : TMyLineClass;
      wCircle : TMyCircleClass;
    wMultiAng : TMyMultiAngleClass;
      wSquare : TMySquareClass;
begin
  case aFT of
    ftPoint : begin
                wPoint:=TMyPointClass.Create('�����', MyPoint(10, 10));
                wPoint.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditPoint.FPoint:=wPoint;
                if FormEditPoint.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wPoint.FigureName;
                    LI.Data:=wPoint;
                  end
                else wPoint.Free;
             end;
    ftLine : begin
                wLine:=TMyLineClass.Create('�����', MyPoint(100, 100), MyPoint(300, 100));
                wLine.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditLine.FLine:=wLine;
                if FormEditLine.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wLine.FigureName;
                    LI.Data:=wLine;
                  end
                else wLine.Free;
             end;
    ftCircle : begin
                wCircle:=TMyCircleClass.Create('����', MyPoint(100, 100), 50);
                wCircle.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditCircle.FCircle:=wCircle;
                if FormEditCircle.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wCircle.FigureName;
                    LI.Data:=wCircle;
                  end
                else wCircle.Free;
             end;
    ftMultiAngle : begin
                wMultiAng := TMyMultiAngleClass.Create('�������������');
                wMultiAng.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditMultiAngle.FMuliAngle:=wMultiAng;
                if FormEditMultiAngle.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wMultiAng.FigureName;
                    LI.Data:=wMultiAng;
                  end
                else wMultiAng.Free;
             end;
    ftSquare : begin
                wSquare := TMySquareClass.Create('�������',
                             MyPoint (20, 20), 100);
                wSquare.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditSquare.FSquare:=wSquare;
                if FormEditSquare.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wSquare.FigureName;
                    LI.Data:=wSquare;
                  end
                else wSquare.Free;
             end;
      else raise Exception.Create('�������� : ����������� ����� ������.')
  end;
  OnTransformateEventHandler(Self);
end;
procedure TFormMain.cbPaintTrianglesClick(Sender: TObject);
begin
  if cbPaintTriangles.Checked then DEBUG_BMP:=imgWin.Picture.Bitmap
    else DEBUG_BMP:=Nil;
end;

end.
