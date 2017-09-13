unit cryptstudiocode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Dialogs,
  ExtCtrls, StdCtrls, UTF8Process;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    Process1: TProcessUTF8;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

  var Form1: TForm1;
  function check_input(input:string):Boolean;
  function convert_file_name(source:string): string;
  procedure window_setup();
  procedure set_encryption_mode();
  procedure set_decryption_mode();
  procedure interface_setup();
  procedure frontend_setup();
  procedure common_setup();
  procedure language_setup();
  procedure setup();

implementation

{$R *.lfm}

{ TForm1 }

function check_input(input:string):Boolean;
var target:Boolean;
begin
target:=True;
if input='' then
begin
target:=False;
end;
check_input:=target;
end;

function convert_file_name(source:string): string;
var target:string;
begin
target:=source;
if Pos(' ',source)>0 then
begin
target:='"';
target:=target+source+'"';
end;
convert_file_name:=target;
end;

procedure window_setup();
begin
 Application.Title:='Crypt studio';
 Form1.Caption:='Crypt studio 0.9';
 Form1.Font.Name:=Screen.MenuFont.Name;
 Form1.Font.Size:=14;
 Form1.BorderStyle:=bsDialog;
end;

procedure set_encryption_mode();
begin
Form1.OpenDialog1.Title:='Open a file';
Form1.OpenDialog1.DefaultExt:='*.*';
Form1.OpenDialog1.FileName:='*.*';
Form1.OpenDialog1.Filter:='All files|.*';
end;

procedure set_decryption_mode();
begin
Form1.OpenDialog1.Title:='Open a encrypted Black Ice container';
Form1.OpenDialog1.DefaultExt:='*.bef';
Form1.OpenDialog1.FileName:='*.bef';
Form1.OpenDialog1.Filter:='Black Ice container|.bef';
end;

procedure interface_setup();
begin
Form1.Button1.ShowHint:=False;
Form1.Button2.ShowHint:=Form1.Button1.ShowHint;
Form1.RadioButton1.Checked:=True;
Form1.RadioButton1.ShowHint:=Form1.Button1.ShowHint;
Form1.RadioButton2.ShowHint:=Form1.Button1.ShowHint;
Form1.LabeledEdit1.Text:='';
Form1.LabeledEdit2.Text:=Form1.LabeledEdit1.Text;
Form1.LabeledEdit1.LabelPosition:=lpLeft;
Form1.LabeledEdit2.LabelPosition:=Form1.LabeledEdit1.LabelPosition;
Form1.LabeledEdit1.Enabled:=False;
end;

procedure frontend_setup();
begin
Form1.OpenDialog1.InitialDir:='';
Form1.Process1.Executable:=ExtractFilePath(Application.ExeName)+'blackice';
end;

procedure common_setup();
begin
window_setup();
set_encryption_mode();
interface_setup();
frontend_setup();
end;

procedure language_setup();
begin
Form1.Button1.Caption:='Open';
Form1.Button2.Caption:='Start operation';
Form1.CheckBox1.Caption:='Hide typing password';
Form1.LabeledEdit1.EditLabel.Caption:='Target file';
Form1.LabeledEdit2.EditLabel.Caption:='Password';
Form1.Label1.Caption:='Mode';
Form1.RadioButton1.Caption:='Encryption';
Form1.RadioButton2.Caption:='Decryption';
end;

procedure setup();
begin
common_setup();
language_setup();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
Form1.Button2.Enabled:=check_input(Form1.LabeledEdit2.Text) and check_input(Form1.LabeledEdit1.Text);
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
Form1.Button2.Enabled:=check_input(Form1.LabeledEdit2.Text) and check_input(Form1.LabeledEdit1.Text);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
if Form1.RadioButton1.Checked=True then
begin
set_encryption_mode();
end
else
begin
set_decryption_mode();
end;
if Form1.OpenDialog1.Execute()=True then Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Form1.Process1.Parameters.Clear();
if Form1.RadioButton1.Checked=True then
begin
Form1.Process1.Parameters.Add('encrypt');
end
else
begin
Form1.Process1.Parameters.Add('decrypt');
end;
Form1.Process1.Parameters.Add(convert_file_name(Form1.LabeledEdit2.Text));
Form1.Process1.Parameters.Add(convert_file_name(Form1.LabeledEdit1.Text));
Form1.Process1.Execute();
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if Form1.CheckBox1.Checked=True then
begin
Form1.LabeledEdit2.PasswordChar:='*';
end
else
begin
Form1.LabeledEdit2.PasswordChar:=#0;
end;
Form1.LabeledEdit2.SetFocus();
end;

end.
