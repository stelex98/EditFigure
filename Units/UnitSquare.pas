//-------------------------------------------------------------------------
// Класс TMySquareClass - наследник TMyPointClass
//        готовый к работе с фигурой "Квадрат"
//-------------------------------------------------------------------------
unit UnitSquare;

interface
  uses Types, Graphics, Classes, UnitBaseClass, UnitPoint;

// Прямоугольник
// Параметры - Опорная точка (верхн левы угол), ширина, высота
type
  TMySquareClass = class (TMyPointClass)
  protected
    // Поля для хранения дополнительных координат вершин (ПРОТИВ часовой стрелки)
    FPointB : TMyPoint;                       //  .A --.D
    FPointC : TMyPoint;                       //   |    |
    FPointD : TMyPoint;                       //  .B --.C
    // --Группа расчетов - необходимо перекрыть в потомках
    // Расчет Периметра
    function GetPerimetr : Double; override;
    // Расчет Площади
    function GetPloschad : Double; override;
    // Расчет Центра Масс
    function GetMassCenter : TMyPoint; override;
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
    procedure MoveMassCenter (aDelta : TMyPoint); override;
    // Вращение относительно точки с координатами aCenter
    procedure Rotate (aRotateCenter : TMyPoint; aAngle : Double); override;
    // масштабирование относительно точки aCenter
    procedure Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double); override;
    // Методы реализации свойства Side
    function GetSide : Integer;
    procedure SetSide (aSide : Integer) ;
    procedure SetPointA (aPoint : TMyPoint);
  public
    // Реально поля Side нет - оно вычисляется как расстояние между двумя
    // соседними точками. Изменение этой характеристики осуществляется
    // через масштабирование фигуры относительно точки А
    property PointA read FPointA write SetPointA;

    property Side : Integer read GetSide write SetSide;
    constructor Create (aName : String; aVertexA : TMyPoint; aSide : Integer);
    procedure Paint (aCanvas : TCanvas); override;
    // Расчет центра масс многоугольника методом триангуляции
    function MassCenter3 : TMyPoint;
    // Расчет площади многоугольника методом триангуляции
    function Ploschad3 : Double;
  end;


implementation
uses SysUtils, Unit_Triangulate;

// Создание экземпляра
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
// Измененеи длины стороны повернутого квадрата = масштабирование отн точки А
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
    // Расчет Площади
function TMySquareClass.GetPloschad : Double;
begin
  Result:=Sqr(LineLength(FPointA, FPointB));
end;
    // Расчет Центра Масс - середина диагонали
function TMySquareClass.GetMassCenter : TMyPoint;
begin
  Result:=MyPoint ((FPointA.X+FPointC.X)/2.0, (FPointA.Y+FPointC.Y)/2.0);
end;
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
procedure TMySquareClass.MoveMassCenter (aDelta : TMyPoint);
begin
  FPointA:=MovePoint(FPointA, aDelta);
  FPointB:=MovePoint(FPointB, aDelta);
  FPointC:=MovePoint(FPointC, aDelta);
  FPointD:=MovePoint(FPointD, aDelta);
  // Вызываем обработчик события "Фигура перемещена" (если определен)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // Вращение относительно точки с координатами aCenter
procedure TMySquareClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  FPointA:=RotatePoint (FPointA, aRotateCenter, aAngle);
  FPointB:=RotatePoint (FPointB, aRotateCenter, aAngle);
  FPointC:=RotatePoint (FPointC, aRotateCenter, aAngle);
  FPointD:=RotatePoint (FPointD, aRotateCenter, aAngle);
  // Вызываем обработчик события "Фигура повернута" (если определен)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // масштабирование относительно точки aCenter
procedure TMySquareClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
begin
  aKfY:=aKfX;
  FPointA:=ScalePoint(FPointA, aScaleCenter, aKfX, aKfY);
  FPointB:=ScalePoint(FPointB, aScaleCenter, aKfX, aKfY);
  FPointC:=ScalePoint(FPointC, aScaleCenter, aKfX, aKfY);
  FPointD:=ScalePoint(FPointD, aScaleCenter, aKfX, aKfY);
  // Вызываем обработчик события "Фигура масштабирована" (если определен)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- Отображение
    // Отрисовка фигуры в канве aCanvas цветом aColor;
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
    // Вызываем обработчик события "Фигура отрисована" (если определен)
    if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
  finally VA:=Nil; end;  
end;


// Расчет центра масс многоугольника методом триангуляции
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

  // Расчет площади многоугольника методом триангуляции
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
