//-------------------------------------------------------------------------
// Класс TMyPointClass - наследник T2DFigureBaseClass
//        предок для TMyLineClass, TMySquareClass
//-------------------------------------------------------------------------
unit UnitPoint;

interface
uses Windows, Types, Graphics, Classes, UnitBaseClass;

type
  TMyPointClass = class (TMy2DFigureBaseClass)
  protected
    // Поле координаты точки
    FPointA : TMyPoint;
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
  public
    property PointA : TMyPoint read FPointA write FPointA;
    constructor Create (aName : String; aPointA : TMyPoint);
    // -- Отображение
    // Отрисовка фигуры в канве aCanvas
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
    // Расчет Площади
function TMyPointClass.GetPloschad : Double;
begin
  Result:=0.0;
end;
    // Расчет Центра Масс
function TMyPointClass.GetMassCenter : TMyPoint;
begin
  Result:=PointA;
end;
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
procedure TMyPointClass.MoveMassCenter (aDelta : TMyPoint);
begin
  FPointA:=MovePoint(FPointA, aDelta);
  // Вызываем обработчик события "Фигура перемещена" (если определен)
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // Вращение относительно точки с координатами aCenter
procedure TMyPointClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  FPointA:=RotatePoint (FPointA, aRotateCenter, aAngle);
  // Вызываем обработчик события "Фигура повернута" (если определен)
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;
    // масштабирование относительно точки aCenter
procedure TMyPointClass.Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double);
begin
  FPointA:=ScalePoint(FPointA, aScaleCenter, aKfX, aKfY);
  // Вызываем обработчик события "Фигура масштабирована" (если определен)
  if Assigned (FOnFigireScaledEvent) then FOnFigireScaledEvent(Self);
end;
    // -- Отображение
    // Отрисовка фигуры в канве aCanvas цветом aColor;
procedure TMyPointClass.Paint (aCanvas : TCanvas);
begin
  aCanvas.Pixels[RoundMyPoint(FPointA).X, RoundMyPoint(FPointA).Y]:=
    aCanvas.Pen.Color;
  // Вызываем обработчик события "Фигура отрисована" (если определен)
  if Assigned (FOnFigirePaintedEvent) then FOnFigirePaintedEvent(Self);
end;

end.
