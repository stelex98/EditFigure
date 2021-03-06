//-------------------------------------------------------------------------
// ����� TMyLineClass - ��������� TMyCustomPointClass
//        ������� � ������ � ������� "�����"
//-------------------------------------------------------------------------
unit UnitLine;

interface
uses Windows, Types, Graphics, Classes,
     UnitBaseClass, UnitPoint;

type
  TMyLineClass = class (TMyPointClass)
  protected
    // ���������� �������� ������ (���� ��� �������� ������)
    FPointB : TMyPoint;
    // --������ �������� - ���������� ��������� � ��������
    // ������ ���������
    function GetPerimetr : Double; override;
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
    property PointB : TMyPoint read FPointB write FPointB;
    constructor Create (aName : String; aPointA, aPointB : TMyPoint);
    // -- �����������
    // ��������� ������ � ����� aCanvas
    procedure Paint (aCanvas : TCanvas); override;
  end;

implementation

constructor TMyLineClass.Create (aName : String; aPointA, aPointB : TMyPoint);
begin
  inherited Create (aName, aPointA);
  FPointB:=aPointB;
  FFigureType:=ftLine;
end;
function TMyLineClass.GetPerimetr : Double;
begin
  Result:=LineLength(FPointA, FPointB);
end;
    // ������ ������ ����
function TMyLineClass.GetMassCenter : TMyPoint;
begin
  Result:=MyPoint((FPointA.X+FPointB.X)/2.0, (FPointA.Y+FPointB.Y)/2.0);
end;
    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
procedure TMyLineClass.MoveMassCenter (aDelta : TMyPoint);
begin
  FPointA:=MovePoint(FPointA, aDelta);
  FPointB:=MovePoint(FPointB, aDelta);
  // �������� ���������� ������� "������ ����������" (���� ���������)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // �������� ������������ ����� � ������������ aCenter
procedure TMyLineClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  FPointA:=RotatePoint (FPointA, aRotateCenter, aAngle);
  FPointB:=RotatePoint (FPointB, aRotateCenter, aAngle);
  // �������� ���������� ������� "������ ���������" (���� ���������)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // ��������������� ������������ ����� aCenter
procedure TMyLineClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
begin
  FPointA:=ScalePoint(FPointA, aScaleCenter, aKfX, aKfY);
  FPointB:=ScalePoint(FPointB, aScaleCenter, aKfX, aKfY);
  // �������� ���������� ������� "������ ��������������" (���� ���������)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- �����������
    // ��������� ������ � ����� aCanvas ������ aColor;
procedure TMyLineClass.Paint (aCanvas : TCanvas);
begin
  // ���������� ���� � ����� � 
  aCanvas.MoveTo(RoundMyPoint(FPointA).X, RoundMyPoint(FPointA).Y);
  // ������ ����� �� ����� B
  aCanvas.LineTo(RoundMyPoint(FPointB).X, RoundMyPoint(FPointB).Y);
  // �������� ���������� ������� "������ ����������" (���� ���������)
  if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
end;

end.

