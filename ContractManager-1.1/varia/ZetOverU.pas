unit ZetOverU;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, Forms, DBCtrls, DB,Bde, Dialogs, DBTables, Mask, ExtCtrls;

type
  TfZetOver = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditVK_NUMMER: TDBEdit;
    Label2: TLabel;
    EditVK_GROEP: TDBEdit;
    Label3: TLabel;
    EditVK_NAAM: TDBEdit;
    Label4: TLabel;
    EditVK_BEDRIJF: TDBEdit;
    DataSource1: TDataSource;
    Panel2: TPanel;
    Table1: TTable;
    Table2: TTable;
    Button1: TButton;
    Ok: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure OkClick(Sender: TObject);
    Procedure DoOne;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { private declarations }
  public
    { public declarations }
  end;
var
  fZetOver: TfZetOver;

implementation

{$R *.DFM}

procedure TfZetOver.Button1Click(Sender: TObject);
begin
     With OpenDialog1 do
     Begin
          InitialDir := ExtractFilePath(Application.ExeName);
          Title := 'Kies de lijst waarin de oude verkopers gegevens zich bevinden';
          if Execute then
          Begin
               with table2 do
               Begin
                    Active := False;
                    DatabaseName := ExtractFilePath(FileName);
                    TableName := ExtractFileName(FileName);
                    Open;
                    First;
               End;
               Title := 'Kies de lijst waar de nieuwe verkopers gegevens in moeten';
               FileName := '';
               if Execute then
               Begin
                    With Table1 do
                    Begin
                         Active := False;
                         DatabaseName := ExtractFilePath(FileName);
                         TableName := ExtractFileName(FileName);
                         Open;
                         First;
                    End;
                    DoOne;
               End;
          End;
     End;
end;

Procedure TfZetOver.DoOne;
begin
     With Table2 do
     Begin
         If not EOF then
         Begin
               Table1.Insert;
               Table1.FieldByName('VK_NAAM').Value := FieldByName('VK_NAAM').Value;
               Table1.FieldByName('VK_NUMMER').Value := FieldByName('VK_NUMMER').Value;
               Table1.FieldByName('VK_GROEP').Value := FieldByName('VK_GROEP').Value;
         End
         Else
         Begin
              ShowMessage('Klaar!');
              fZetOver.Close;
              Exit;
         End;
     End;
end;
procedure TfZetOver.OkClick(Sender: TObject);
begin
     Table1.POst;
     DbiSaveChanges(Table1.Handle);
     Table1.Next;
     Table2.Next;
     DoOne;
end;

procedure TfZetOver.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Table1.Close;
     Table2.Close;
     DbiSaveChanges(Table1.Handle);
end;

end.