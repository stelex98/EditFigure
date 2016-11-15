//-------------------------------------------------------------------------
// Класс TMyLineClass - наследник TMyCustomPointClass
//        готовый к работе с фигурой "Линия"
//-------------------------------------------------------------------------
unit UnitLine;

interface
uses Windows, Types, Graphics, Classes,
     UnitBaseClass, UnitPoint;

type
  TMyLineClass = class (TMyPointClass)
  protected
    // Уникальные свойства фигуры (поля для хранения данных)
    FPointB : TMyPoint;
    // --Группа расчетов - необходимо перекрыть в потомках
    // Расчет Периметра
    function GetPerimetr : Double; override;
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
    property PointB : TMyPoint read FPointB write FPointB;
    constructor Create (aName : String; aPointA, aPointB : TMyPoint);
    // -- Отображение
    // Отрисовка фигуры в канве aCanvas
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
    // Расчет Центра Масс
function TMyLineClass.GetMassCenter : TMyPoint;
begin
  Result:=MyPoint((FPointA.X+FPointB.X)/2.0, (FPointA.Y+FPointB.Y)/2.0);
end;
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
procedure TMyLineClass.MoveMassCenter (aDelta : TMyPoint);
begin
  FPointA:=MovePoint(FPointA, aDelta);
  FPointB:=MovePoint(FPointB, aDelta);
  // Вызываем обработчик события "Фигура перемещена" (если определен)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // Вращение относительно точки с координатами aCenter
procedure TMyLineClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  FPointA:=RotatePoint (FPointA, aRotateCenter, aAngle);
  FPointB:=RotatePoint (FPointB, aRotateCenter, aAngle);
  // Вызываем обработчик события "Фигура повернута" (если определен)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // масштабирование относительно точки aCenter
procedure TMyLineClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
begin
  FPointA:=ScalePoint(FPointA, aScaleCenter, aKfX, aKfY);
  FPointB:=ScalePoint(FPointB, aScaleCenter, aKfX, aKfY);
  // Вызываем обработчик события "Фигура масштабирована" (если определен)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- Отображение
    // Отрисовка фигуры в канве aCanvas цветом aColor;
procedure TMyLineClass.Paint (aCanvas : TCanvas);
begin
  // Перемещаем перо в точку А 
  aCanvas.MoveTo(RoundMyPoint(FPointA).X, RoundMyPoint(FPointA).Y);
  // Рисуем линию до точки B
  aCanvas.LineTo(RoundMyPoint(FPointB).X, RoundMyPoint(FPointB).Y);
  // Вызываем обработчик события "Фигура отрисована" (если определен)
  if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
end;

end.

