// -------------------------------------------------------------------------
// ������� �����-������ ��� 2D-�����
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
  // ��������������� ���� ��� �������������
  TMyPoint = Packed Record
    X,Y : Double;
  end;
  // ������ ������ �������������� - �� ������� �������
  TMyPolygonArray = Array of TMyPoint;
(*
  // �����������
  TMyTriangleRec = Packed Record
    VertexA : TMyPoint;
    VertexB : TMyPoint;
    VertexC : TMyPoint;
  end;
  // ������ ������������� ��� ������������ �������������
  TMyTriangleArray = Array of TMyTriangleRec;
*)
  // ������� ����� 2D-�����
  TMy2DFigureBaseClass = class
  protected
    // ���� ��� �������� ������ � ������� ��������-������������ �������
    // ���� - ��� ������ (���������� �������� ����� ��� �������� �������������)
    FFigureType : TFigureType;
    // ���� - ������������ ������ (������������ � ������ ��������� �����-�����)
    FFigureName : String;
    // ----------- �������
    // ���� - ������� - ������ �������� (�������� ���������, �������, ���������)
    FOnFigireChangedEvent : TNotifyEvent;
    // ���� - ������� - ������ ����������
    FOnFigireMovedEvent : TNotifyEvent;
    // ���� - ������� - ������ ���������
    FOnFigireRotatedEvent : TNotifyEvent;
    // ���� - ������� - ������ ��������������
    FOnFigireScaledEvent : TNotifyEvent;
    // ���� - ������� - ������ ����������
    FOnFigirePaintedEvent : TNotifyEvent;
    
    // --������ ���������� ������� ������ - ���������� ��������� � ��������
    // ������ ���������
    function GetPerimetr : Double; virtual; abstract;
    // ������ �������
    function GetPloschad : Double; virtual; abstract;
    // ������ ������ ����
    function GetMassCenter : TMyPoint; virtual; abstract;

    // ----- ������� ��������� ������ � �������
    // ����� ����� aPoint �� aDelta
    function MovePoint (aPoint, aDelta : TMyPoint): TMyPoint;
    // ��������������� ����� aPoint �� aKX, aKY ������������ ����� aCenter
    function ScalePoint (aPoint, aCenter : TMyPoint; aKX, aKY : Double): TMyPoint;
    // �������� ����� aPoint �� ���� aAngle (������) ������������ ����� aCenter
    function RotatePoint (aPoint, aCenter : TMyPoint; aAngle : Double): TMyPoint;
    // -- ������ ��������������
    // ����������� ������ ���� �� �������� aDelta
    procedure MoveMassCenter (aDelta : TMyPoint); virtual; abstract;
    // �������� ������������ ����� � ������������ aRotateCenter �� ���� aAngle
    procedure Rotate (aRotateCenter : TMyPoint; aAngle : Double); virtual; abstract;
    // ��������������� ������������ ����� aCenter
    procedure Scale (aScaleCenter : TMyPoint; aKX, aKY : Double); virtual; abstract;
  public
    // ��������� �������� ������
    // �������� : ��� ������ - ����� ������� � ����� FFigureType
    property FigureType : TFigureType read FFigureType write FFigureType;
    // �������� : ������������ ������ - ������� � ����� FFigureName
    property FigureName : String read FFigureName write FFigureName;
    // �������� : ������� ������, ������ ������, ����������� � GetPloschad
    property Ploschad : Double read GetPloschad;
    // �������� : �������� ������, ������ ������, ����������� � GetPerimetr
    property Perimetr : Double read GetPerimetr;
    // �������� : ���������, ������ ������, ����������� � GetMassCenter
    property MassCenter : TMyPoint read GetMassCenter;
    // ----------- �������
    // �������� : ������� - ������ �������� (�������� ���������, �������, ���������)
    property OnFigireChangedEvent : TNotifyEvent read FOnFigireChangedEvent write FOnFigireChangedEvent;
    // �������� : ������� - ������ ����������
    property OnFigireMovedEvent : TNotifyEvent read FOnFigireMovedEvent write FOnFigireMovedEvent;
    // �������� : ������� - ������ ���������
    property OnFigireRotatedEvent : TNotifyEvent read FOnFigireRotatedEvent write FOnFigireRotatedEvent;
    // �������� : ������� - ������ ��������������
    property OnFigireScaledEvent : TNotifyEvent read FOnFigireScaledEvent write FOnFigireScaledEvent;
    // �������� : ������� - ������ ����������
    property OnFigirePaintedEvent : TNotifyEvent read FOnFigirePaintedEvent write FOnFigirePaintedEvent;

    // �����������
    constructor Create (aName : String);
    // ---- ��������� ����������
    // ������������� �������������
    procedure Transformate (aDuration : Cardinal;   // ������������ �������������
                            aSteps : Integer;       // ����� ����������
                            aNeedMuv : Boolean;     // �������?
                            aMovDelta : TMyPoint;     //   ����������� - ��������
                            aNeedRotC : Boolean;    // ������� ������ �����?
                            aRotateCAngle : Double; //    ���� ��������
                            aNeedRotP : Boolean;    // ������� ������ ����� ?
                            aRotateCenter : TMyPoint; //   �������� - ����� ��������
                            aRotateAngle : Double;  //   �������� - ����
                            aNeedSclC : Boolean;    // �������������� ������� ������ ?
                            aScaleCKX, aScaleCKY : Double; // ����� - �����������
                            aNeedSclP : Boolean;    // �������������� ������� ����� ?
                            aScaleCenter : TMyPoint;  // ����� - �����
                            aScaleKX, aScaleKY : Double // ����� - �����������
                            );
    // -- ��������� ������ �� ����� Canvas
    // ��������� ������ � ����� aCanvas
    procedure Paint (aCanvas : TCanvas); virtual; abstract;
  end;


// ��������������� ���������
// �������������� X Y � TMyPoint;
function MyPoint (aX,aY : Double): TMyPoint;
// ������� �������� � ������� (���������� ����������� DegToRad �� ������ Match)
function GradusToRadian (aGrad : Double) : Double;
// ����������� TMyPoint � ������
function TMyPointToStr (aPoint : TMyPoint; const SeparatorStr : String =' ') : String;
// ����������� ������ � TMyPoint
function StrToTMyPoint (aStr : String; const Separator : Char =' '): TMyPoint;
// ����� ����� ����� ������� aPointA, aPointB
function LineLength (aPointA, aPointB : TMyPoint) : Double;
// ���������� TMyPoint �� ������������ TPoint
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
  if k<=0 then raise Exception.Create ('�������� ������ ������ TMyPoint :'+aStr);
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
// ���������� TMyPoint �� ������������ TPoint
function RoundMyPoint(aPoint : TMyPoint): TPoint;
begin
  Result.X:=Round(aPoint.X);
  Result.Y:=Round(aPoint.Y);
end;
// ========================= ���������� ������ ==========================
constructor TMy2DFigureBaseClass.Create (aName : String);
begin
  inherited Create;
  // ������������� �����
  FFigureName:=aName;
  FFigureType:=ftNone; // ��� �������� ������ ��� �����������
  FOnFigireChangedEvent:=Nil;  // ���������� ������� �� �����
  FOnFigireMovedEvent :=Nil;   // ���������� ������� �� �����
  FOnFigireRotatedEvent :=Nil; // ���������� ������� �� �����
  FOnFigireScaledEvent :=Nil;  // ���������� ������� �� �����
  FOnFigirePaintedEvent :=Nil; // ���������� ������� �� �����
end;
// ���������� ������� ��������
// �������� ����� �� aDelta
function TMy2DFigureBaseClass.MovePoint (aPoint, aDelta : TMyPoint): TMyPoint;
begin
  Result:=MyPoint(aPoint.X+aDelta.X, aPoint.Y+aDelta.Y);
end;
// ��������������� ����� ������������ aCenter �� ����������� aKX, aKY
function TMy2DFigureBaseClass.ScalePoint (aPoint, aCenter : TMyPoint; aKX, aKY : Double): TMyPoint;
begin
  Result:=MyPoint(aCenter.X+(aPoint.X-aCenter.X)*aKX, aCenter.Y+(aPoint.Y-aCenter.Y)*aKY);
end;
// �������� ����� ������������ ������ aCenter �� ���� aAngle
function TMy2DFigureBaseClass.RotatePoint (aPoint, aCenter : TMyPoint; aAngle : Double): TMyPoint;
begin
  Result:=MyPoint(aCenter.X+(aPoint.X-aCenter.X)*Cos(aAngle)-(aPoint.Y-aCenter.Y)*Sin(aAngle),
                  aCenter.Y+(aPoint.X-aCenter.X)*Sin(aAngle)+(aPoint.Y-aCenter.Y)*Cos(aAngle));
end;


// ������������� �������������

procedure TMy2DFigureBaseClass.Transformate (aDuration : Cardinal;   // ������������ �������������
                            aSteps : Integer;       // ����� ����������
                            aNeedMuv : Boolean;     // �������?
                            aMovDelta : TMyPoint;     //   ����������� - ��������
                            aNeedRotC : Boolean;    // ������� ������ �����?
                            aRotateCAngle : Double; //    ���� ��������
                            aNeedRotP : Boolean;    // ������� ������ ����� ?
                            aRotateCenter : TMyPoint; //   �������� - ����� ��������
                            aRotateAngle : Double;  //   �������� - ����
                            aNeedSclC : Boolean;    // �������������� ������� ������ ?
                            aScaleCKX, aScaleCKY : Double; // ����� - �����������
                            aNeedSclP : Boolean;    // �������������� ������� ����� ?
                            aScaleCenter : TMyPoint;  //   ����� - �����
                            aScaleKX, aScaleKY : Double //   ����� - �����������
                            );
var StartTick, OneStepFact, OneStepPlan : DWORD; //��������� �������
    currStep, i  : Integer;               // ������� �����
    dMP : TMyPoint;  // �������� �� 1 ���
    wAngleP, wPKX, wPKY, wAngleC, wCKX, wCKY : Double;
    needMov, needRotateP, needRotateC, needScaleP, needScaleC : Boolean;
begin
  // �� ���������� ���������� ��� ���������
    needMov:=((aMovDelta.X<>0) or (aMovDelta.Y<>0)) and aNeedMuv;
    needRotateC:=(aRotateCAngle<>0.0) and aNeedRotC;
    needRotateP:=(aRotateAngle<>0.0) and aNeedRotP;
    needScaleC:=((aScaleCKX<>0) or (aScaleCKY<>0)) and (aNeedSclC);
    needScaleP:=((aScaleKX<>0) or (aScaleKY<>0)) and (aNeedSclP);

    if (not (needMov or needRotateP or needScaleP or
              needRotateC or needScaleC)) or (aSteps=0)  //������ ������
      then exit;
    if (aDuration=0) or (aSteps=1) //�������� �� ���������
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
        if needMov then //���� ����� �����������
        begin
          dMP.X:=aMovDelta.X / aSteps;
          dMP.Y:=aMovDelta.Y / aSteps;
        end;

        if needRotateC then // ���� ����� ��������
          wAngleC:=aRotateCAngle/aSteps; //���� �� 1 ��������
        if needRotateP then // ���� ����� ��������
          wAngleP:=aRotateAngle/aSteps; //���� �� 1 ��������
        if needScaleC then // ���� ����� ���������������
        begin // ������ ������� aSteps �� KX � KY
          wCKX:=Exp(Ln(abs(aScaleCKX))/aSteps);
          wCKY:=Exp(Ln(abs(aScaleCKY))/aSteps);
        end;
        if needScaleP then // ���� ����� ���������������
        begin // ������ ������� aSteps �� KX � KY
          wPKX:=Exp(Ln(abs(aScaleKX))/aSteps);
          wPKY:=Exp(Ln(abs(aScaleKY))/aSteps);
        end;

// GetTickCount-���-�� �������� �� ��������� ��, ��������� ����� ����,
// ���� ������� ����� �������� ���������� � ������� 49.7 ����.
        currStep:=0;
        // ��������� �� 1 �������� OneStepPlan ����������
        OneStepPlan:=aDuration div aSteps; // ���������� ����� 1 ��������
        while currStep<aSteps do
        begin
          //���������� ����� ������ ��������
          StartTick:=GetTickCount;
          // �������� ������...
          if needMov then MoveMassCenter (dMP);
          if needRotateC then Rotate (GetMassCenter, wAngleC);
          if needRotateP then Rotate (aRotateCenter, wAngleP);
          if needScaleC then Scale (GetMassCenter, wCKX, wCKY);
          if needScaleP then Scale (aScaleCenter, wPKX, wPKY);
          // ���������� �������-��������� �� ����������
          if Assigned (OnFigireChangedEvent) then OnFigireChangedEvent(Self);
          //������������� �������� �� ��������� ��������
          //��������� �� ���������� ��������
          OneStepFact:=GetTickCount-StartTick;
          // ��������� ������ ��� ����������� - ����-�������
          if OneStepPlan>OneStepFact
            then Sleep(OneStepPlan-OneStepFact);
          // ��������� �� ��������� ���
          inc (currStep);
        end;
      end;
end;


end.
