unit cryptstudiocode;

{
 This sofware was made by Popov Evgeniy Alekseyevich.
 It is distributed under the GNU GENERAL PUBLIC LICENSE (Version 2 or higher).
}

{$mode objfpc}
{$H+}

interface

uses Classes, SysUtils, Forms, Controls, Dialogs, ExtCtrls, StdCtrls, UTF8Process;

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
    function check_input():boolean;
    procedure window_setup();
    procedure set_encryption_mode();
    procedure set_decryption_mode();
    procedure interface_setup();
    procedure language_setup();
    procedure setup();
  public
    { public declarations }
  end; 

var MainWindow: TMainWindow;

implementation

function convert_file_name(const source:string): string;
var target:string;
begin
 target:=source;
 if Pos(' ',source)>0 then
 begin
  target:='"'+source+'"';
 end;
 Result:=target;
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
  on E:Exception do ShowMessage(E.Message);
 end;

end;

{$R *.lfm}

{ TMainWindow }

function TMainWindow.check_input():boolean;
begin
 Result:=(Self.PasswordField.Text<>'') and (Self.FileField.Text<>'');
end;

procedure TMainWindow.window_setup();
begin
 Application.Title:='Crypt studio';
 Self.Caption:='Crypt studio 1.1.1';
 Self.Font.Name:=Screen.MenuFont.Name;
 Self.Font.Size:=14;
 Self.BorderStyle:=bsDialog;
end;

procedure TMainWindow.set_encryption_mode();
begin
 Self.OpenDialog.Title:='Open a file';
 Self.OpenDialog.DefaultExt:='*.*';
 Self.OpenDialog.FileName:='*.*';
 Self.OpenDialog.Filter:='All files|.*';
end;

procedure TMainWindow.set_decryption_mode();
begin
 Self.OpenDialog.Title:='Open an encrypted file';
 Self.OpenDialog.DefaultExt:='*.bef';
 Self.OpenDialog.FileName:='*.bef';
 Self.OpenDialog.Filter:='Black Ice file container|.bef';
end;

procedure TMainWindow.interface_setup();
begin
 Self.OpenButton.ShowHint:=False;
 Self.StartButton.ShowHint:=False;
 Self.HideCheckBox.Checked:=True;
 Self.EncryptionRadioButton.Checked:=True;
 Self.EncryptionRadioButton.ShowHint:=False;
 Self.DecryptionRadioButton.ShowHint:=False;
 Self.OpenDialog.InitialDir:='';
 Self.FileField.Text:='';
 Self.PasswordField.Text:='';
 Self.FileField.LabelPosition:=lpLeft;
 Self.PasswordField.LabelPosition:=lpLeft;
 Self.FileField.Enabled:=False;
end;

procedure TMainWindow.language_setup();
begin
 Self.OpenButton.Caption:='Open';
 Self.StartButton.Caption:='Start';
 Self.HideCheckBox.Caption:='Hide the password';
 Self.FileField.EditLabel.Caption:='Target file';
 Self.PasswordField.EditLabel.Caption:='Password';
 Self.ModePanel.Caption:='Mode';
 Self.EncryptionRadioButton.Caption:='Encryption';
 Self.DecryptionRadioButton.Caption:='Decryption';
end;

procedure TMainWindow.setup();
begin
 Self.window_setup();
 Self.set_encryption_mode();
 Self.interface_setup();
 Self.language_setup();
end;

{ TMainWindow }

procedure TMainWindow.FormCreate(Sender: TObject);
begin
 Self.setup();
end;

procedure TMainWindow.FileFieldChange(Sender: TObject);
begin
 Self.StartButton.Enabled:=Self.check_input();
end;

procedure TMainWindow.PasswordFieldChange(Sender: TObject);
begin
 Self.StartButton.Enabled:=Self.check_input();
end;

procedure TMainWindow.EncryptionRadioButtonClick(Sender: TObject);
begin
 Self.set_encryption_mode();
end;

procedure TMainWindow.DecryptionRadioButtonClick(Sender: TObject);
begin
 Self.set_decryption_mode();
end;

procedure TMainWindow.OpenButtonClick(Sender: TObject);
begin
 if Self.OpenDialog.Execute()=True then Self.FileField.Text:=Self.OpenDialog.FileName;
end;

procedure TMainWindow.StartButtonClick(Sender: TObject);
begin
 do_job(Self.ToolRunner,Self.FileField.Text,Self.PasswordField.Text,Self.DecryptionRadioButton.Checked);
end;

procedure TMainWindow.HideCheckBoxChange(Sender: TObject);
begin
 Self.PasswordField.PasswordChar:=#0;
 if Self.HideCheckBox.Checked=True then Self.PasswordField.PasswordChar:='*';
end;

end.
