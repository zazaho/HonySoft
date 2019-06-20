unit Beheeru;

interface

uses
  Forms, DB, DBTables, Grids,DBGrids, DBCtrls, StdCtrls,
  Mask, Buttons, Controls, ExtCtrls, ComCtrls,
  Classes,Graphics,Messages,Windows;

type
  TfVerkoper = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    DBNavigator: TDBNavigator;
    Panel2: TPanel;
    ScrollBox: TScrollBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditVK_NAAM: TDBEdit;
    EditVK_NUMMER: TDBEdit;
    DBGrid1: TDBGrid;
    lBedrijf: TLabel;
    eVK_BEDRIJF: TDBEdit;
    Query1: TQuery;
    DataSource1: TDataSource;
    dblVK_GROEP: TDBLookupComboBox;
    eVK_GROEP: TDBEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure EditVK_GROEPKeyPress(Sender: TObject; var Key: Char);
    procedure TabSheet3Enter(Sender: TObject);
    procedure TabSheet3Exit(Sender: TObject);
    procedure dblVK_GROEPCloseUp(Sender: TObject);
    procedure EditVK_NAAMKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    Procedure PostRecord;
    procedure eVK_BEDRIJFEnter(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fVerkoper: TfVerkoper;


implementation
Uses DataMod,initDb;
{$R *.DFM}

procedure TfVerkoper.FormCreate(Sender: TObject);
begin
     PageControl1.ActivePage := TabSheet2;
     fVerkoper.ActiveControl := EditVK_Naam;
     if not MastData.Verkoper.Active then MastData.Verkoper.Active := True;
     MastData.Verkoper.Edit;
     With Query1 do
     begin
          DatabaseName := initDb.RootDir+'Verkoper';
          Sql.Clear;
          Sql.Add('Select Distinct VK_GROEP,VK_BEDRIJF from "'+initDb.verkoperDb+'"');
          Open;
     end;
end;

Procedure TfVerkoper.PostRecord;
begin
     If Not((MastData.Verkoper.State = dsEdit) OR (MastData.Verkoper.State = dsInsert)) then
     MastData.Verkoper.Edit;
     MastData.Verkoper.Post;
     MastData.Verkoper.Insert;
     EditVK_NAAM.SetFocus;
     If dblVK_GROEP.Text = '' then
     Begin
          Query1.Active := False;
          Query1.Open;
          With eVK_BEDRIJF do
          Begin
               ReadOnly := True;
               Color := clbtnFace;
          End

     End;
end;


procedure TfVerkoper.EditVK_GROEPKeyPress(Sender: TObject; var Key: Char);
begin
     If Key = #13 then
     Begin
          if Sender = eVK_BEDRIJF then
               PostRecord
          Else if Sender = eVK_GROEP then
          Begin
               MastData.Verkoper.FieldByName('VK_BEDRIJF').AsString :=
                          Query1.FieldByName('VK_BEDRIJF').AsString;
               eVK_Bedrijf.SetFocus;
          End
          Else perform(WM_NextDlgCtl,0,0);
          Key := #0;
     End;
end;

procedure TfVerkoper.TabSheet3Enter(Sender: TObject);
begin
     DBGrid1.Enabled := True;
     DBGrid1.DataSource := MastData.VerkoperSrc;
end;

procedure TfVerkoper.TabSheet3Exit(Sender: TObject);
begin
     DBGrid1.Enabled := False;
     DBGrid1.DataSource := nil;
end;



procedure TfVerkoper.dblVK_GROEPCloseUp(Sender: TObject);
begin
     MastData.Verkoper.FieldByName('VK_BEDRIJF').AsString :=
                Query1.FieldByName('VK_BEDRIJF').AsString;
end;

procedure TfVerkoper.EditVK_NAAMKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (Sender = dblVK_GROEP) And (Key = VK_RETURN) Then
     Begin
          dblVK_GROEP.CloseUp(True);
          eVK_Bedrijf.SetFocus;
     End
     Else
     if ssCtrl in Shift then
     Begin
          if (Sender = eVK_GROEP) AND (Key = VK_DOWN) then
          Begin
               dblVK_GROEP.DropDown;
               dblVK_GROEP.SetFocus;
          End

          Else
          If Key = VK_RETURN then
          PostRecord
     End
end;

procedure TfVerkoper.eVK_BEDRIJFEnter(Sender: TObject);
begin
     With eVK_BEDRIJF do
     Begin
          If dblVK_GROEP.Text = '' then
          Begin
               ReadOnly := False;
               Color := clWindow;
          End
     End
end;

procedure TfVerkoper.FormHide(Sender: TObject);
begin
     MastData.Verkoper.Cancel;
     Query1.Close;
     DBGrid1.Enabled := False;
     DBGrid1.DataSource := nil;
     HideVerkoperOverzicht;
end;

procedure TfVerkoper.SpeedButton1Click(Sender: TObject);
begin
     Lock;
end;

procedure TfVerkoper.SpeedButton2Click(Sender: TObject);
begin
     ToonVerkoperOverzicht;
end;

end.
