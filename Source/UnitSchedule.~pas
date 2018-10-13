unit UnitSchedule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TFormSchedule = class(TForm)
    ButtonClose: TButton;
    ListBox1: TListBox;
    ButtonAjouter: TButton;
    ButtonSupprimer: TButton;
    ButtonMonter: TButton;
    ButtonDescendre: TButton;
    SpinEditHeure: TSpinEdit;
    Label1: TLabel;
    SpinEdit2: TSpinEdit;
    CheckBoxStopTimer: TCheckBox;
    OpenDialog1: TOpenDialog;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonAjouterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSchedule: TFormSchedule;

implementation

{$R *.dfm}

procedure TFormSchedule.ButtonCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TFormSchedule.ButtonAjouterClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    ListBox1.Items.Add(OpenDialog1.FileName);
  end;
end;

end.
