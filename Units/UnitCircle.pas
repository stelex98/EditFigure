//-------------------------------------------------------------------------
// Класс TMyCircleClass - наследник TMyCircleClass
//                      готовый к работе с фигурой "Круг"
//-------------------------------------------------------------------------
unit UnitCircle;

interface
uses Windows, Types, Graphics, Classes, UnitBaseClass;

type
  TMyCircleClass = class (TMy2DFigureBaseClass)
  private
    // Уникальные свойства фигуры (поля для хранения данных)
    FCenter : TMyPoint;    // Центр круга
    FRadius : Integer;     // Радиус
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
    procedure MoveMassCenter (aDelta : TMyPoint); override;
    // Вращение относительно точки с координатами aCenter
    procedure Rotate (aRotateCenter : TMyPoint; aAngle : Double); override;
    // масштабирование относительно точки aCenter
    procedure Scale (aScaleCenter : TMyPoint; aKfX, aKfY : Double); override;
    // -- Группа расчетов свойств
    // Расчет Периметра
    function GetPerimetr : Double; override;
    // Расчет Площади
    function GetPloschad : Double; override;
    // Расчет Центра Масс
    function GetMassCenter : TMyPoint; override;
  public
    property Center : TMyPoint read FCenter write FCenter;    // Центр круга
    property Radius : Integer read FRadius write FRadius;     // Радиус
    // Конструктор класса
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
    // Расчет Площади
function TMyCircleClass.GetPloschad : Double;
begin
  Result:=Pi*FRadius*FRadius;
end;
    // Расчет Центра Масс
function TMyCircleClass.GetMassCenter : TMyPoint;
begin
  Result:=FCenter;
end;
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
procedure TMyCircleClass.MoveMassCenter (aDelta : TMyPoint);
begin
  Center:=MovePoint(FCenter, aDelta);
  if Assigned (FOnFigireMovedEvent) then FOnFigireMovedEvent(Self);
end;
    // Вращение относительно точки с координатами aCenter
procedure TMyCircleClass.Rotate (aRotateCenter : TMyPoint; aAngle : Double);
begin
  Center:=RotatePoint (FCenter, aRotateCenter, aAngle);
  if Assigned (FOnFigireRotatedEvent) then FOnFigireRotatedEvent(Self);
end;

    // масштабирование относительно точки aCenter
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
