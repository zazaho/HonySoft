unit Postcodeu;

interface

uses
  Forms, DBCtrls, StdCtrls, Mask, Buttons, Controls, Classes,
  ExtCtrls,SysUtils,Windows,Messages;

type
  TfPostcode = class(TForm)
    ScrollBox: TScrollBox;
    Label1: TLabel;
    EditNAAM: TDBEdit;
    Label2: TLabel;
    EditPOSTCODE: TDBEdit;
    Label3: TLabel;
    EditHSNR: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    DBNavigator: TDBNavigator;
    dblVK_NUMMER: TDBLookupComboBox;
    SpeedButton1: TSpeedButton;
    Label6: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    SpeedButton3: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure EditNAAMKeyPress(Sender: TObject; var Key: Char);
//    procedure EditVK_NUMMERKeyPress(Sender: TObject; var Key: Char);
    procedure dblVK_NUMMERClick(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure FormHide(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure dblVK_NUMMERKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dblVK_NUMMERKeyPress(Sender: TObject; var Key: Char);
    procedure PostRecord;
    procedure DBEdit1DblClick(Sender: TObject);
    procedure DBEdit1KeyPress(Sender: TObject; var Key: Char);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  fPostcode: TfPostcode;

implementation
Uses DataMod,CManageru,fVerkoperOu,Bde;

{$R *.DFM}

procedure TfPostcode.FormShow(Sender: TObject);
begin
     if not MastData.Postcode.Active then MastData.Postcode.Active := True;
//     MastData.Postcode.FieldByName('Postcode').EditMask := '0000\ >AA;1;_';
     if not MastData.Verkoper.Active then MastData.Verkoper.Active := True;
end;

procedure TfPostcode.FormHide(Sender: TObject);
begin
     HideVerkoperOverzicht;
     fPostcode.Close;
end;

procedure TfPostcode.PostRecord;
begin
With MastData.Postcode do
Begin
     If Not (State = dsEdit) Or (State = dsInsert) then Edit;
     Post;
     DbiSaveChanges(Handle);
     Insert;
     EditNaam.SetFocus;
     DBEdit1.ReadOnly := True;
     DBEdit2.ReadOnly := True;
End;
end;


procedure TfPostcode.EditNAAMKeyPress(Sender: TObject; var Key: Char);
begin
     If Key = #13 then
     Begin
          Perform(WM_NEXTDLGCTL,0,0);
          Key := #0;
     End;
end;

procedure TfPostcode.dblVK_NUMMERClick(Sender: TObject);

begin
          if not ((dsInsert = MastData.Postcode.State) or
          (dsEdit = MastData.Postcode.State))
          then MastData.Postcode.Edit;
          MastData.Postcode.FieldByName('VK_GROEP').Value :=
               MastData.Verkoper.FieldByName('VK_GROEP').Value;
          MastData.Postcode.FieldByName('VK_BEDRIJF').Value :=
               MastData.Verkoper.FieldByName('VK_BEDRIJF').Value;
end;

procedure TfPostcode.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
     If Button = nbInsert then
        EditNaam.SetFocus;
end;
procedure TfPostcode.SpeedButton1Click(Sender: TObject);
begin
     Lock;
end;

procedure TfPostcode.SpeedButton2Click(Sender: TObject);
begin
     ToonVerkoperOverzicht
end;

procedure TfPostcode.dblVK_NUMMERKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     If (ssCTRL in Shift) then
        if (key = vk_Down) then
           TDBLookUpComboBox(Sender).DropDown
        Else if (key = vk_Up) then
           TDBLookUpComboBox(Sender).CloseUp(False);
end;

procedure TfPostcode.dblVK_NUMMERKeyPress(Sender: TObject; var Key: Char);
begin
     If Key = #13 then
     Begin
          If dblVK_NUMMER.ListVisible then
          TDBLookUpComboBox(Sender).CloseUp(True)
          Else
          Begin
               MastData.Postcode.FieldByName('VK_GROEP').Value :=
                  MastData.Verkoper.FieldByName('VK_GROEP').Value;
               MastData.Postcode.FieldByName('VK_BEDRIJF').Value :=
                  MastData.Verkoper.FieldByName('VK_BEDRIJF').Value;
          PostRecord;
          End;
          Key := #0;
     End;

end;

procedure TfPostcode.DBEdit1DblClick(Sender: TObject);
begin
     TDBEdit(Sender).ReadOnly := False;
end;

procedure TfPostcode.DBEdit1KeyPress(Sender: TObject; var Key: Char);
begin
     If ( key = #13) And Not TDBEdit(Sender).readonly then
     Begin
          PostRecord;
          key := #0;
     End;
end;

end.
