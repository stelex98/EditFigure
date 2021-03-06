unit Unit_Triangulate;
//
//�������� ������������:
//1. ����� ��� ������� A1, A2, A3
//2. ��������� �������� �� ������� A1A3, A1A2 � �� ��������� ������������ ����� ������ ��������.
//3. ��������� ��� �� ������ ������������ A1A2A3 �����-���� �� ���������� ������ ��������������.
//4. ���� ��� ������� �����������, �� ������ ����������� A1A2A3, � ������� A2 ��������� �� ��������������, 
//   �� ������ ������� A1, �������� ������� A2 (A2 �� A3), A3 (A3 �� A4)
//5. ���� ���� ���� ������� �� �����������, ��������� � ��������� ���� ��������.
//6. ��������� � 1 ����, ���� �� ��������� ��� �������.

interface
  uses Types, Graphics, 
       UnitBaseClass;

type
  // �����������
  TMyTriangleRec = Packed Record
    VertexA : TMyPoint;
    VertexB : TMyPoint;
    VertexC : TMyPoint;
  end;
  // ������ ������������� ��� ������������ �������������
  TMyTriangleArray = Array of TMyTriangleRec;


// �������� ������� - ������������ ��������������
function Triangulate (aVertexArr : TMyPolygonArray) : TMyTriangleArray;
// ������ ������ ���� �������������� ������� ������������
function CentrMass_By3 (aVertexArr : TMyPolygonArray) : TMyPoint;
// ������ ������� �������������� ������� ������������
function Ploschad_By3 (aVertexArr : TMyPolygonArray) : Double;

// ����� ���� ������������
function TriangleMassCenter (T : TMyTriangleRec) : TMyPoint;
// ������� �����������
function TrianglePloschad (T : TMyTriangleRec) : Double;

// ���������� �������� ��� ��������� ��������� ������������ (�������������)
var DEBUG_BMP : TBitMap = Nil;

implementation
uses SysUtils;

// ����� ���� ������������
function TriangleMassCenter (T : TMyTriangleRec) : TMyPoint;
begin
  // �������������������� ���������
  Result.X:=(T.VertexA.X+T.VertexB.X+T.VertexC.X)/3.0;
  Result.Y:=(T.VertexA.Y+T.VertexB.Y+T.VertexC.Y)/3.0;
end;
// ������� �����������
function TrianglePloschad (T : TMyTriangleRec) : Double;
begin
  Result:=Abs(((T.VertexA.X-T.VertexC.X)*(T.VertexB.Y-T.VertexC.Y)-
           (T.VertexB.X-T.VertexC.X)*(T.VertexA.Y-T.VertexC.Y))) /2.0;
end;

// ��������������� ��������� � ������� ������������
// ��������� ���������
function VectMul(p1, p2, p3: TMyPoint): Double;
begin
  Result := (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);
end;
// ����� ����� ������ ������������
function PointInTriangle (p, p1, p2, p3: TMyPoint): Boolean;
begin
  Result:=((VectMul(p1,p2,p)>0) and
           (VectMul(p2,p3,p)>0) and
           (VectMul(p3,p1,p)>0))    OR
          ((VectMul(p1,p2,p)<0) and
           (VectMul(p2,p3,p)<0) and
           (VectMul(p3,p1,p)<0));
end;
// ������ �������� - �����
function IsLeft3Vectors (p1, p2, p3: TMyPoint) : Boolean;
begin
  Result :=VectMul(p1,p2,p3)<0.0;
end;
// ����� ������������ - ���������� ������ ������ ����� ���� ����������� ������
function FindTriangle (aPolyG : TMyPolygonArray) : Integer;
var IsOkTriangle : Boolean;
    i, j : Integer;
begin
  Result:=-1;
  // ���������� �������
  for i:=Low(aPolyG) to High(aPolyG)-2 do 
  begin
    if IsLeft3Vectors (aPolyG[i],aPolyG[i+1],aPolyG[i+2]) then
    begin     // ��� ����� ������ - ����� ����������
      IsOkTriangle:=True;
      // �������� �� ����������� ��������� ����� � ���� ����������
      for j:=i+2 to High(aPolyG) do
        if PointInTriangle (aPolyG[j], aPolyG[i],aPolyG[i+1],aPolyG[i+2])
          then // � ����������� ���� ������ ������� ��������������
            begin IsOkTriangle:=False; break; end; // �� ��������
      if IsOkTriangle then begin Result:=i+1; exit; end;
    end;
  end;
end;
// �������� ����������� � ������ ���������
function AddTriangle (aV1,aV2,aV3 : TMyPoint; var aTA : TMyTriangleArray): Integer;
begin
  // ��������� ������ �������������
  SetLength(aTA, Length(aTA)+1);
  Result:=High(aTA);
  // �������� ������ ������
  aTA[Result].VertexA:=aV1;
  aTA[Result].VertexB:=aV2;
  aTA[Result].VertexC:=aV3;
end;
// ������� ������� �� �������������� (����� ����� ������� ����������� ������������)
function DeleteVertex (aIndex : Integer; var aVertxArr : TMyPolygonArray): Boolean;
var i : Integer;
begin
  Result:=(aIndex>=Low(aVertxArr)) and (aIndex<=High(aVertxArr));
  if Result then
  begin
    // �������� ����� ������� � ������
    for i:=aIndex to High(aVertxArr)-1 do
      aVertxArr[i]:=aVertxArr[i+1];
    // ����������� ������
    SetLength(aVertxArr, Length(aVertxArr)-1);
  end;
end;
// ��������������� ��������� - ��������� ���� �������
function RandomColor: TColor;
begin
  //           Red              Green                 Blue
  Result := (Random(256) or (Random(256) shl 8) or (Random(256) shl 16));
end;
// ��������� 1 ������������ � DEBUG_BMP
procedure Paint3 (T : TMyTriangleRec);
var PT : Array of TPoint;
    cc, cn : TColor;
begin
  SetLength(PT,3);

  // ����������� ���������� � ����� TPoint
  PT[0]:=RoundMyPoint(T.VertexA);
  PT[1]:=RoundMyPoint(T.VertexB);
  PT[2]:=RoundMyPoint(T.VertexC);
  // ������ �������-�����������
  DEBUG_BMP.Canvas.Polygon(PT);
  // ��������� ������� ���� �����
  cc:=DEBUG_BMP.Canvas.Brush.Color;
  DEBUG_BMP.Canvas.Brush.Style:=bsSolid;
  // ������� �� ���������
  DEBUG_BMP.Canvas.Brush.Color:=RandomColor;
  // ��������� ������ � ������� ������ ����� ���� ������������
  // �� ������� ����� DEBUG_BMP.Canvas.Pen.Color (����)
  // ������� ������������) ��������� ������
  DEBUG_BMP.Canvas.FloodFill((PT[0].X+PT[1].X+PT[2].X) div 3,
                    (PT[0].Y+PT[1].Y+PT[2].Y) div 3,
                     DEBUG_BMP.Canvas.Pen.Color, fsBorder);
  // ��������������� ������������ ���� �����
  DEBUG_BMP.Canvas.Brush.Color:=cc;
end;
// ��������� ������� �������������
procedure PaintTriangles (A : TMyTriangleArray);
var i : Integer;
begin
  for i:=0 to Length(A)-1 do
    paint3 (A[i]);
end;

// �������� ������� - ������������ ��������������
function Triangulate (aVertexArr : TMyPolygonArray) : TMyTriangleArray;
var WorkArr : TMyPolygonArray;
       i, k : Integer;
    AllDone : Boolean;
begin
  // ��������� ������������� ��� ������ � WorkArr
  AllDone:=False;
  SetLength(Result, 0);
  SetLength (WorkArr, Length(aVertexArr));
  try
    WorkArr:=Copy(aVertexArr);
    while Length(WorkArr)>3 do // ���� � �������������� >3 ������
    begin
      k:=FindTriangle (WorkArr); //���� �����������
      if k<0 then exit; //�� ����� - ������ - �����
      AddTriangle (WorkArr[k-1], WorkArr[k], WorkArr[k+1], Result);
      DeleteVertex (k, WorkArr);
    end;
    // ��������� ��������� ���������� �����������
    AddTriangle (WorkArr[0], WorkArr[1], WorkArr[2], Result);

    // ���� ������ BMP - ������������ ������ �������������
    if Assigned (DEBUG_BMP) then  PaintTriangles(Result);

    AllDone:=True;
  finally
    if not AllDone then SetLength(Result, 0);
    WorkArr:=Nil;
  end;
end;

// ������ ������ ���� �������������� ������� ������������
function CentrMass_By3 (aVertexArr : TMyPolygonArray) : TMyPoint;
var TA : TMyTriangleArray;
     i : Integer;
     wC, wC1, wC2 : TMyPoint;
     wV : TMyPolygonArray;
begin
  Result.X:=0; Result.Y:=0;
  // ������������� �������������
  TA:=Triangulate (aVertexArr);

  if Length(TA)=0 then
    raise Exception.Create ('����� ���� - ������ ������������');
  try
    // ���� ���� - ��.�������������� ��������� ������� ���� �������������
    for i:=Low(TA) to High(TA) do
    begin
      wC:=TriangleMassCenter (TA[i]);
      Result.X:=Result.X+wC.X;
      Result.Y:=Result.Y+wC.Y;
    end;
    Result.X:=Result.X/Length(TA);
    Result.Y:=Result.Y/Length(TA);
(*
    // ������������ �������������� ������� ����
    if Length(TA)=1
      then Result:=TriangleMassCenter (TA[0]); 
      else
      begin
        SetLength(wV, Length(TA));
        for i:=Low(TA) to High(TA) do
          wV[i]:=TriangleMassCenter (TA[i]);
        Result:=CentrMass_By3(wV);
      end;
*)      
  finally
    TA:=Nil;
    wV:=Nil;
  end;
end;

// ������ ������� �������������� ������� ������������
function Ploschad_By3 (aVertexArr : TMyPolygonArray) : Double;
var TA : TMyTriangleArray;
     i : Integer;
begin
  Result:=0.0;
  // ������������� �������������
  TA:=Triangulate (aVertexArr);
  if Length(TA)=0 then
    raise Exception.Create ('������� - ������ ������������');
  try
    // ��������� ������� �������������
    for i:=Low(TA) to High(TA) do
      Result:=Result+TrianglePloschad(TA[i]);
  finally
    TA:=Nil;
  end;
end;

end.
