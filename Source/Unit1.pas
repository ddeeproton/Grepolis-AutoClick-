unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  Math, Spin, XPMan, Menus,
  inifiles, jpeg, UnitSchedule;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    TimerClick: TTimer;
    ButtonStartStopClick: TButton;
    TimerDisplay: TTimer;
    ListBox1: TListBox;
    GroupBoxRuleClick: TGroupBox;
    SpinEditposX: TSpinEdit;
    SpinEditposY: TSpinEdit;
    SpinEditwait: TSpinEdit;
    ButtonAjouterEtSauver: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ButtonAfficherMasquer: TButton;
    ButtonHaut: TButton;
    ButtonBas: TButton;
    Supprimer: TButton;
    XPManifest1: TXPManifest;
    EditTitle: TEdit;
    Label4: TLabel;
    ButtonModifierEtSauverClick: TButton;
    CheckBoxClickEnabled: TCheckBox;
    ButtonCopyClick: TButton;
    ButtonCopyNextTo: TButton;
    MainMenu1: TMainMenu;
    Fichier1: TMenuItem;
    OuvrirDB1: TMenuItem;
    Enregistrersous1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PopupMenuListBox: TPopupMenu;
    testerlaction1: TMenuItem;
    Options1: TMenuItem;
    toucheCtrlAjoute1: TMenuItem;
    ButtonPause: TButton;
    ImageBackground: TImage;
    Label5: TLabel;
    Aide1: TMenuItem;
    Apropos1: TMenuItem;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    toujoursenavant1: TMenuItem;
    Slectionnelacommande1: TMenuItem;
    N1: TMenuItem;
    Quitter1: TMenuItem;
    TimerScheduler: TTimer;
    Scheduler1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TimerClickTimer(Sender: TObject);
    procedure ButtonStartStopClickClick(Sender: TObject);
    procedure TimerDisplayTimer(Sender: TObject);
    procedure ButtonAjouterEtSauverClick(Sender: TObject);
    procedure ButtonAfficherMasquerClick(Sender: TObject);
    procedure ButtonModifierEtSauverClickClick(Sender: TObject);
    procedure ButtonHautClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure SupprimerClick(Sender: TObject);
    procedure ButtonBasClick(Sender: TObject);
    procedure ButtonCopyClickClick(Sender: TObject);
    procedure CheckBoxClickEnabledClick(Sender: TObject);
    procedure ButtonCopyNextToClick(Sender: TObject);
    procedure OuvrirDB1Click(Sender: TObject);
    procedure Enregistrersous1Click(Sender: TObject);
    procedure testerlaction1Click(Sender: TObject);
    procedure ButtonPauseClick(Sender: TObject);
    procedure toucheCtrlAjoute1Click(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure toujoursenavant1Click(Sender: TObject);
    procedure Slectionnelacommande1Click(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure Scheduler1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TTitle = string[40];
  // Declare a customer record
  TClickScheduled = Record
    isEnabled: Boolean;
    posx : integer;
    posy  : integer;
    wait  : integer;
    title : TTitle;
  end;
  TArrayClickScheduled = array of TClickScheduled;
var
  Form1: TForm1;
  currentStep: integer;
  secondsDisplay:integer;
  arrayClickScheduled :TArrayClickScheduled;
  config_last_file_record: string;

  FormSchedule : UnitSchedule.TFormSchedule;
const
  FILE_RECORD: string = 'database.grepolis.dat';
  VERSION: string = '0.1 beta';
implementation

{$R *.dfm}

procedure LoadConfig;
var
  Setup: TIniFile;
  file_ini: string;
begin
  file_ini := ExtractFileDir(Application.ExeName) + '\Setup.ini';

  if FileExists(file_ini) then
  begin
    Setup := TIniFile.Create(file_ini);
    config_last_file_record := Setup.ReadString('config', 'database', FILE_RECORD);
    Form1.toujoursenavant1.checked := Setup.ReadString('config', 'stayontop', '1') = '1';
    if Form1.toujoursenavant1.checked then Form1.FormStyle := fsStayOnTop;
    Form1.Slectionnelacommande1.checked := Setup.ReadString('config', 'auto_select', '1') = '1';
    Form1.toucheCtrlAjoute1.checked := Setup.ReadString('config', 'ctrl_add', '1') = '1';
    Setup.Free;

    if not FileExists(config_last_file_record) then
    begin
      config_last_file_record := ExtractFileDir(Application.ExeName) + '\' + ExtractFileName(config_last_file_record);
    end;
  end;

  if not FileExists(config_last_file_record) then
  begin
    config_last_file_record := FILE_RECORD;
    Form1.toujoursenavant1Click(Form1.toujoursenavant1);
  end;

end;

procedure SaveConfig;
var  Setup: TIniFile;
begin
  Setup := TIniFile.Create(ExtractFileDir(Application.ExeName) + '\Setup.ini');
  Setup.WriteString('config', 'database', config_last_file_record);
  Setup.WriteBool('config', 'stayontop', Form1.toujoursenavant1.Checked);
  Setup.WriteBool('config', 'auto_select', Form1.Slectionnelacommande1.Checked);
  Setup.WriteBool('config', 'ctrl_add', Form1.toucheCtrlAjoute1.Checked);
  Setup.Free;
end;

// Si la touche control est pressée
function isControlPressed : Boolean;
var
  State: TKeyboardState;
begin
  WINDOWS.GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);
end;

procedure DeleteRecord(index:integer);
var
  i: integer;
  arrayTemp :TArrayClickScheduled;
begin
  SetLength(arrayTemp, 0);
  for i:=0 to Length(arrayClickScheduled)-1 do
  begin
    if i <> index then
    begin
      SetLength(arrayTemp, Length(arrayTemp)+1);
      arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i];
    end;
  end;

  SetLength(arrayClickScheduled, 0);
  for i:=0 to Length(arrayTemp)-1 do
  begin
    SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
    arrayClickScheduled[Length(arrayClickScheduled)-1] := arrayTemp[i];
  end;
end;

procedure CopyRecord(index:integer);
begin
  SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
  arrayClickScheduled[Length(arrayClickScheduled)-1] := arrayClickScheduled[index];
end;

procedure CopyRecordNextTo(index:integer);
var
  i: integer;
  arrayTemp :TArrayClickScheduled;
begin
  SetLength(arrayTemp, 0);
  for i:=0 to Length(arrayClickScheduled)-1 do
  begin
    if i = index then
    begin
      SetLength(arrayTemp, Length(arrayTemp)+2);
      arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i];
      arrayTemp[Length(arrayTemp)-2] := arrayClickScheduled[i];
    end
    else begin
      SetLength(arrayTemp, Length(arrayTemp)+1);
      arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i];
    end;
  end;

  SetLength(arrayClickScheduled, 0);
  for i:=0 to Length(arrayTemp)-1 do
  begin
    SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
    arrayClickScheduled[Length(arrayClickScheduled)-1] := arrayTemp[i];
  end;
end;

procedure RefreshListBox();
var
  i, indexSelected: integer;
  title, is_enabled: string;
begin
  indexSelected := Form1.ListBox1.ItemIndex;
  Form1.ListBox1.Clear;
  for i:=0 to Length(arrayClickScheduled)-1 do
  begin
    title := arrayClickScheduled[i].title;
    if arrayClickScheduled[i].isEnabled then is_enabled := '[X]' else is_enabled := '[_]';
    Form1.ListBox1.Items.Add(is_enabled+' '+title);
  end;
  Form1.ListBox1.ItemIndex := indexSelected;

  if Form1.Visible then Form1.ListBox1.SetFocus;
  Form1.ListBox1Click(Form1.ListBox1);
end;


procedure getContentListbox(i:integer);
begin
  Form1.EditTitle.Text := arrayClickScheduled[i].title;
  Form1.SpinEditposX.Value := arrayClickScheduled[i].posx;
  Form1.SpinEditposY.Value := arrayClickScheduled[i].posy;
  Form1.SpinEditwait.Value := arrayClickScheduled[i].wait div 1000;
  Form1.CheckBoxClickEnabled.Checked := arrayClickScheduled[i].isEnabled;
end;


procedure setContentListbox(i:integer);
begin
  arrayClickScheduled[i].title := Form1.EditTitle.Text;
  arrayClickScheduled[i].posx := Form1.SpinEditposX.Value;
  arrayClickScheduled[i].posy := Form1.SpinEditposY.Value;
  arrayClickScheduled[i].wait := Form1.SpinEditwait.Value * 1000;
  arrayClickScheduled[i].isEnabled := Form1.CheckBoxClickEnabled.Checked;
end;

// Lecture dans fichier record
procedure ReadFileRecord(Filename: string);
var
  Fichier: file of TClickScheduled;
  texte          : TClickScheduled;
begin
 Try
  SetLength(arrayClickScheduled, 0);
  assignFile(Fichier, Filename);
  reset(Fichier); // ouvre en lecture
  while not eof(Fichier) do begin
    read(Fichier, texte);
    SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
    //ShowMessage(inttostr(Length(arrayClickScheduled)-1)+' '+texte.title);
    arrayClickScheduled[Length(arrayClickScheduled)-1] := texte;
  end;
 except
  Application.Terminate;
 end;
 closefile(Fichier);

end;

procedure WriteFileRecord(Fichier : string);
var
  Fp : file of TClickScheduled;
  i:integer;
begin
  assignFile(Fp, Fichier);
  reWrite(Fp); // ouvre en lecture
  for i:=0 to Length(arrayClickScheduled)-1 do
  begin
    Write(Fp, arrayClickScheduled[i]);
  end;
  closefile(Fp);
end;

procedure ClickMouse(x:integer;y:integer);
begin
  SetCursorPos(x,y);
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0);
  Mouse_Event(MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_LEFTUP, 0, 0, 0, 0);
  Application.ProcessMessages;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Form1.DoubleBuffered := True;
  LoadConfig;
  currentStep := 0;
  secondsDisplay := 0;
  if FileExists(config_last_file_record) then
  begin
    ReadFileRecord(config_last_file_record);
    RefreshListBox;
    ButtonAfficherMasquerClick(Self); // Masque le panneau
  end;
  ImageBackground.Align :=  alClient;
end;


procedure TForm1.Timer1Timer(Sender: TObject);
var
  point: TPoint;
  addInfo: string;
  i : integer;
begin
  GetCursorPos(point);

  if toucheCtrlAjoute1.Checked and isControlPressed then
  begin
    addInfo := 'Ajout';
    SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
    i := Length(arrayClickScheduled)-1;
    arrayClickScheduled[i].title := Pchar(IntToStr(point.X)+'x '+IntToStr(point.Y))+'y ';
    arrayClickScheduled[i].posx := point.X;
    arrayClickScheduled[i].posy := point.Y;
    arrayClickScheduled[i].wait := 5000;
    arrayClickScheduled[i].isEnabled := false;
    WriteFileRecord(config_last_file_record);
    RefreshListBox;
  end
  else addInfo := ExtractFileName(config_last_file_record);

  Caption := Pchar(IntToStr(point.X)+'x '+IntToStr(point.Y)+'y - '+addInfo);
end;


procedure TForm1.TimerClickTimer(Sender: TObject);
var i : integer;
begin
  if Length(arrayClickScheduled) = 0 then TimerClick.Enabled := false;
  i := currentStep;

  if not arrayClickScheduled[i].isEnabled then
  begin
    while (i < ListBox1.Count-1)  and not arrayClickScheduled[i].isEnabled do
    begin
      inc(i);
    end;
    currentStep := i;
  end;

  if arrayClickScheduled[i].isEnabled then
  begin
    if Slectionnelacommande1.Checked then
    begin
      ListBox1.ItemIndex := i;
      if GroupBoxRuleClick.Visible then ListBox1Click(Self);
    end;
    ClickMouse(arrayClickScheduled[i].posx, arrayClickScheduled[i].posy);
    TimerClick.Interval := arrayClickScheduled[i].wait + RandomRange(1, 5000);
  end;

  inc(currentStep);
  if (currentStep > ListBox1.Count-1) then currentStep := 0;

  secondsDisplay := TimerClick.Interval div TimerDisplay.Interval;
  TimerClick.Enabled := False;
  TimerClick.Enabled := True;    
end;

procedure TForm1.ButtonStartStopClickClick(Sender: TObject);
begin
  ButtonPause.Enabled := not TimerClick.Enabled;
  currentStep := 0;
  TimerClick.Interval := 5000;
  secondsDisplay := TimerClick.Interval div TimerDisplay.Interval;
  Timer1.Enabled := not Timer1.Enabled;
  TimerClick.Enabled := not TimerClick.Enabled;
  TimerDisplay.Enabled := not TimerDisplay.Enabled;
  if TimerClick.Enabled then ButtonStartStopClick.Caption := PChar('STOP') else ButtonStartStopClick.Caption := PChar('START');
  if TimerClick.Enabled then ButtonPause.Caption := PChar('PAUSE') else ButtonPause.Caption := PChar('RESUME');
end;

procedure TForm1.ButtonPauseClick(Sender: TObject);
begin
  ButtonStartStopClick.Enabled := not TimerClick.Enabled;
  Timer1.Enabled := not Timer1.Enabled;
  TimerClick.Enabled := not TimerClick.Enabled;
  TimerDisplay.Enabled := not TimerDisplay.Enabled;
  if TimerClick.Enabled then TButton(Sender).Caption := PChar('PAUSE') else TButton(Sender).Caption := PChar('RESUME');
  if TimerClick.Enabled then ButtonStartStopClick.Caption := PChar('STOP') else ButtonStartStopClick.Caption := PChar('START');
end;

procedure TForm1.TimerDisplayTimer(Sender: TObject);
begin
  Caption := '['+IntToStr(currentStep)+'] '+PChar(IntToStr(secondsDisplay)+'s '+ExtractFileName(config_last_file_record));
  dec(secondsDisplay);
end;

procedure TForm1.ButtonAjouterEtSauverClick(Sender: TObject);
begin
  SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
  setContentListbox(Length(arrayClickScheduled)-1);
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
  TimerClick.Enabled := True;
end;

procedure TForm1.ButtonModifierEtSauverClickClick(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then exit;
  setContentListbox(ListBox1.ItemIndex);
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
end;

procedure TForm1.ButtonCopyClickClick(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then exit;
  CopyRecord(ListBox1.ItemIndex);
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
end;

procedure TForm1.ButtonCopyNextToClick(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then exit;
  CopyRecordNextTo(ListBox1.ItemIndex);
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
end;

procedure TForm1.SupprimerClick(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then exit;
  DeleteRecord(ListBox1.ItemIndex);
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then exit;
  GroupBoxRuleClick.Visible := true;
  ButtonAfficherMasquer.Caption := PChar('->');
  ListBox1.Width := Form1.Width - GroupBoxRuleClick.Width - (ListBox1.Left * 2) - 10;
  getContentListbox(ListBox1.ItemIndex);
end;

procedure TForm1.ButtonAfficherMasquerClick(Sender: TObject);
begin
  GroupBoxRuleClick.Visible := not GroupBoxRuleClick.Visible;
  if GroupBoxRuleClick.Visible then
  begin
    ButtonAfficherMasquer.Caption := PChar('->');
    ListBox1.Width := Form1.Width - GroupBoxRuleClick.Width - (ListBox1.Left * 2) - 15;
  end else
  begin
    ButtonAfficherMasquer.Caption := PChar('<-');
    ListBox1.Width := Form1.Width - (ListBox1.Left * 2) - 10;
  end;
end;


procedure TForm1.ButtonHautClick(Sender: TObject);
var
  i: integer;
  arrayTemp :TArrayClickScheduled;
begin
  if ListBox1.ItemIndex < 1 then exit;

  SetLength(arrayTemp, 0);
  for i:=0 to Length(arrayClickScheduled)-1 do
  begin
    if i = ListBox1.ItemIndex-1 then
    begin
      SetLength(arrayTemp, Length(arrayTemp)+1);
      arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i+1];
    end else
    begin
      if i = ListBox1.ItemIndex then
      begin
        SetLength(arrayTemp, Length(arrayTemp)+1);
        arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i-1];
      end else
      begin
        SetLength(arrayTemp, Length(arrayTemp)+1);
        arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i];
      end;
    end;
  end;

  SetLength(arrayClickScheduled, 0);
  for i:=0 to Length(arrayTemp)-1 do
  begin
    SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
    arrayClickScheduled[Length(arrayClickScheduled)-1] := arrayTemp[i];
  end;
  ListBox1.ItemIndex := ListBox1.ItemIndex - 1;
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
end;


procedure TForm1.ButtonBasClick(Sender: TObject);
var
  i: integer;
  arrayTemp :TArrayClickScheduled;
begin
  if ListBox1.ItemIndex > ListBox1.Count - 2 then exit;

  SetLength(arrayTemp, 0);
  for i:=0 to Length(arrayClickScheduled)-1 do
  begin
    if i = ListBox1.ItemIndex+1 then
    begin
      SetLength(arrayTemp, Length(arrayTemp)+1);
      arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i-1];
    end else
    begin
      if i = ListBox1.ItemIndex then
      begin
        SetLength(arrayTemp, Length(arrayTemp)+1);
        arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i+1];
      end else
      begin
        SetLength(arrayTemp, Length(arrayTemp)+1);
        arrayTemp[Length(arrayTemp)-1] := arrayClickScheduled[i];
      end;
    end;
  end;

  SetLength(arrayClickScheduled, 0);
  for i:=0 to Length(arrayTemp)-1 do
  begin
    SetLength(arrayClickScheduled, Length(arrayClickScheduled)+1);
    arrayClickScheduled[Length(arrayClickScheduled)-1] := arrayTemp[i];
  end;
  ListBox1.ItemIndex := ListBox1.ItemIndex + 1;
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
end;



procedure TForm1.CheckBoxClickEnabledClick(Sender: TObject);
begin
  if ListBox1.ItemIndex = -1 then exit;
  setContentListbox(ListBox1.ItemIndex);
  WriteFileRecord(config_last_file_record);
  RefreshListBox;
  ListBox1.SetFocus;
end;



procedure TForm1.OuvrirDB1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    Timer1.Enabled := True;
    TimerClick.Enabled := False;
    TimerDisplay.Enabled := False;
    ButtonStartStopClick.Caption := PChar('START');
    currentStep := 0;
    secondsDisplay := 0;
    if FileExists(OpenDialog1.FileName) then
    begin
      ReadFileRecord(OpenDialog1.FileName);
      RefreshListBox;
      config_last_file_record := OpenDialog1.FileName;
      SaveConfig;
    end;
  end;
end;

procedure TForm1.Enregistrersous1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    WriteFileRecord(SaveDialog1.FileName);
    config_last_file_record := SaveDialog1.FileName;
    SaveConfig;
  end;
end;

procedure TForm1.testerlaction1Click(Sender: TObject);
var
  i: integer;
begin
  i := ListBox1.ItemIndex;
  ClickMouse(arrayClickScheduled[i].posx, arrayClickScheduled[i].posy);
end;

procedure TForm1.toucheCtrlAjoute1Click(Sender: TObject);
begin
  toucheCtrlAjoute1.Checked := not toucheCtrlAjoute1.Checked;
  SaveConfig;
end;

procedure TForm1.toujoursenavant1Click(Sender: TObject);
begin
 if Form1.FormStyle = fsNormal then
    Form1.FormStyle := fsStayOnTop
  else
    Form1.FormStyle := fsNormal;
  toujoursenavant1.Checked := Form1.FormStyle = fsStayOnTop;
  SaveConfig;
end;

procedure TForm1.Slectionnelacommande1Click(Sender: TObject);
begin
  Slectionnelacommande1.Checked := not Slectionnelacommande1.Checked;
  SaveConfig;
end;

procedure TForm1.Apropos1Click(Sender: TObject);
begin
  ShowMessage('Version du programme: '+VERSION);
end;



procedure TForm1.Quitter1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.Scheduler1Click(Sender: TObject);
begin
  If FormSchedule = Nil then UnitSchedule.TFormSchedule.Create(Self);
  FormSchedule.ShowModal;
end;

end.
