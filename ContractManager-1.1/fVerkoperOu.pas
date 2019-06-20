unit fverkoperOu;

interface

uses
  Forms, DB, DBTables, StdCtrls,
  Classes, Controls, Grids, DBGrids;

type
  TfverkoperO = class(TForm)
    Query1: TQuery;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    rbNummer: TRadioButton;
    rbNaam: TRadioButton;
    rbGroep: TRadioButton;
    rbBedrijf: TRadioButton;
    procedure rbBedrijfClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Const
     OrderByStrings : Array[1..4] of String =
       ('Order By VK_NUMMER','Order By VK_NAAM',
       'Order By VK_GROEP','Order By VK_BEDRIJF');

var
  fverkoperO: TfverkoperO;

implementation
Uses initDb;

{$R *.DFM}

procedure TfverkoperO.rbBedrijfClick(Sender: TObject);
begin
     Query1.DisableControls;
     Query1.Active := False;
     Query1.Sql.Strings[2] := OrderByStrings[TRadioButton(Sender).Tag];
     Query1.Open;
     Query1.EnableControls;
end;

procedure TfverkoperO.FormCreate(Sender: TObject);
begin
     With Query1 do
     Begin
          Active := False;
          DatabaseName := initDb.RootDir+'Verkoper';
          Sql.Clear;
          Sql.Add('Select VK_NUMMER,VK_NAAM,VK_GROEP,VK_BEDRIJF');
          Sql.Add('From "'+initDb.Verkoperdb+'"');
          Sql.Add(OrderByStrings[1]);
          Open;
     End;
     With DbGrid1 do
     Begin
          rbNummer.Left := Left+5;
          rbNaam.Left := rbNummer.Left+Columns[0].Width;
          rbGroep.Left := rbNaam.Left+Columns[1].Width;
          rbBedrijf.Left := rbGroep.Left+Columns[2].Width;
     End;
end;

procedure TfverkoperO.FormActivate(Sender: TObject);
begin
     Query1.Open;
     DbGrid1.Enabled := True;
end;

procedure TfverkoperO.FormDeactivate(Sender: TObject);
begin
     DbGrid1.Enabled := False;
//     Query1.Close;
end;

end.
