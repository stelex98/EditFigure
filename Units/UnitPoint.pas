//-------------------------------------------------------------------------
// ����� TMyPointClass - ��������� T2DFigureBaseClass
//        ������ ��� TMyLineClass, TMySquareClass
//-------------------------------------------------------------------------
unit UnitPoint;

interface
uses Windows, Types, Graphics, Classes, UnitBaseClass;

type
  TMyPointClass = class (TMy2DFigureBaseClass)
  protected
    // ���� ���������� �����
    FPointA : TMyPoint;
    // --������ �������� - ���������� ��������� � ��������
    // ������ ���������
    function GetPerimetr : Double; override;
    // ������ �������
    function GetPloschad : Double; override;
    // ������ ������ ����
    function GetMassCenter : TMyPoint; override;
    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
    procedure MoveMassCenter (aDelta : TMyPoint); override;
    // �������� ������������ ����� � ������������ aCenter
    procedure Rotate (aRotateCenter : TMyPoint; aAngle : Double); override;
    // ��������������� ������������ ����� aCenter
    procedure Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double); override;
  public
    property PointA : TMyPoint read FPointA write FPointA;
    constructor Create (aName : String; aPointA : TMyPoint);
    // -- �����������
    // ��������� ������ � ����� aCanvas
    procedure Paint (aCanvas : TCanvas); override;
  end;

implementation
constructor TMyPointClass.Create (aName : String; aPointA : TMyPoint);
begin
  inherited Create (aName);
  PointA:=aPointA;
  FigureType:=ftPoint;
end;
function TMyPointClass.GetPerimetr : Double;
begin
  Result:=0.0;
end;
    // ������ �������
function TMyPointClass.GetPloschad : Double;
begin
  Result:=0.0;
end;
    // ������ ������ ����
function TMyPointClass.GetMassCenter : TMyPoint;
begin
  Result:=PointA;
end;
    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
procedure TMyPointClass.MoveMassCenter (aDelta : TMyPoint);
begin
  FPointA:=MovePoint(FPointA, aDelta);
  // �������� ���������� ������� "������ ����������" (���� ���������)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // �������� ������������ ����� � ������������ aCenter
procedure TMyPointClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  FPointA:=RotatePoint (FPointA, aRotateCenter, aAngle);
  // �������� ���������� ������� "������ ���������" (���� ���������)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // ��������������� ������������ ����� aCenter
procedure TMyPointClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
begin
  FPointA:=ScalePoint(FPointA, aScaleCenter, aKfX, aKfY);
  // �������� ���������� ������� "������ ��������������" (���� ���������)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- �����������
    // ��������� ������ � ����� aCanvas ������ aColor;
procedure TMyPointClass.Paint (aCanvas : TCanvas);
begin
  aCanvas.Pixels[RoundMyPoint(FPointA).X, RoundMyPoint(FPointA).Y]:=
    aCanvas.Pen.Color;
  // �������� ���������� ������� "������ ����������" (���� ���������)
  if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
end;

end.
