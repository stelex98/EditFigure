// -------------------------------------------------------------------------
// Базовый класс-предок для 2D-фигур
//--------------------------------------------------------------------------
unit UnitBaseClass;

interface

uses
  Dialogs,
  Windows, Types, Graphics, Classes;

type
  TFigureType = (ftNone, ftPoint, ftLine,
                 ftTriangle, ftRectangle, ftSquare, ftMultiAngle,
                 ftEllipse, ftCircle);

type
  // Вспомогательные типы для многоугоьника
  TMyPoint = Packed Record
    X,Y : Double;
  end;
  // Массив вершин многоугольника - ПО ЧАСОВОЙ СТРЕЛКЕ
  TMyPolygonArray = Array of TMyPoint;
(*
  // Треугольник
  TMyTriangleRec = Packed Record
    VertexA : TMyPoint;
    VertexB : TMyPoint;
    VertexC : TMyPoint;
  end;
  // Массив треугольников для триангуляций треугольников
  TMyTriangleArray = Array of TMyTriangleRec;
*)
  // Базовый класс 2D-фигур
  TMy2DFigureBaseClass = class
  protected
    // Поля для хранения данных и адресов процедур-обработчиков событий
    // Поле - Тип фигуры (определяет Экранную Форму для именения характеристик)
    FFigureType : TFigureType;
    // Поле - Наименование фигуры (Отображается в списке созданных Фигур-слоев)
    FFigureName : String;
    // ----------- События
    // Поле - Событие - фигура изменена (изменены параметры, смещена, повернута)
    FOnFigireChangedEvent : TNotifyEvent;
    // Поле - Событие - фигура перемещена
    FOnFigireMovedEvent : TNotifyEvent;
    // Поле - Событие - фигура повернута
    FOnFigireRotatedEvent : TNotifyEvent;
    // Поле - Событие - фигура масштабирована
    FOnFigireScaledEvent : TNotifyEvent;
    // Поле - Событие - фигура отрисована
    FOnFigirePaintedEvent : TNotifyEvent;
    
    // --Группа реализации свойств фигуры - необходимо перекрыть в потомках
    // Расчет Периметра
    function GetPerimetr : Double; virtual; abstract;
    // Расчет Площади
    function GetPloschad : Double; virtual; abstract;
    // Расчет Центра Масс
    function GetMassCenter : TMyPoint; virtual; abstract;

    // ----- Базовые процедуры работы с точками
    // Сдвиг точки aPoint на aDelta
    function MovePoint (aPoint, aDelta : TMyPoint): TMyPoint;
    // Масштабирование точки aPoint на aKX, aKY относительно точки aCenter
    function ScalePoint (aPoint, aCenter : TMyPoint; aKX, aKY : Double): TMyPoint;
    // Вращение точки aPoint на угол aAngle (радиан) относительно точки aCenter
    function RotatePoint (aPoint, aCenter : TMyPoint; aAngle : Double): TMyPoint;
    // -- Группа преобразований
    // Перемещение Центра Масс на смещение aDelta
    procedure MoveMassCenter (aDelta : TMyPoint); virtual; abstract;
    // Вращение относительно точки с координатами aRotateCenter на угол aAngle
    procedure Rotate (aRotateCenter : TMyPoint; aAngle : Double); virtual; abstract;
    // масштабирование относительно точки aCenter
    procedure Scale (aScaleCenter : TMyPoint; aKX, aKY : Double); virtual; abstract;
  public
    // Публичные свойства класса
    // Свойство : Тип фигуры - прямо связано с полем FFigureType
    property FigureType : TFigureType read FFigureType write FFigureType;
    // Свойство : Наименование фигуры - связано с полем FFigureName
    property FigureName : String read FFigureName write FFigureName;
    // Свойство : Площадь фигуры, только чтение, вычисляется в GetPloschad
    property Ploschad : Double read GetPloschad;
    // Свойство : Периметр фигуры, только чтение, вычисляется в GetPerimetr
    property Perimetr : Double read GetPerimetr;
    // Свойство : СентрМасс, только чтение, вычисляется в GetMassCenter
    property MassCenter : TMyPoint read GetMassCenter;
    // ----------- События
    // Свойство : Событие - фигура изменена (изменены параметры, смещена, повернута)
    property OnFigireChangedEvent : TNotifyEvent read FOnFigireChangedEvent write FOnFigireChangedEvent;
    // Свойство : Событие - фигура перемещена
    property OnFigireMovedEvent : TNotifyEvent read FOnFigireMovedEvent write FOnFigireMovedEvent;
    // Свойство : Событие - фигура повернута
    property OnFigireRotatedEvent : TNotifyEvent read FOnFigireRotatedEvent write FOnFigireRotatedEvent;
    // Свойство : Событие - фигура масштабирована
    property OnFigireScaledEvent : TNotifyEvent read FOnFigireScaledEvent write FOnFigireScaledEvent;
    // Свойство : Событие - фигура отрисована
    property OnFigirePaintedEvent : TNotifyEvent read FOnFigirePaintedEvent write FOnFigirePaintedEvent;

    // Конструктор
    constructor Create (aName : String);
    // ---- Рисование примитивов
    // Анимированная трансформация
    procedure Transformate (aDuration : Cardinal;   // Длительность трансформации
                            aSteps : Integer;       // Шагов выполнения
                            aNeedMuv : Boolean;     // Двигать?
                            aMovDelta : TMyPoint;     //   Перемещение - смещение
                            aNeedRotC : Boolean;    // Вращать вокруг цента?
                            aRotateCAngle : Double; //    Угол поворота
                            aNeedRotP : Boolean;    // Вращать вокруг точки ?
                            aRotateCenter : TMyPoint; //   Вращение - центр вращения
                            aRotateAngle : Double;  //   Вращение - угол
                            aNeedSclC : Boolean;    // Масштабировать относит центра ?
                            aScaleCKX, aScaleCKY : Double; // Масшт - коэффиценты
                            aNeedSclP : Boolean;    // Масштабировать относит точки ?
                            aScaleCenter : TMyPoint;  // Масшт - центр
                            aScaleKX, aScaleKY : Double // Масшт - коэффиценты
                            );
    // -- Отрисовка класса на чужой Canvas
    // Отрисовка фигуры в канве aCanvas
    procedure Paint (aCanvas : TCanvas); virtual; abstract;
  end;


// Вспомогательные процедуры
// Преобразование X Y в TMyPoint;
function MyPoint (aX,aY : Double): TMyPoint;
// Перевод Градусов в радианы (использует стандартный DegToRad из модуля Match)
function GradusToRadian (aGrad : Double) : Double;
// Преобразует TMyPoint в строку
function TMyPointToStr (aPoint : TMyPoint; const SeparatorStr : String =' ') : String;
// Преобразует строку в TMyPoint
function StrToTMyPoint (aStr : String; const Separator : Char =' '): TMyPoint;
// Длина линии между точками aPointA, aPointB
function LineLength (aPointA, aPointB : TMyPoint) : Double;
// Округление TMyPoint до стандартного TPoint
function RoundMyPoint(aPoint : TMyPoint): TPoint;

implementation
uses SysUtils, Math;
function MyPoint (aX,aY : Double): TMyPoint;
begin
   Result.X:=aX; Result.Y:=aY;
end;
function GradusToRadian (aGrad : Double) : Double;
begin
  Result:=DegToRad(aGrad);
end;
function TMyPointToStr (aPoint : TMyPoint; const SeparatorStr : String =' ') : String;
begin
  Result:=IntToStr(Round(aPoint.X))+SeparatorStr+IntToStr(Round(aPoint.Y));
end;
function StrToTMyPoint (aStr : String; const Separator : Char =' '): TMyPoint;
var k : Integer;
  X, Y : Double;
   ss : String;
begin
  Result:=MyPoint(0,0);
  aStr:=Trim(aStr);
  k:=Pos(Separator, aStr);
  if k<=0 then raise Exception.Create ('Неверный формат записи TMyPoint :'+aStr);
  ss:=aStr;
  System.Delete(aStr, k, Length(aStr)-k+1);
  System.Delete (ss, 1, k);
  X:=StrToFloat(Trim(aStr));
  Y:=StrToFloat(Trim(ss));
  Result:=MyPoint(X,Y);
end;
function LineLength (aPointA, aPointB : TMyPoint) : Double;
begin
  Result:=Sqrt (Sqr(aPointA.X-aPointB.X)+Sqr(aPointA.Y-aPointB.Y));
end;
// Округление TMyPoint до стандартного TPoint
function RoundMyPoint(aPoint : TMyPoint): TPoint;
begin
  Result.X:=Round(aPoint.X);
  Result.Y:=Round(aPoint.Y);
end;
// ========================= Реализация класса ==========================
constructor TMy2DFigureBaseClass.Create (aName : String);
begin
  inherited Create;
  // Инициализация полей
  FFigureName:=aName;
  FFigureType:=ftNone; // Для базового класса тип неопределен
  FOnFigireChangedEvent:=Nil;  // Обработчик события не задан
  FOnFigireMovedEvent :=Nil;   // Обработчик события не задан
  FOnFigireRotatedEvent :=Nil; // Обработчик события не задан
  FOnFigireScaledEvent :=Nil;  // Обработчик события не задан
  FOnFigirePaintedEvent :=Nil; // Обработчик события не задан
end;
// Реализация базовых процедур
// Смещение точки на aDelta
function TMy2DFigureBaseClass.MovePoint (aPoint, aDelta : TMyPoint): TMyPoint;
begin
  Result:=MyPoint(aPoint.X+aDelta.X, aPoint.Y+aDelta.Y);
end;
// Масштабирование точки относительно aCenter на коэффиценты aKX, aKY
function TMy2DFigureBaseClass.ScalePoint (aPoint, aCenter : TMyPoint; aKX, aKY : Double): TMyPoint;
begin
  Result:=MyPoint(aCenter.X+(aPoint.X-aCenter.X)*aKX, aCenter.Y+(aPoint.Y-aCenter.Y)*aKY);
end;
// Вращение точки относительно сентра aCenter на угол aAngle
function TMy2DFigureBaseClass.RotatePoint (aPoint, aCenter : TMyPoint; aAngle : Double): TMyPoint;
begin
  Result:=MyPoint(aCenter.X+(aPoint.X-aCenter.X)*Cos(aAngle)-(aPoint.Y-aCenter.Y)*Sin(aAngle),
                  aCenter.Y+(aPoint.X-aCenter.X)*Sin(aAngle)+(aPoint.Y-aCenter.Y)*Cos(aAngle));
end;


// Анимированная трансформация

procedure TMy2DFigureBaseClass.Transformate (aDuration : Cardinal;   // Длительность трансформации
                            aSteps : Integer;       // Шагов выполнения
                            aNeedMuv : Boolean;     // Двигать?
                            aMovDelta : TMyPoint;     //   Перемещение - смещение
                            aNeedRotC : Boolean;    // Вращать вокруг цента?
                            aRotateCAngle : Double; //    Угол поворота
                            aNeedRotP : Boolean;    // Вращать вокруг точки ?
                            aRotateCenter : TMyPoint; //   Вращение - центр вращения
                            aRotateAngle : Double;  //   Вращение - угол
                            aNeedSclC : Boolean;    // Масштабировать относит центра ?
                            aScaleCKX, aScaleCKY : Double; // Масшт - коэффиценты
                            aNeedSclP : Boolean;    // Масштабировать относит точки ?
                            aScaleCenter : TMyPoint;  //   Масшт - центр
                            aScaleKX, aScaleKY : Double //   Масшт - коэффиценты
                            );
var StartTick, OneStepFact, OneStepPlan : DWORD; //Показания таймера
    currStep, i  : Integer;               // Счетчик шагов
    dMP : TMyPoint;  // Смещение за 1 шаг
    wAngleP, wPKX, wPKY, wAngleC, wCKX, wCKY : Double;
    needMov, needRotateP, needRotateC, needScaleP, needScaleC : Boolean;
begin
  // По параметрам определяем что требуется
    needMov:=((aMovDelta.X<>0) or (aMovDelta.Y<>0)) and aNeedMuv;
    needRotateC:=(aRotateCAngle<>0.0) and aNeedRotC;
    needRotateP:=(aRotateAngle<>0.0) and aNeedRotP;
    needScaleC:=((aScaleCKX<>0) or (aScaleCKY<>0)) and (aNeedSclC);
    needScaleP:=((aScaleKX<>0) or (aScaleKY<>0)) and (aNeedSclP);

    if (not (needMov or needRotateP or needScaleP or
              needRotateC or needScaleC)) or (aSteps=0)  //Ничего ненадо
      then exit;
    if (aDuration=0) or (aSteps=1) //Анимация не требуется
    then
      begin
        if needMov then  MoveMassCenter (aMovDelta);
        if needRotateC then Rotate (GetMassCenter, aRotateCAngle);
        if needRotateP then Rotate (aRotateCenter, aRotateAngle);
        if needScaleC then Scale (GetMassCenter, aScaleCKX, aScaleCKY);
        if needScaleP then Scale (aScaleCenter, aScaleKX, aScaleKY);
        if Assigned (OnFigireChangedEvent) then OnFigireChangedEvent(Self);
      end
    else
      begin
        if needMov then //Если нужно перемещение
        begin
          dMP.X:=aMovDelta.X / aSteps;
          dMP.Y:=aMovDelta.Y / aSteps;
        end;

        if needRotateC then // Если нужно вращение
          wAngleC:=aRotateCAngle/aSteps; //Угол на 1 итерация
        if needRotateP then // Если нужно вращение
          wAngleP:=aRotateAngle/aSteps; //Угол на 1 итерация
        if needScaleC then // Если нужно масштабирование
        begin // Корень степени aSteps из KX и KY
          wCKX:=Exp(Ln(abs(aScaleCKX))/aSteps);
          wCKY:=Exp(Ln(abs(aScaleCKY))/aSteps);
        end;
        if needScaleP then // Если нужно масштабирование
        begin // Корень степени aSteps из KX и KY
          wPKX:=Exp(Ln(abs(aScaleKX))/aSteps);
          wPKY:=Exp(Ln(abs(aScaleKY))/aSteps);
        end;

// GetTickCount-Кол-во миилисек от включения ПК, переходит через нуль,
// если система будет запущена непрерывно в течение 49.7 дней.
        currStep:=0;
        // Планиреум на 1 итерацию OneStepPlan милисекунд
        OneStepPlan:=aDuration div aSteps; // Планируемо время 1 итерации
        while currStep<aSteps do
        begin
          //Запоминаме время начала итерации
          StartTick:=GetTickCount;
          // Изменяем фигуру...
          if needMov then MoveMassCenter (dMP);
          if needRotateC then Rotate (GetMassCenter, wAngleC);
          if needRotateP then Rotate (aRotateCenter, wAngleP);
          if needScaleC then Scale (GetMassCenter, wCKX, wCKY);
          if needScaleP then Scale (aScaleCenter, wPKX, wPKY);
          // Генерируем событие-извещение об изменениях
          if Assigned (OnFigireChangedEvent) then OnFigireChangedEvent(Self);
          //Рассчитываенм задержку до следующей итерации
          //Затрачено на выполнение итерации
          OneStepFact:=GetTickCount-StartTick;
          // Потратили меньше чем планировали - спим-ожидаем
          if OneStepPlan>OneStepFact
            then Sleep(OneStepPlan-OneStepFact);
          // переходим на следующий шаг
          inc (currStep);
        end;
      end;
end;


end.
