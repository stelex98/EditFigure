//-------------------------------------------------------------------------
// ����� TMySquareClass - ��������� TMyPointClass
//        ������� � ������ � ������� "�������"
//-------------------------------------------------------------------------
unit UnitSquare;

interface
  uses Types, Graphics, Classes, UnitBaseClass, UnitPoint;

// �������������
// ��������� - ������� ����� (����� ���� ����), ������, ������
type
  TMySquareClass = class (TMyPointClass)
  protected
    // ���� ��� �������� �������������� ��������� ������ (������ ������� �������)
    FPointB : TMyPoint;                       //  .A --.D
    FPointC : TMyPoint;                       //   |    |
    FPointD : TMyPoint;                       //  .B --.C
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
    // ������ ���������� �������� Side
    function GetSide : Integer;
    procedure SetSide (aSide : Integer) ;
    procedure SetPointA (aPoint : TMyPoint);
  public
    // ������� ���� Side ��� - ��� ����������� ��� ���������� ����� �����
    // ��������� �������. ��������� ���� �������������� ��������������
    // ����� ��������������� ������ ������������ ����� �
    property PointA read FPointA write SetPointA;

    property Side : Integer read GetSide write SetSide;
    constructor Create (aName : String; aVertexA : TMyPoint; aSide : Integer);
    procedure Paint (aCanvas : TCanvas); override;
    // ������ ������ ���� �������������� ������� ������������
    function MassCenter3 : TMyPoint;
    // ������ ������� �������������� ������� ������������
    function Ploschad3 : Double;
  end;


implementation
uses SysUtils, Unit_Triangulate;

// �������� ����������
constructor TMySquareClass.Create (aName : String; aVertexA : TMyPoint; aSide : Integer);
begin
  inherited Create (aName, aVertexA);
  FFigureType:=ftSquare;
(*
  FPointB:=aVertexA;   FPointB.X:=FPointB.X+aSide;
  FPointC:=FPointB;    FPointC.Y:=FPointC.Y+aSide;
  FPointD:=aVertexA;   FPointD.Y:=FPointD.Y+aSide;
*)
  FPointB:=aVertexA;   FPointB.Y:=FPointB.Y+aSide;
  FPointC:=FPointB;    FPointC.X:=FPointC.X+aSide;
  FPointD:=aVertexA;   FPointD.X:=FPointD.X+aSide;
end;
//
function TMySquareClass.GetSide : Integer;
begin
  Result:=Round(LineLength(FPointA, FPointB));
end;
// ��������� ����� ������� ����������� �������� = ��������������� ��� ����� �
procedure TMySquareClass.SetSide (aSide : Integer);
var kf : Double;
begin
  kf:=aSide/LineLength(FPointA, FPointB);
  FPointB:=ScalePoint (FPointB, FPointA, kf, kf);
  FPointC:=ScalePoint (FPointC, FPointA, kf, kf);
  FPointD:=ScalePoint (FPointD, FPointA, kf, kf);
end;
procedure TMySquareClass.SetPointA (aPoint : TMyPoint);
var dX, dY : Double;
begin
  dX:=aPoint.X-FPointA.X;   dY:=aPoint.Y-FPointA.Y;
  FpointB.X:=FPointB.X+dx;  FpointB.Y:=FPointB.Y+dy;
  FpointC.X:=FPointC.X+dx;  FpointC.Y:=FPointC.Y+dy;
  FpointD.X:=FPointD.X+dx;  FpointD.Y:=FPointD.Y+dy;
  FPointA:=aPoint;
end;

function TMySquareClass.GetPerimetr : Double;
begin
  Result:=LineLength(FPointA, FPointB)*4;
end;
    // ������ �������
function TMySquareClass.GetPloschad : Double;
begin
  Result:=Sqr(LineLength(FPointA, FPointB));
end;
    // ������ ������ ���� - �������� ���������
function TMySquareClass.GetMassCenter : TMyPoint;
begin
  Result:=MyPoint ((FPointA.X+FPointC.X)/2.0, (FPointA.Y+FPointC.Y)/2.0);
end;
    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
procedure TMySquareClass.MoveMassCenter (aDelta : TMyPoint);
begin
  FPointA:=MovePoint(FPointA, aDelta);
  FPointB:=MovePoint(FPointB, aDelta);
  FPointC:=MovePoint(FPointC, aDelta);
  FPointD:=MovePoint(FPointD, aDelta);
  // �������� ���������� ������� "������ ����������" (���� ���������)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // �������� ������������ ����� � ������������ aCenter
procedure TMySquareClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  FPointA:=RotatePoint (FPointA, aRotateCenter, aAngle);
  FPointB:=RotatePoint (FPointB, aRotateCenter, aAngle);
  FPointC:=RotatePoint (FPointC, aRotateCenter, aAngle);
  FPointD:=RotatePoint (FPointD, aRotateCenter, aAngle);
  // �������� ���������� ������� "������ ���������" (���� ���������)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // ��������������� ������������ ����� aCenter
procedure TMySquareClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
begin
  aKfY:=aKfX;
  FPointA:=ScalePoint(FPointA, aScaleCenter, aKfX, aKfY);
  FPointB:=ScalePoint(FPointB, aScaleCenter, aKfX, aKfY);
  FPointC:=ScalePoint(FPointC, aScaleCenter, aKfX, aKfY);
  FPointD:=ScalePoint(FPointD, aScaleCenter, aKfX, aKfY);
  // �������� ���������� ������� "������ ��������������" (���� ���������)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- �����������
    // ��������� ������ � ����� aCanvas ������ aColor;
procedure TMySquareClass.Paint (aCanvas : TCanvas);
var VA : Array of TPoint;
begin
  try
    SetLength(VA, 4);
    VA[0]:=RoundMyPoint(FPointA);
    VA[1]:=RoundMyPoint(FPointB);
    VA[2]:=RoundMyPoint(FPointC);
    VA[3]:=RoundMyPoint(FPointD);
    aCanvas.Polygon(VA);
    // �������� ���������� ������� "������ ����������" (���� ���������)
    if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
  finally VA:=Nil; end;  
end;


// ������ ������ ���� �������������� ������� ������������
function TMySquareClass.MassCenter3 : TMyPoint;
var VA : TMyPolygonArray;
begin
  SetLength(VA, 4);
  VA[0]:=FPointA;
  VA[1]:=FPointB;
  VA[2]:=FPointC;
  VA[3]:=FPointD;
  Result:=CentrMass_By3 (VA);
end;

  // ������ ������� �������������� ������� ������������
function TMySquareClass.Ploschad3 : Double;
var VA : TMyPolygonArray;
begin
  SetLength(VA, 4);
  VA[0]:=FPointA;
  VA[1]:=FPointB;
  VA[2]:=FPointC;
  VA[3]:=FPointD;
  Result:=Ploschad_By3 (VA);
end;

end.
