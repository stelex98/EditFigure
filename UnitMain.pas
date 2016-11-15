unit UnitMain;

interface

uses
  Windows, SysUtils, Graphics, StdCtrls, Controls, ComCtrls, Buttons,
  Classes, ExtCtrls, Forms,
  UnitBaseClass;

type
  TFormMain = class(TForm)
    imgWin: TImage;           // Окно-холст для отрисовки
    lvFigures: TListView;     // Список созданных пользователем фигур
    GroupBox1: TGroupBox;     // Рамка "Чарактеристика фигуры"
    Label1: TLabel;           // Постоянные метки - Текст "Периметр"
    Label2: TLabel;           //                  - Текст "Площадь"
    Label3: TLabel;           //                  - Текст "Центр Масс"
    lblPloschad: TLabel;      // Изменяемые метки для вывода
    lblPerimetr: TLabel;      // характеристик текущей фигуры
    lblCentr: TLabel;         // (периметр, площадь, центр)
    btnPoint: TSpeedButton;   // Кнопка "Создать фигуру Точка"
    btnLine: TSpeedButton;    // Кнопка "Создать фигуру Линия"
    btnSquare: TSpeedButton;  // Кнопка "Создать фигуру Квадрат"
    btnMulty: TSpeedButton;   // Кнопка "Создать фигуру Многоугольник"
    btnCircle: TSpeedButton;  // Кнопка "Создать фигуру Круг"
    btnEdit: TSpeedButton;    // Кнопка "Редактировать фигуру"
    bntDel: TSpeedButton;     // Кнопка "Удалить фигуру"
    btnTransf: TSpeedButton;
    cbPaintTriangles: TCheckBox;  // Кнопка "Трансформировать фигуру"
    // Доп действия при создании формы
    procedure FormCreate(Sender: TObject);
    // Доп действия при уничожении формы
    procedure FormDestroy(Sender: TObject);
    // Доп действия при изменении размера формы (окна)
    procedure FormResize(Sender: TObject);
    // Действие по двойному клику в Списке фигур
    procedure lvFiguresDblClick(Sender: TObject);
    // Действие при изменении выбора фигуры
    procedure lvFiguresSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    // Обработчик команд кнопок быстрого доступа
    procedure ButtonClickHandler(Sender: TObject);
    procedure cbPaintTrianglesClick(Sender: TObject);
  private
    { Private declarations }
    // Промежуточный холст для рисования - потихоньку рисуем на него,
    // потом ГОТОВЫЙ рисунок БЫСТРО копируется в окно отображения
    FBitMap : TBitmap;
    // Создание новой фигуры
    procedure CreateNewFigure (aFT : TFigureType);
    // Редактирование существующей
    procedure EditFigureParams;
    // Удаление существующей
    procedure DeleteFigure;
    // Трансформация фигуры
    procedure TransformFigure;
  public
    { Public declarations }
    // Обработка сообщения-события об изменениях в фигуре
    procedure OnTransformateEventHandler (Sender: TObject);
  end;

var
  FormMain: TFormMain;

implementation
uses UnitEditTransform,  Unit_Triangulate,
     UnitPoint, UnitLine, UnitSquare, UnitMultiAngle, UnitCircle,
     UnitEditPoint, UnitEditLine, UnitEditCircle,UnitEditSquare,
     UnitEditMultiAngle;

{$R *.dfm}
// Доп действия при создании формы
procedure TFormMain.FormCreate(Sender: TObject);
begin
  DoubleBuffered := TRUE;
  lblPloschad.Caption:='';
  lblPerimetr.Caption:='';
  lblCentr.Caption:='';
  FBitMap:=TBitMap.Create;
  DEBUG_BMP:=Nil;
end;
// Доп действия при уничтожении формы
procedure TFormMain.FormDestroy(Sender: TObject);
var i : Integer;
begin
  // Уничтожить все созданные экземпляры классов фигур
  for i:=0 to lvFigures.Items.Count-1 do
    TMy2DFigureBaseClass(lvFigures.Items[i].Data).Free;
  FBitMap.Free;
end;
// При изменении размеров формы
procedure TFormMain.FormResize(Sender: TObject);
begin
  // Изменить размеры Окна-холста для отрисовки
  imgWin.Picture.Bitmap.Height:=imgWin.Height;
  imgWin.Picture.Bitmap.Width:=imgWin.Width;
  imgWin.Picture.Bitmap.Canvas.Rectangle(0,0,imgWin.Width, imgWin.Height);
  FBitMap.Width:=imgWin.Picture.Bitmap.Width;
  FBitMap.Height:=imgWin.Picture.Bitmap.Height;
  // Перерисовать созданные экземпляры классов фигур
  OnTransformateEventHandler(Self);
end;

// Отлавливаем события изменений lvFigures, блокируем-разрешаем действия с фигурами

// Действия при изменении текущей строки в списке фигур
procedure TFormMain.lvFiguresSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected
  then  // выделена строка Item
    begin
      // Обновляем текст меток-характеристик фигуры (округляя до целых)
      lblPloschad.Caption:=IntToStr(Round(TMy2DFigureBaseClass(Item.Data).Ploschad));
      lblPerimetr.Caption:=IntToStr(Round(TMy2DFigureBaseClass(Item.Data).Perimetr));
      lblCentr.Caption:=TMyPointToStr (TMy2DFigureBaseClass(Item.Data).MassCenter);
      if TMy2DFigureBaseClass(Item.Data).FigureType=ftMultiAngle
      then
        begin
          lblPloschad.Caption:=lblPloschad.Caption+' (тр '+
                IntToStr(Round(TMyMultiAngleClass(Item.Data).Ploschad3))+')';
          lblCentr.Caption:=lblCentr.Caption+' (тр '+
                TMyPointToStr (TMyMultiAngleClass(Item.Data).MassCenter3)+')';
        end
      else
        if TMy2DFigureBaseClass(Item.Data).FigureType=ftSquare
        then
          begin
            lblPloschad.Caption:=lblPloschad.Caption+' (тр '+
                  IntToStr(Round(TMySquareClass(Item.Data).Ploschad3))+')';
            lblCentr.Caption:=lblCentr.Caption+' (тр '+
                  TMyPointToStr (TMySquareClass(Item.Data).MassCenter3)+')';
          end
    end
  else  // снято выделение со строки Item
    begin
      // Стираем текст меток-характеристик фигуры
      lblPloschad.Caption:='';
      lblPerimetr.Caption:='';
      lblCentr.Caption:='';
    end;
end;

// Обработчик события от экземпляров реализованных нами классов
procedure TFormMain.OnTransformateEventHandler (Sender: TObject);
var i : Integer;
    R : TRect;
begin
  // Чистим окно
  FBitMap.Canvas.Brush.Style:=bsSolid;
  FBitMap.Canvas.Rectangle(0,0,FBitMap.Width, FBitMap.Height);
  // Делаем заливку фигур прозрачной
  FBitMap.Canvas.Brush.Style:=bsClear;
  // Перерисовываем созданные фигуры
  R:=Rect(0,0, FBitMap.Width, FBitMap.Height);
  for i:=0 to lvFigures.Items.Count-1 do
    TMy2DFigureBaseClass(lvFigures.Items[i].Data).Paint(FBitmap.Canvas);
  imgWin.Picture.Bitmap.Canvas.CopyRect(R, FBitMap.Canvas, R);
  imgWin.Repaint;
end;
// Редактирование параметров уже существующих фигур-экземпляров наших классов
procedure TFormMain.EditFigureParams;
var LI : TListItem;
MSG : STRING;
begin
  if not Assigned (lvFigures.Selected)
  then raise Exception.Create('Не выбрана фигура для редактирования.')
  else
  begin
    LI:=lvFigures.Selected;
    case TMy2DFigureBaseClass(LI.Data).FigureType of
      ftPoint: begin
                 FormEditPoint.FPoint:=LI.Data;
                 if FormEditPoint.ShowModal<>mrOk then exit;
                 LI.Caption:=FormEditPoint.FPoint.FigureName;
               end;
      ftLine: begin
                 FormEditLine.FLine:=LI.Data;
                 if FormEditLine.ShowModal<>mrOk then exit;
               end;
     ftCircle: begin
                 FormEditCircle.FCircle:=LI.Data;
                 if FormEditCircle.ShowModal<>mrOk then exit;
               end;
     ftMultiAngle: begin
                 FormEditMultiAngle.FMuliAngle:=LI.Data;
                 if FormEditMultiAngle.ShowModal<>mrOk then exit;
               end;
     ftSquare: begin
                 FormEditSquare.FSquare:=LI.Data;
                 if FormEditSquare.ShowModal<>mrOk then exit;
               end;
      else raise Exception.Create('Редактирование : Неизвестный класс фигуры.')
    end;
    LI.Caption:=TMy2DFigureBaseClass(LI.Data).FigureName;
    // Перерисовываем Холс
    OnTransformateEventHandler(Self);
    // Переписываем Параметры Фигуры
    lvFiguresSelectItem(lvFigures, LI, True);
  end;
end;
// Уничтожение фигуры
procedure TFormMain.DeleteFigure;
var LI : TListItem;
     k : Integer;
begin
  if not Assigned (lvFigures.Selected)
  then raise Exception.Create('Не выбрана фигура для удаления.')
  else
  begin
    LI:=lvFigures.Selected;
    // Ищем выделенную
    k:=lvFigures.Items.IndexOf(LI);
    if k>=0 then
    begin
      // Уничтожаем сам экземпляр класса
      TMy2DFigureBaseClass(LI.Data).Free;
      // Удаляем строку из таблицы фигур
      lvFigures.Items.Delete(k);
    end;
  end;
  // Перерисовываем окно-холст
  OnTransformateEventHandler(Self);
end;

procedure TFormMain.lvFiguresDblClick(Sender: TObject);
begin
  TransformFigure;
end;

procedure TFormMain.TransformFigure;
begin
  if not Assigned (lvFigures.Selected)
    then raise Exception.Create('Не выбрана фигура для трансформирования.');
  FormEditTransform.FFigure:=lvFigures.Selected.Data;
  FormEditTransform.ShowModal;
  lvFiguresSelectItem(lvFigures, lvFigures.Selected, True)
end;

procedure TFormMain.ButtonClickHandler(Sender: TObject);
var Tag : Integer;
begin
  // Обработку запросил экземпляр TSpeedButton ? (нажата кнопка)
  if Sender is TSpeedButton then Tag:=TSpeedButton(Sender).Tag
    else exit; // Неизвестно кто вызвал - выходим не рискуя
  case Tag of
    101 : CreateNewFigure (ftPoint);
    102 : CreateNewFigure (ftLine);
    105 : CreateNewFigure (ftSquare);
    106 : CreateNewFigure (ftMultiAngle);

    108 : CreateNewFigure (ftCircle);

    201 : EditFigureParams;
    301 : DeleteFigure;
    401 : TransformFigure;
  end;
end;

procedure TFormMain.CreateNewFigure (aFT : TFigureType);
var LI : TListItem;
       wPoint : TMyPointClass;
        wLine : TMyLineClass;
      wCircle : TMyCircleClass;
    wMultiAng : TMyMultiAngleClass;
      wSquare : TMySquareClass;
begin
  case aFT of
    ftPoint : begin
                wPoint:=TMyPointClass.Create('Точка', MyPoint(10, 10));
                wPoint.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditPoint.FPoint:=wPoint;
                if FormEditPoint.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wPoint.FigureName;
                    LI.Data:=wPoint;
                  end
                else wPoint.Free;
             end;
    ftLine : begin
                wLine:=TMyLineClass.Create('Линия', MyPoint(100, 100), MyPoint(300, 100));
                wLine.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditLine.FLine:=wLine;
                if FormEditLine.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wLine.FigureName;
                    LI.Data:=wLine;
                  end
                else wLine.Free;
             end;
    ftCircle : begin
                wCircle:=TMyCircleClass.Create('Круг', MyPoint(100, 100), 50);
                wCircle.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditCircle.FCircle:=wCircle;
                if FormEditCircle.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wCircle.FigureName;
                    LI.Data:=wCircle;
                  end
                else wCircle.Free;
             end;
    ftMultiAngle : begin
                wMultiAng := TMyMultiAngleClass.Create('Многоугольник');
                wMultiAng.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditMultiAngle.FMuliAngle:=wMultiAng;
                if FormEditMultiAngle.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wMultiAng.FigureName;
                    LI.Data:=wMultiAng;
                  end
                else wMultiAng.Free;
             end;
    ftSquare : begin
                wSquare := TMySquareClass.Create('Квадрат',
                             MyPoint (20, 20), 100);
                wSquare.OnFigireChangedEvent:=OnTransformateEventHandler;
                FormEditSquare.FSquare:=wSquare;
                if FormEditSquare.ShowModal=mrOk
                then
                  begin
                    LI:=lvFigures.Items.Add;
                    LI.Caption:=wSquare.FigureName;
                    LI.Data:=wSquare;
                  end
                else wSquare.Free;
             end;
      else raise Exception.Create('Создание : Неизвестный класс фигуры.')
  end;
  OnTransformateEventHandler(Self);
end;
procedure TFormMain.cbPaintTrianglesClick(Sender: TObject);
begin
  if cbPaintTriangles.Checked then DEBUG_BMP:=imgWin.Picture.Bitmap
    else DEBUG_BMP:=Nil;
end;

end.
