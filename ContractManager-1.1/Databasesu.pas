unit Databasesu;

interface

uses
  {Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons}Forms, Dialogs, Buttons, StdCtrls, Controls,
  Classes, ExtCtrls,SysUtils;

type
  TDatabasesf = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    Panel2: TPanel;
    Label2: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Panel3: TPanel;
    Label3: TLabel;
    Edit3: TEdit;
    Button3: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Databasesf: TDatabasesf;

implementation
Uses initdb;
{$R *.DFM}

procedure TDatabasesf.Button1Click(Sender: TObject);
begin
     With OpenDialog1 do
     Begin
          FileName := edit1.text;
          InitialDir := initdb.RootDir+'verkoper';
          Title := 'Kies de lijst waarin de verkopers gegevens zich bevinden';
          if Execute then edit1.text := ExtractFileName(FileName);
     End
end;

procedure TDatabasesf.Button2Click(Sender: TObject);
begin
     With OpenDialog1 do
     Begin
          FileName := edit2.text;
          InitialDir := initdb.RootDir+'postcode';
          Title := 'Kies de lijst waarin de postcode gegevens zich bevinden';
          if Execute then edit2.text := ExtractFileName(FileName);
     End
end;

procedure TDatabasesf.Button3Click(Sender: TObject);
begin
     With OpenDialog1 do
     Begin
          FileName := edit3.text;
          InitialDir := initdb.RootDir+'contract';
          Title := 'Kies de lijst waarin de contract gegevens zich bevinden';
          if Execute then edit3.text := ExtractFileName(FileName);
     End

end;

procedure TDatabasesf.FormCreate(Sender: TObject);
begin
     edit1.Text := initdb.VerkoperDb;
     edit2.Text := initdb.PostCodeDb;
     edit3.Text := initdb.ContractDb;
end;

end.
