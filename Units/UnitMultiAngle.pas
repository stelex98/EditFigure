//-------------------------------------------------------------------------
// ����� TMyMultiAngleClass - ��������� TMy2DFigureBaseClass
//                      ������� � ������ � ������� "�������������"
//-------------------------------------------------------------------------
unit UnitMultiAngle;

interface
  uses Types, Graphics, Classes, UnitBaseClass;

// �������������
type
  TMyMultiAngleClass = class (TMy2DFigureBaseClass)
  private
    FVertexCount : Integer;            // ���������� ������
    FVertexArr : TMyPolygonArray;      // �������
  protected
    function GetVertex (Index : Integer) : TMyPoint;
     // ������� ������� �� �������
     function DeleteVertex (aIndex : Integer; var aVertxArr : TMyPolygonArray): Boolean;
    // --������ �������� - ���������� ��������� � ��������
    // ������ ���������
    function GetPerimetr : Double; override;
    // ������ ������� 
    function GetPloschad : Double;  override;
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
    property VertexCount : Integer read FVertexCount;
    property Vertex [Index : Integer] : TMyPoint read GetVertex;
    constructor Create (aName : String);
    destructor Destroy; override;
    // �������� ������� � ������
    function AddVertex (aPoint : TMyPoint): Integer;
    // ������� ������� �� ������
    function DelVertex (aIndex : Integer): Boolean;
    // �������� ���� ������ ������
    procedure ClearVertex;
    // -- �����������
    // ��������� ������ � ����� aCanvas
    procedure Paint (aCanvas : TCanvas); override;
    // ������ ������ ���� �������������� ������� ������������
    function MassCenter3 : TMyPoint;
    // ������ ������� �������������� ������� ������������
    function Ploschad3 : Double;
  end;

implementation
uses SysUtils, Unit_Triangulate;

// �������� ����������
constructor TMyMultiAngleClass.Create (aName : String);
begin
  inherited Create (aName);
  FVertexCount:=0;
  SetLength(FVertexArr, 0);
  FFigureType:=ftMultiAngle;
end;
// ����������� ����������
destructor TMyMultiAngleClass.Destroy;
begin
  FVertexArr :=Nil;
  inherited;
end;

function TMyMultiAngleClass.GetVertex (Index : Integer) : TMyPoint;
begin
  if (Index<=High(FVertexArr)) and (Index>=Low(FVertexArr))
    then Result:=FVertexArr[Index]
    else raise Exception.Create('������ �������������� ������� N '+IntToStr(Index));
end;
// �������� ������� � ������
function TMyMultiAngleClass.AddVertex (aPoint : TMyPoint): Integer;
begin
  inc (FVertexCount);
  SetLength (FVertexArr,FVertexCount);
  Result:=High(FVertexArr);
  FVertexArr[Result]:=aPoint;
end;
// ������� �������� �� ������� � ��� �������������
function TMyMultiAngleClass.DeleteVertex (aIndex : Integer; var aVertxArr : TMyPolygonArray): Boolean;
var i : Integer;
begin
  Result:=(aIndex>=Low(FVertexArr)) and (aIndex<=High(FVertexArr));
  if Result then
  begin
    for i:=aIndex to High(aVertxArr)-1 do
      aVertxArr[i]:=aVertxArr[i+1];
    SetLength(aVertxArr, Length(aVertxArr)-1);
  end;
end;
// ������� ������� �� ������
function TMyMultiAngleClass.DelVertex (aIndex : Integer): Boolean;
begin
  Result:=DeleteVertex(aIndex, FVertexArr);
end;
// �������� ������ ������
procedure TMyMultiAngleClass.ClearVertex;
begin
  SetLength(FVertexArr, 0);
  FVertexCount:=0;
end;
//--------------------------- ���������� ������� ������ -------------------
    // --������ �������� - ���������� ��������� � ��������
    // ������ ���������
function TMyMultiAngleClass.GetPerimetr : Double;
var i, iH, iE : Integer;
begin
  iH:=Low (FVertexArr);
  iE:=High (FVertexArr);

  Result:=LineLength(FVertexArr[iH], FVertexArr[iE]);
  for i:=iH+1 to iE do
     Result:=Result+LineLength(FVertexArr[i], FVertexArr[i-1]);
end;
    // ������ �������
function TMyMultiAngleClass.GetPloschad : Double;
var i, iH, iE : Integer;
begin
  iH:=Low (FVertexArr);
  iE:=High (FVertexArr);
  // ������ ������� �������������� - ����� �� �����, ���������
  Result:=FVertexArr[iE].X*FVertexArr[iH].Y-
          FVertexArr[iE].Y*FVertexArr[iH].X;

  for i:=iH+1 to iE do
    Result:=Result+(FVertexArr[i-1].X*FVertexArr[i].Y-
                    FVertexArr[i-1].Y*FVertexArr[i].X);
  Result:=Abs(Result)/2.0;
end;
    // ������ ������ ����
function TMyMultiAngleClass.GetMassCenter : TMyPoint;
var A, Cx, Cy : Double;
    i, iH, iE : Integer;
begin
  // ������ ������� �������������� - ����� �� �����, ���������
  iH:=Low(FVertexArr);
  iE:=High(FVertexArr);

  A:=FVertexArr[iE].X*FVertexArr[iH].Y-FVertexArr[iH].X*FVertexArr[iE].Y;
  for i:=iH to iE-1 do
    A:=A+FVertexArr[i].X*FVertexArr[i+1].Y-FVertexArr[i+1].X*FVertexArr[i].Y;
  A:=A/2.0;
  Cx:=(FVertexArr[iE].X+FVertexArr[iH].X)*
        (FVertexArr[iE].X*FVertexArr[iH].Y-FVertexArr[iH].X*FVertexArr[iE].Y);
  for i:=iH to iE-1 do
    Cx:=Cx+(FVertexArr[i].X+FVertexArr[i+1].X)*
           (FVertexArr[i].X*FVertexArr[i+1].Y-FVertexArr[i+1].X*FVertexArr[i].Y);
  Cx:=Cx/6./A;
  Cy:=(FVertexArr[iE].Y+FVertexArr[iH].Y)*
        (FVertexArr[iE].X*FVertexArr[iH].Y-FVertexArr[iH].X*FVertexArr[iE].Y);
  for i:=iH to iE-1 do
    Cy:=Cy+(FVertexArr[i].Y+FVertexArr[i+1].Y)*
           (FVertexArr[i].X*FVertexArr[i+1].Y-FVertexArr[i+1].X*FVertexArr[i].Y);
  Cy:=Cy/6./A;
  Result.X:=Cx;
  Result.Y:=Cy;
end;

    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
procedure TMyMultiAngleClass.MoveMassCenter (aDelta : TMyPoint);
var i : Integer;
begin
  for i:=Low (FVertexArr) to High (FVertexArr) do
    FVertexArr[i]:=MovePoint(FVertexArr[i], aDelta);
  // �������� ���������� ������� "������ ����������" (���� ���������)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // �������� ������������ ����� � ������������ aRotateCenter
procedure TMyMultiAngleClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
var i : Integer;
begin
  for i:=Low (FVertexArr) to High (FVertexArr) do
    FVertexArr[i]:=RotatePoint(FVertexArr[i], aRotateCenter, aAngle);
  // �������� ���������� ������� "������ ���������" (���� ���������)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // ��������������� ������������ ����� aScaleCenter
procedure TMyMultiAngleClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
var i : Integer;
begin
  for i:=Low(FVertexArr) to High(FVertexArr) do
    FVertexArr[i]:=ScalePoint(FVertexArr[i], aScaleCenter, aKfX, aKfY);
  // �������� ���������� ������� "������ ��������������" (���� ���������)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- �����������
    // ��������� ������ � ����� aCanvas
procedure TMyMultiAngleClass.Paint (aCanvas : TCanvas);
var VA : Array of TPoint;
    i : Integer;
begin
  SetLength(VA, Length(FVertexArr));
  try
    for i:=Low(FVertexArr) to High(FVertexArr) do
      VA[i]:=RoundMyPoint(FVertexArr[i]);
    aCanvas.Polygon(VA);
    // �������� ���������� ������� "������ ����������" (���� ���������)
    if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
  finally VA:=Nil; end;
end;


// ������ ������ ���� �������������� ������� ������������
function TMyMultiAngleClass.MassCenter3 : TMyPoint;
begin
  Result:=CentrMass_By3 (FVertexArr);
end;

  // ������ ������� �������������� ������� ������������
function TMyMultiAngleClass.Ploschad3 : Double;
begin
  Result:=Ploschad_By3 (FVertexArr);
end;

end.
