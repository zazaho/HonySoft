unit CManageru;

interface

uses
    Forms, Menus, Classes, Controls, Buttons,initDb,SysUtils;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    miBestanden: TMenuItem;
    miVerkoper: TMenuItem;
    miDatabases: TMenuItem;
    ViewMenu: TMenuItem;
    InContractDatabase: TMenuItem;
    ViewStayOnTop: TMenuItem;
    HelpMenu: TMenuItem;
    HelpAbout: TMenuItem;
    InPostcodeDatabase1: TMenuItem;
    miPostcode: TMenuItem;
    miContract: TMenuItem;
    N3: TMenuItem;
    Afsluiten1: TMenuItem;
    Invoeren1: TMenuItem;
    Postcodes1: TMenuItem;
    Contracten1: TMenuItem;
    Verkopers1: TMenuItem;
    N1: TMenuItem;
    btContractIn: TSpeedButton;
    btPostcodeIn: TSpeedButton;
    btRapport: TSpeedButton;
    CloseBtn: TSpeedButton;
    Onderhoud1: TMenuItem;
    PostcodeDatabase1: TMenuItem;
    ContractDatabase1: TMenuItem;
    StatusCodes1: TMenuItem;
    procedure VerkoperIn(Sender: TObject);
    procedure CloseApp(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PostcodeIn(Sender: TObject);
    procedure ToggleStayonTop(Sender: TObject);
    procedure ContractIn(Sender: TObject);
    procedure btRapportClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure miDatabasesClick(Sender: TObject);
    procedure InPostcodeDatabase1Click(Sender: TObject);
    procedure UpdateBestandMenu;
    procedure InContractDatabaseClick(Sender: TObject);
    procedure ContractDatabase1Click(Sender: TObject);
    procedure StatusCodes1Click(Sender: TObject);
  private
    procedure CloseAllWindows;
  end;

var
  MainForm: TMainForm;

implementation

uses
   DataMod,  // Data Module
   About,    // De About dialog box
   contractu3,
   beheeru,
   Postcodeu,
   DataBasesu,
   qrRapportu,
   qryContract,
   VerwijderRecu,
   StatusCodesU,
   Utils,
   brPostcodeu;

{$R *.DFM}


procedure TMainForm.PostcodeIn(Sender: TObject);
begin
     Application.CreateForm(TfPostcode, fPostcode);
     fPostcode.ShowModal;
end;

procedure TMainForm.CloseApp(Sender: TObject);
begin
     Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
     Application.UpdateFormatSettings := False;
     ShortDateFormat := 'dd-mm-yyyy';
     LongDateFormat := 'dddd dd-mmmm-yyyy';
     DateSeparator := '-';
     initdb.ConnectDatabases;
     ReadStoredValues;
     UpdateBestandMenu;
     ClientWidth := CloseBtn.Left + CloseBtn.Width + btContractIn.Left;
     ClientHeight := 2*CloseBtn.Top + CloseBtn.Height;
     Left := 0;
     Top := 0;
end;

procedure TMainForm.UpdateBestandMenu;
Begin
     miVerkoper.Caption := initDb.verkoperdb;
     miPostcode.Caption := initDb.Postcodedb;
     miContract.Caption := initDb.Contractdb;
End;

procedure TMainForm.VerkoperIn(Sender: TObject);
begin
     Application.CreateForm(TfVerkoper, fVerkoper);
     fVerkoper.ShowModal;
end;


procedure TMainForm.ToggleStayonTop(Sender: TObject);
begin
     with Sender as TMenuItem do
     begin
          Checked := not Checked;
          if Checked then MainForm.FormStyle := fsStayOnTop
          else MainForm.FormStyle := fsNormal;
     end;
end;

procedure TMainForm.ContractIn(Sender: TObject);
begin
     Application.CreateForm(TfLijstIn, fLijstIn);
     if fLijstIn.Initialise then fLijstIn.ShowModal;
end;

procedure TMainForm.btRapportClick(Sender: TObject);
begin
     Application.CreateForm(TqrRapportf,qrRapportf);
     qrRapportf.ShowModal;
end;

procedure TMainForm.AboutClick(Sender: TObject);
begin
     Application.CreateForm(TAboutBox, AboutBox);
     AboutBox.ShowModal;
end;

procedure TMainForm.CloseAllWindows;
var
  I: Integer;
  F: TForm;
begin
  for I := 0 to Application.ComponentCount - 1 do
  begin
    if Application.Components[I] is TForm then
    begin
      F := TForm(Application.Components[I]);
      if (F <> Self) and (F.Visible) then F.Close;
    end;
  end;
end;

procedure TMainForm.InPostcodeDatabase1Click(Sender: TObject);
begin
     Application.CreateForm(TbrPostcodef, brPostcodef);
     brPostcodef.ShowInsert := False;
     brPostcodef.AllowEdit := True;
     brPostcodef.ShowModal;
end;

procedure TMainForm.miDatabasesClick(Sender: TObject);
begin
     Application.CreateForm(TDataBasesf,DataBasesf);
     DataBasesf.ShowModal;
     If DataBasesf.ModalResult = mrOK then
        if (DataBasesf.edit1.text <> verkoperdb) OR
           (DataBasesf.edit2.text <> postcodedb) OR
           (DataBasesf.edit3.text <> contractdb) Then
        begin
             initDb.DisConnectDataBases;
             initDb.ChangeDataBases(DataBasesf.edit1.text,
                                    DataBasesf.edit2.text,
                                    DataBasesf.edit3.text);
             initDb.ConnectDataBases;
             UpdateBestandMenu;
        end;
end;

procedure TMainForm.InContractDatabaseClick(Sender: TObject);
begin
     Application.CreateForm(TfqryContract,fqryContract);
     fqryContract.ShowModal;
end;


procedure TMainForm.ContractDatabase1Click(Sender: TObject);
begin
     Application.CreateForm(TfqrVerwijderRec,fqrVerwijderRec);
     With fqrVerwijderRec do
     Begin
          Datum := now - 91;
          DoContract := (Sender = ContractDatabase1);
          ShowModal;
          if modalResult = mrOK then
          Begin
               if (Sender = ContractDatabase1) then
               ArchiveerContract(edit1.text,Datum)
               Else
               ArchiveerPostcode(edit1.text,Datum);//
          End
     End

end;

procedure TMainForm.StatusCodes1Click(Sender: TObject);
begin
     Application.CreateForm(TfStatusCodes,fStatusCodes);
     fStatusCodes.ShowModal;
end;

end.
