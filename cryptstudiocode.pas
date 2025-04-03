unit cryptstudiocode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, UTF8Process;

type

  { TMainWindow }

  TMainWindow = class(TForm)
    OpenButton: TButton;
    StartButton: TButton;
    HideCheckBox: TCheckBox;
    ModePanel: TLabel;
    FileField: TLabeledEdit;
    PasswordField: TLabeledEdit;
    OpenDialog: TOpenDialog;
    ToolRunner: TProcessUTF8;
    EncryptionRadioButton: TRadioButton;
    DecryptionRadioButton: TRadioButton;
    procedure OpenButtonClick(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure HideCheckBoxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FileFieldChange(Sender: TObject);
    procedure PasswordFieldChange(Sender: TObject);
    procedure EncryptionRadioButtonClick(Sender: TObject);
    procedure DecryptionRadioButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var MainWindow: TMainWindow;

implementation

{$R *.lfm}

{ TMainWindow }

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 convert_file_name:=target;
end;

procedure do_job(var runner:TProcessUTF8;const target:string;const password:string;const decryption:boolean);
var mode:string;
begin
 mode:='encrypt';
 if decryption=True then  mode:='decrypt';
 runner.Executable:=ExtractFilePath(Application.ExeName)+'blackice.exe';
 runner.Parameters.Clear();
 runner.Parameters.Add(mode);
 runner.Parameters.Add(convert_file_name(password));
 runner.Parameters.Add(convert_file_name(target));
 try
  runner.Execute();
 except
  ;
 end;

end;

procedure window_setup();
begin
 Application.Title:='Crypt studio';
 MainWindow.Caption:='Crypt studio 1.0.6';
 MainWindow.Font.Name:=Screen.MenuFont.Name;
 MainWindow.Font.Size:=14;
 MainWindow.BorderStyle:=bsDialog;
end;

procedure set_encryption_mode();
begin
 MainWindow.OpenDialog.Title:='Open a file';
 MainWindow.OpenDialog.DefaultExt:='*.*';
 MainWindow.OpenDialog.FileName:='*.*';
 MainWindow.OpenDialog.Filter:='All files|.*';
end;

procedure set_decryption_mode();
begin
 MainWindow.OpenDialog.Title:='Open an encrypted file';
 MainWindow.OpenDialog.DefaultExt:='*.bef';
 MainWindow.OpenDialog.FileName:='*.bef';
 MainWindow.OpenDialog.Filter:='Black Ice file container|.bef';
end;

procedure interface_setup();
begin
 MainWindow.OpenButton.ShowHint:=False;
 MainWindow.StartButton.ShowHint:=False;
 MainWindow.HideCheckBox.Checked:=True;
 MainWindow.EncryptionRadioButton.Checked:=True;
 MainWindow.EncryptionRadioButton.ShowHint:=False;
 MainWindow.DecryptionRadioButton.ShowHint:=False;
 MainWindow.OpenDialog.InitialDir:='';
 MainWindow.FileField.Text:='';
 MainWindow.PasswordField.Text:='';
 MainWindow.FileField.LabelPosition:=lpLeft;
 MainWindow.PasswordField.LabelPosition:=lpLeft;
 MainWindow.FileField.Enabled:=False;
end;

procedure language_setup();
begin
 MainWindow.OpenButton.Caption:='Open';
 MainWindow.StartButton.Caption:='Start';
 MainWindow.HideCheckBox.Caption:='Hide the password';
 MainWindow.FileField.EditLabel.Caption:='Target file';
 MainWindow.PasswordField.EditLabel.Caption:='Password';
 MainWindow.ModePanel.Caption:='Mode';
 MainWindow.EncryptionRadioButton.Caption:='Encryption';
 MainWindow.DecryptionRadioButton.Caption:='Decryption';
end;

procedure setup();
begin
 window_setup();
 set_encryption_mode();
 interface_setup();
 language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 MainWindow.StartButton.Enabled:=(MainWindow.PasswordField.Text<>'') and (MainWindow.FileField.Text<>'');
end;

procedure TMainWindow.PasswordFieldChange(Sender: TObject);
begin
 MainWindow.StartButton.Enabled:=(MainWindow.PasswordField.Text<>'') and (MainWindow.FileField.Text<>'');
end;

procedure TMainWindow.EncryptionRadioButtonClick(Sender: TObject);
begin
 set_encryption_mode();
end;

procedure TMainWindow.DecryptionRadioButtonClick(Sender: TObject);
begin
 set_decryption_mode();
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if MainWindow.OpenDialog.Execute()=True then MainWindow.FileField.Text:=MainWindow.OpenDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 do_job(MainWindow.ToolRunner,MainWindow.FileField.Text,MainWindow.PasswordField.Text,MainWindow.DecryptionRadioButton.Checked);
end;

procedure TMainWindow.HideCheckBoxChange(Sender: TObject);
begin
 MainWindow.PasswordField.PasswordChar:=#0;
 if MainWindow.HideCheckBox.Checked=True then MainWindow.PasswordField.PasswordChar:='*';
end;

end.
