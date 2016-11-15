//-------------------------------------------------------------------------
// Класс TMyMultiAngleClass - наследник TMy2DFigureBaseClass
//                      готовый к работе с фигурой "Многоугольник"
//-------------------------------------------------------------------------
unit UnitMultiAngle;

interface
  uses Types, Graphics, Classes, UnitBaseClass;

// Многоугольник
type
  TMyMultiAngleClass = class (TMy2DFigureBaseClass)
  private
    FVertexCount : Integer;            // Количество вершин
    FVertexArr : TMyPolygonArray;      // Вершины
  protected
    function GetVertex (Index : Integer) : TMyPoint;
     // Удалить элемент из массива
     function DeleteVertex (aIndex : Integer; var aVertxArr : TMyPolygonArray): Boolean;
    // --Группа расчетов - необходимо перекрыть в потомках
    // Расчет Периметра
    function GetPerimetr : Double; override;
    // Расчет Площади 
    function GetPloschad : Double;  override;
    // Расчет Центра Масс
    function GetMassCenter : TMyPoint; override;
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
    procedure MoveMassCenter (aDelta : TMyPoint); override;
    // Вращение относительно точки с координатами aCenter
    procedure Rotate (aRotateCenter : TMyPoint; aAngle : Double); override;
    // масштабирование относительно точки aCenter
    procedure Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double); override;
  public
    property VertexCount : Integer read FVertexCount;
    property Vertex [Index : Integer] : TMyPoint read GetVertex;
    constructor Create (aName : String);
    destructor Destroy; override;
    // Добавить вершину в список
    function AddVertex (aPoint : TMyPoint): Integer;
    // Удалить вершину из списка
    function DelVertex (aIndex : Integer): Boolean;
    // Очистить весь список вершин
    procedure ClearVertex;
    // -- Отображение
    // Отрисовка фигуры в канве aCanvas
    procedure Paint (aCanvas : TCanvas); override;
    // Расчет центра масс многоугольника методом триангуляции
    function MassCenter3 : TMyPoint;
    // Расчет площади многоугольника методом триангуляции
    function Ploschad3 : Double;
  end;

implementation
uses SysUtils, Unit_Triangulate;

// Создание экземпляра
constructor TMyMultiAngleClass.Create (aName : String);
begin
  inherited Create (aName);
  FVertexCount:=0;
  SetLength(FVertexArr, 0);
  FFigureType:=ftMultiAngle;
end;
// Уничтожение экземпляра
destructor TMyMultiAngleClass.Destroy;
begin
  FVertexArr :=Nil;
  inherited;
end;

function TMyMultiAngleClass.GetVertex (Index : Integer) : TMyPoint;
begin
  if (Index<=High(FVertexArr)) and (Index>=Low(FVertexArr))
    then Result:=FVertexArr[Index]
    else raise Exception.Create('Запрос несуществующей вершины N '+IntToStr(Index));
end;
// Добавить вершину в список
function TMyMultiAngleClass.AddVertex (aPoint : TMyPoint): Integer;
begin
  inc (FVertexCount);
  SetLength (FVertexArr,FVertexCount);
  Result:=High(FVertexArr);
  FVertexArr[Result]:=aPoint;
end;
// Удалить элемента из массива с его укорачиванием
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
// Удалить вершину из списка
function TMyMultiAngleClass.DelVertex (aIndex : Integer): Boolean;
begin
  Result:=DeleteVertex(aIndex, FVertexArr);
end;
// Очистить список вершин
procedure TMyMultiAngleClass.ClearVertex;
begin
  SetLength(FVertexArr, 0);
  FVertexCount:=0;
end;
//--------------------------- Перекрытие методов предка -------------------
    // --Группа расчетов - необходимо перекрыть в потомках
    // Расчет Периметра
function TMyMultiAngleClass.GetPerimetr : Double;
var i, iH, iE : Integer;
begin
  iH:=Low (FVertexArr);
  iE:=High (FVertexArr);

  Result:=LineLength(FVertexArr[iH], FVertexArr[iE]);
  for i:=iH+1 to iE do
     Result:=Result+LineLength(FVertexArr[i], FVertexArr[i-1]);
end;
    // Расчет Площади
function TMyMultiAngleClass.GetPloschad : Double;
var i, iH, iE : Integer;
begin
  iH:=Low (FVertexArr);
  iE:=High (FVertexArr);
  // Расчет площади многоугольника - взято тз Инета, Вилипедия
  Result:=FVertexArr[iE].X*FVertexArr[iH].Y-
          FVertexArr[iE].Y*FVertexArr[iH].X;

  for i:=iH+1 to iE do
    Result:=Result+(FVertexArr[i-1].X*FVertexArr[i].Y-
                    FVertexArr[i-1].Y*FVertexArr[i].X);
  Result:=Abs(Result)/2.0;
end;
    // Расчет Центра Масс
function TMyMultiAngleClass.GetMassCenter : TMyPoint;
var A, Cx, Cy : Double;
    i, iH, iE : Integer;
begin
  // Расчет площади многоугольника - взято тз Инета, Вилипедия
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

    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
procedure TMyMultiAngleClass.MoveMassCenter (aDelta : TMyPoint);
var i : Integer;
begin
  for i:=Low (FVertexArr) to High (FVertexArr) do
    FVertexArr[i]:=MovePoint(FVertexArr[i], aDelta);
  // Вызываем обработчик события "Фигура перемещена" (если определен)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // Вращение относительно точки с координатами aRotateCenter
procedure TMyMultiAngleClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
var i : Integer;
begin
  for i:=Low (FVertexArr) to High (FVertexArr) do
    FVertexArr[i]:=RotatePoint(FVertexArr[i], aRotateCenter, aAngle);
  // Вызываем обработчик события "Фигура повернута" (если определен)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // масштабирование относительно точки aScaleCenter
procedure TMyMultiAngleClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
var i : Integer;
begin
  for i:=Low(FVertexArr) to High(FVertexArr) do
    FVertexArr[i]:=ScalePoint(FVertexArr[i], aScaleCenter, aKfX, aKfY);
  // Вызываем обработчик события "Фигура масштабирована" (если определен)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- Отображение
    // Отрисовка фигуры в канве aCanvas
procedure TMyMultiAngleClass.Paint (aCanvas : TCanvas);
var VA : Array of TPoint;
    i : Integer;
begin
  SetLength(VA, Length(FVertexArr));
  try
    for i:=Low(FVertexArr) to High(FVertexArr) do
      VA[i]:=RoundMyPoint(FVertexArr[i]);
    aCanvas.Polygon(VA);
    // Вызываем обработчик события "Фигура отрисована" (если определен)
    if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
  finally VA:=Nil; end;
end;


// Расчет центра масс многоугольника методом триангуляции
function TMyMultiAngleClass.MassCenter3 : TMyPoint;
begin
  Result:=CentrMass_By3 (FVertexArr);
end;

  // Расчет площади многоугольника методом триангуляции
function TMyMultiAngleClass.Ploschad3 : Double;
begin
  Result:=Ploschad_By3 (FVertexArr);
end;

end.
