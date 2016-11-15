unit Unit_Triangulate;
//
//Алгоритм триангуляции:
//1. Берем три вершины A1, A2, A3
//2. Проверяем образуют ли вектора A1A3, A1A2 и их векторное произведение левую тройку векторов.
//3. Проверяем нет ли внутри треугольника A1A2A3 какой-либо из оставшихся вершин многоугольника.
//4. Если оба условия выполняются, то строим треугольник A1A2A3, а вершину A2 исключаем из многоугольника, 
//   не трогая вершину A1, сдвигаем вершины A2 (A2 на A3), A3 (A3 на A4)
//5. Если хоть одно условие не выполняется, переходим к следующим трем вершинам.
//6. Повторяем с 1 шага, пока не останется три вершины.

interface
  uses Types, Graphics, 
       UnitBaseClass;

type
  // Треугольник
  TMyTriangleRec = Packed Record
    VertexA : TMyPoint;
    VertexB : TMyPoint;
    VertexC : TMyPoint;
  end;
  // Массив треугольников для триангуляций треугольников
  TMyTriangleArray = Array of TMyTriangleRec;


// Основная функция - триангуляция многоугольника
function Triangulate (aVertexArr : TMyPolygonArray) : TMyTriangleArray;
// Расчет центра масс многоугольника методом триангуляции
function CentrMass_By3 (aVertexArr : TMyPolygonArray) : TMyPoint;
// Расчет площади многоугольника методом триангуляции
function Ploschad_By3 (aVertexArr : TMyPolygonArray) : Double;

// Центр масс треугольника
function TriangleMassCenter (T : TMyTriangleRec) : TMyPoint;
// Площадь треуголинка
function TrianglePloschad (T : TMyTriangleRec) : Double;

// Отладочная картинка для отрисовки пезултата триангуляции (трецгольников)
var DEBUG_BMP : TBitMap = Nil;

implementation
uses SysUtils;

// Центр масс треугольника
function TriangleMassCenter (T : TMyTriangleRec) : TMyPoint;
begin
  // Среднеарифметическое координат
  Result.X:=(T.VertexA.X+T.VertexB.X+T.VertexC.X)/3.0;
  Result.Y:=(T.VertexA.Y+T.VertexB.Y+T.VertexC.Y)/3.0;
end;
// Площадь треуголинка
function TrianglePloschad (T : TMyTriangleRec) : Double;
begin
  Result:=Abs(((T.VertexA.X-T.VertexC.X)*(T.VertexB.Y-T.VertexC.Y)-
           (T.VertexB.X-T.VertexC.X)*(T.VertexA.Y-T.VertexC.Y))) /2.0;
end;

// Вспомогательные процедуры и функции триангуляции
// Векторное умножение
function VectMul(p1, p2, p3: TMyPoint): Double;
begin
  Result := (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x);
end;
// Точка лежит внутри треугольника
function PointInTriangle (p, p1, p2, p3: TMyPoint): Boolean;
begin
  Result:=((VectMul(p1,p2,p)>0) and
           (VectMul(p2,p3,p)>0) and
           (VectMul(p3,p1,p)>0))    OR
          ((VectMul(p1,p2,p)<0) and
           (VectMul(p2,p3,p)<0) and
           (VectMul(p3,p1,p)<0));
end;
// Тройка векторов - левая
function IsLeft3Vectors (p1, p2, p3: TMyPoint) : Boolean;
begin
  Result :=VectMul(p1,p2,p3)<0.0;
end;
// Поиск треугольника - возвращает индекс второй точки если треугольник найден
function FindTriangle (aPolyG : TMyPolygonArray) : Integer;
var IsOkTriangle : Boolean;
    i, j : Integer;
begin
  Result:=-1;
  // перебираем вершины
  for i:=Low(aPolyG) to High(aPolyG)-2 do 
  begin
    if IsLeft3Vectors (aPolyG[i],aPolyG[i+1],aPolyG[i+2]) then
    begin     // три точки подряд - левый треугоьник
      IsOkTriangle:=True;
      // проверки на невхождение остальных точек в этот треугольик
      for j:=i+2 to High(aPolyG) do
        if PointInTriangle (aPolyG[j], aPolyG[i],aPolyG[i+1],aPolyG[i+2])
          then // в треугольние есть другая вершина сногоугольника
            begin IsOkTriangle:=False; break; end; // не подходит
      if IsOkTriangle then begin Result:=i+1; exit; end;
    end;
  end;
end;
// Добавить треугольник в массив найденных
function AddTriangle (aV1,aV2,aV3 : TMyPoint; var aTA : TMyTriangleArray): Integer;
begin
  // Расширяем массив треугольников
  SetLength(aTA, Length(aTA)+1);
  Result:=High(aTA);
  // Сохраням список вершин
  aTA[Result].VertexA:=aV1;
  aTA[Result].VertexB:=aV2;
  aTA[Result].VertexC:=aV3;
end;
// удалить вершину из многоугольника (вторя точка вершина найденнтого треугольника)
function DeleteVertex (aIndex : Integer; var aVertxArr : TMyPolygonArray): Boolean;
var i : Integer;
begin
  Result:=(aIndex>=Low(aVertxArr)) and (aIndex<=High(aVertxArr));
  if Result then
  begin
    // сдвигаем хвост массива к началу
    for i:=aIndex to High(aVertxArr)-1 do
      aVertxArr[i]:=aVertxArr[i+1];
    // Укорячиваем массив
    SetLength(aVertxArr, Length(aVertxArr)-1);
  end;
end;
// Вспомогательная процедура - случайный цвет заливки
function RandomColor: TColor;
begin
  //           Red              Green                 Blue
  Result := (Random(256) or (Random(256) shl 8) or (Random(256) shl 16));
end;
// Отрисовка 1 треугольника в DEBUG_BMP
procedure Paint3 (T : TMyTriangleRec);
var PT : Array of TPoint;
    cc, cn : TColor;
begin
  SetLength(PT,3);

  // Преобразуем координаты в масси TPoint
  PT[0]:=RoundMyPoint(T.VertexA);
  PT[1]:=RoundMyPoint(T.VertexB);
  PT[2]:=RoundMyPoint(T.VertexC);
  // Рисуем полигон-треугольник
  DEBUG_BMP.Canvas.Polygon(PT);
  // сохраняем текущий цвет кисти
  cc:=DEBUG_BMP.Canvas.Brush.Color;
  DEBUG_BMP.Canvas.Brush.Style:=bsSolid;
  // изменям на случайный
  DEBUG_BMP.Canvas.Brush.Color:=RandomColor;
  // заполняем област в которую входит центр масс треугольника
  // до границы цвета DEBUG_BMP.Canvas.Pen.Color (цвет)
  // границы треугольника) случайным цветом
  DEBUG_BMP.Canvas.FloodFill((PT[0].X+PT[1].X+PT[2].X) div 3,
                    (PT[0].Y+PT[1].Y+PT[2].Y) div 3,
                     DEBUG_BMP.Canvas.Pen.Color, fsBorder);
  // восстанавливаем оригинальный цыет кисти
  DEBUG_BMP.Canvas.Brush.Color:=cc;
end;
// отрисовка массива треугольников
procedure PaintTriangles (A : TMyTriangleArray);
var i : Integer;
begin
  for i:=0 to Length(A)-1 do
    paint3 (A[i]);
end;

// Основная функция - триангуляция многоугольника
function Triangulate (aVertexArr : TMyPolygonArray) : TMyTriangleArray;
var WorkArr : TMyPolygonArray;
       i, k : Integer;
    AllDone : Boolean;
begin
  // Клонируем многоугольник для работы в WorkArr
  AllDone:=False;
  SetLength(Result, 0);
  SetLength (WorkArr, Length(aVertexArr));
  try
    WorkArr:=Copy(aVertexArr);
    while Length(WorkArr)>3 do // Пока в многоугольнике >3 вершин
    begin
      k:=FindTriangle (WorkArr); //Ищем треугольник
      if k<0 then exit; //Не нашди - Ошибка - выход
      AddTriangle (WorkArr[k-1], WorkArr[k], WorkArr[k+1], Result);
      DeleteVertex (k, WorkArr);
    end;
    // Добавляем последний оставшийся треугольник
    AddTriangle (WorkArr[0], WorkArr[1], WorkArr[2], Result);

    // если указан BMP - отрисовываем массив треугольников
    if Assigned (DEBUG_BMP) then  PaintTriangles(Result);

    AllDone:=True;
  finally
    if not AllDone then SetLength(Result, 0);
    WorkArr:=Nil;
  end;
end;

// Расчет центра масс многоугольника методом триангуляции
function CentrMass_By3 (aVertexArr : TMyPolygonArray) : TMyPoint;
var TA : TMyTriangleArray;
     i : Integer;
     wC, wC1, wC2 : TMyPoint;
     wV : TMyPolygonArray;
begin
  Result.X:=0; Result.Y:=0;
  // Триагнулируем многоугольник
  TA:=Triangulate (aVertexArr);

  if Length(TA)=0 then
    raise Exception.Create ('Центр масс - ошибка триангуляции');
  try
    // Ценр масс - ср.арифметическое координат центров масс треугольников
    for i:=Low(TA) to High(TA) do
    begin
      wC:=TriangleMassCenter (TA[i]);
      Result.X:=Result.X+wC.X;
      Result.Y:=Result.Y+wC.Y;
    end;
    Result.X:=Result.X/Length(TA);
    Result.Y:=Result.Y/Length(TA);
(*
    // Триангуляция многоугольника центров масс
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

// Расчет площади многоугольника методом триангуляции
function Ploschad_By3 (aVertexArr : TMyPolygonArray) : Double;
var TA : TMyTriangleArray;
     i : Integer;
begin
  Result:=0.0;
  // Триагнулируем многоугольник
  TA:=Triangulate (aVertexArr);
  if Length(TA)=0 then
    raise Exception.Create ('Площадь - ошибка триангуляции');
  try
    // Суммируем площади треугольников
    for i:=Low(TA) to High(TA) do
      Result:=Result+TrianglePloschad(TA[i]);
  finally
    TA:=Nil;
  end;
end;

end.
