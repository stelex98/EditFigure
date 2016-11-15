program Demo2DFigures;

uses
  Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitBaseClass in 'Units\UnitBaseClass.pas',
  UnitPoint in 'Units\UnitPoint.pas',
  UnitLine in 'Units\UnitLine.pas',
  UnitSquare in 'Units\UnitSquare.pas',
  UnitMultiAngle in 'Units\UnitMultiAngle.pas',
  UnitCircle in 'Units\UnitCircle.pas',
  UnitEditPoint in 'Units\Form_EditPoint\UnitEditPoint.pas' {FormEditPoint},
  UnitEditLine in 'Units\Form_EditLine\UnitEditLine.pas' {FormEditLine},
  UnitEditMultiAngle in 'Units\Form_EditMultiAngle\UnitEditMultiAngle.pas' {FormEditMultyAngle},
  UnitEditSquare in 'Units\Form_EditSquare\UnitEditSquare.pas' {FormEditSquare},
  UnitEditCircle in 'Units\Form_EditCircle\UnitEditCircle.pas' {FormEditCircle},
  UnitEditTransform in 'Units\Form_Transform\UnitEditTransform.pas' {FormEditTransform},
  Unit_Triangulate in 'Units\Unit_Triangulate.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormEditPoint, FormEditPoint);
  Application.CreateForm(TFormEditLine, FormEditLine);
  Application.CreateForm(TFormEditSquare, FormEditSquare);
  Application.CreateForm(TFormEditMultiAngle, FormEditMultiAngle);
  Application.CreateForm(TFormEditCircle, FormEditCircle);
  Application.CreateForm(TFormEditTransform, FormEditTransform);
  Application.Run;
end.
