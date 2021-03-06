//-------------------------------------------------------------------------
// ����� TMyCircleClass - ��������� TMyCircleClass
//                      ������� � ������ � ������� "����"
//-------------------------------------------------------------------------
unit UnitCircle;

interface
uses Windows, Types, Graphics, Classes, UnitBaseClass;

type
  TMyCircleClass = class (TMy2DFigureBaseClass)
  private
    // ���������� �������� ������ (���� ��� �������� ������)
    FCenter : TMyPoint;    // ����� �����
    FRadius : Integer;     // ������
    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
    procedure MoveMassCenter (aDelta : TMyPoint); override;
    // �������� ������������ ����� � ������������ aCenter
    procedure Rotate (aRotateCenter : TMyPoint; aAngle : Double); override;
    // ��������������� ������������ ����� aCenter
    procedure Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double); override;
    // -- ������ �������� �������
    // ������ ���������
    function GetPerimetr : Double; override;
    // ������ �������
    function GetPloschad : Double; override;
    // ������ ������ ����
    function GetMassCenter : TMyPoint; override;
  public
    property Center : TMyPoint read FCenter write FCenter;    // ����� �����
    property Radius : Integer read FRadius write FRadius;     // ������
    // ����������� ������
    constructor Create (aName : String; aCenter : TMyPoint; aRadius : Integer);
    procedure Paint (aCanvas : TCanvas); override;
  end;


implementation

constructor TMyCircleClass.Create (aName : String; aCenter : TMyPoint; aRadius : Integer);
begin
  inherited Create(aName);
  FFigureType:=ftCircle;
  FRadius:=aRadius;
  FCenter:=aCenter;
end;

function TMyCircleClass.GetPerimetr : Double;
begin
  Result:=2.0*Pi*FRadius;
end;
    // ������ �������
function TMyCircleClass.GetPloschad : Double;
begin
  Result:=Pi*FRadius*FRadius;
end;
    // ������ ������ ����
function TMyCircleClass.GetMassCenter : TMyPoint;
begin
  Result:=FCenter;
end;
    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
procedure TMyCircleClass.MoveMassCenter (aDelta : TMyPoint);
begin
  Center:=MovePoint(FCenter, aDelta);
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // �������� ������������ ����� � ������������ aCenter
procedure TMyCircleClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  Center:=RotatePoint (FCenter, aRotateCenter, aAngle);
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;

    // ��������������� ������������ ����� aCenter
procedure TMyCircleClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
begin
  FCenter:=ScalePoint(FCenter, aScaleCenter, aKfX, aKfY);
  FRadius:=Round(Radius*aKfX);
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;

procedure TMyCircleClass.Paint (aCanvas : TCanvas);
var CR : TRect;
begin
  CR.TopLeft:=RoundMyPoint(Center);    CR.BottomRight:=CR.TopLeft;
  CR.TopLeft.X:=CR.TopLeft.X-FRadius;
  CR.TopLeft.Y:=CR.TopLeft.Y-FRadius;
  CR.BottomRight.X:=CR.BottomRight.X+FRadius;
  CR.BottomRight.Y:=CR.BottomRight.Y+FRadius;
  aCanvas.Ellipse(CR);
  if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
end;


end.
