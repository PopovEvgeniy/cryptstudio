unit cryptstudiocode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs,
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
    procedure CheckBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LabeledEdit1Change(Sender: TObject);
    procedure LabeledEdit2Change(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

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
 Form1.Caption:='Crypt studio 1.0.3';
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
 Form1.Button2.ShowHint:=False;
 Form1.CheckBox1.Checked:=True;
 Form1.RadioButton1.Checked:=True;
 Form1.RadioButton1.ShowHint:=False;
 Form1.RadioButton2.ShowHint:=False;
 Form1.OpenDialog1.InitialDir:='';
 Form1.LabeledEdit1.Text:='';
 Form1.LabeledEdit2.Text:='';
 Form1.LabeledEdit1.LabelPosition:=lpLeft;
 Form1.LabeledEdit2.LabelPosition:=lpLeft;
 Form1.LabeledEdit1.Enabled:=False;
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
 window_setup();
 set_encryption_mode();
 interface_setup();
 language_setup();
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
 setup();
end;

procedure TForm1.LabeledEdit1Change(Sender: TObject);
begin
 Form1.Button2.Enabled:=(Form1.LabeledEdit2.Text<>'') and (Form1.LabeledEdit1.Text<>'');
end;

procedure TForm1.LabeledEdit2Change(Sender: TObject);
begin
 Form1.Button2.Enabled:=(Form1.LabeledEdit2.Text<>'') and (Form1.LabeledEdit1.Text<>'');
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
 set_encryption_mode();
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
 set_decryption_mode();
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 if Form1.OpenDialog1.Execute()=True then Form1.LabeledEdit1.Text:=Form1.OpenDialog1.FileName;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 do_job(Form1.Process1,Form1.LabeledEdit1.Text,Form1.LabeledEdit2.Text,Form1.RadioButton2.Checked);
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
 Form1.LabeledEdit2.PasswordChar:=#0;
 if Form1.CheckBox1.Checked=True then Form1.LabeledEdit2.PasswordChar:='*';
end;

end.
