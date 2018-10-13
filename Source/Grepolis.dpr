program Grepolis;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UnitSchedule in 'UnitSchedule.pas' {FormSchedule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormSchedule, FormSchedule);
  Application.Run;
end.
