unit contractu3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Dialogs,
  DBTables, DB, Grids, DBGrids,DBCtrls, Led,
  initdb,Utils, Buttons,Bde,DataMod, Controls,
  StdCtrls, Mask, ExtCtrls;

type
  TfLijstIn = class(TForm)
    tbTemp: TTable;
    lbVerkoopgroep: TLabel;
    lbVerkoper: TLabel;
    BSLed1: TBSLed;
    btOK: TButton;
    btStop: TButton;
    btOverslaan: TButton;
    dbgPostcode: TDBGrid;
    DataSource1: TDataSource;
    Panel1: TPanel;
    dbe: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    DBEdit10: TDBEdit;
    DBEdit14: TDBEdit;
    eVK_GROEP: TEdit;
    eVK_NUMMER: TEdit;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    eVK_BEDRIJF: TEdit;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SkipLijst: TButton;
    DBEdit15: TDBEdit;
    procedure dbeVerkoopgroepKeyPress(Sender: TObject; var Key: Char);
    procedure dbgPostcodeDblClick(Sender: TObject);
    function Initialise:Boolean;
    procedure btOKClick(Sender: TObject);
    procedure FindNextUnknown;
    procedure btStopClick(Sender: TObject);
    procedure btOverslaanClick(Sender: TObject);
    procedure dbgPostcodeColEnter(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    Function ScanForFiles: Boolean;
    Procedure DoNextTable;
    Procedure MaakTotalen;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure eVK_GROEPDblClick(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SkipLijstClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    fWaiting:Boolean;
    procedure SetWaiting(Value:Boolean);
    { Private declarations }
  public
     Property Waiting: Boolean Read FWaiting Write SetWaiting Default False;
    { Public declarations }
  end;

Function ChangeExt(FileName:TFileName;NewExt:String):String;
Function GetLijstNummer(FileName:TFileName):Integer;
Function GetShortFileName(Const FileName : String) : String;

var
  fLijstIn: TfLijstIn;
  FileList:TStringList;
  CurrentFile,LijstNummer:Integer;
  ZipName:TFileName;

Const
     FieldNames: Array[1..22] of String =
     ('Contract','Dtm_verznd','Dtm_retour','Product','PROVTMBDG','Status',
     'Oorsprong','Telefoon','Naam','Straat','Hsnr','Hsto','Postcode',
     'Woonplaats','Klant_status','wkn_verznd','wkn_retour','Vk_groep','Vk_Nummer',
     'Bedrag_retour','Dtm_mutatie','Vk_Bedrijf');
implementation

uses brPostcodeu, qrVERZDTMu,qryWeekNumu,Totalenu;
{$R *.DFM}

procedure TfLijstIn.SetWaiting(Value:Boolean);
Begin
     FWaiting := Value;
     btOk.Enabled := Value;
     btStop.Enabled := Value;
     btOverslaan.Enabled := Value;
     SkipLijst.Enabled := Value;
     dbgPostcode.Enabled := Value;
     BsLed1.LightOn := Value;
     if not value then Screen.Cursor := crHourglass else Screen.Cursor := crDefault;
End;

function TfLijstIn.Initialise:Boolean{FormShow(Sender: TObject)};
Var
   OpenDialog: TopenDialog;
   ZipBestandNaam: String;
   LijstGekozen: Boolean;

begin
     Result := True;
     FileList := TStringlist.Create;
     FileList.Clear;
     FileList.Duplicates := dupIgnore;
     FileList.Sorted := True;
     with MastData.Postcode do
     Begin
          Active := False;
          MasterSource := Datasource1;
          MasterFields := 'Postcode;Hsnr';
          IndexName := 'Posthuis';
          Active := True;
     End;
     With MastData.Contract do
     Begin
          Active := False;
          ReadOnly := False;
          Active := True;
     End;
     dbgPostCode.DataSource := MastData.PostcodeSrc;
     dbgPostcode.Enabled := True;

     OpenDialog := TOpenDialog.Create(fLijstIn);
     With OpenDialog Do
     Begin
          DefaultExt := 'zip';
          InitialDir := InitDb.uploaddir;
          Title := 'Kies de nieuwe lijst die u wilt toevoegen';
          Options := [ofHideReadOnly,ofNoChangeDir,ofFileMustExist];
          Filter := 'Zip Archief|*.ZIP';
          LijstGekozen := Execute;
          ZipBestandNaam := OpenDialog.FileName;
          ZipName := OpenDialog.FileName;
          Free;
     End;
     If LijstGekozen then
     Begin
          if ExtractFilePath(ZipName) <> uploaddir then
              WriteNewUploadDir(ExtractFilePath(ZipName));
          LijstNummer := GetLijstNummer(ZipName);
          Caption := Caption + ' week: '+IntToStr(LijstNummer) ;
          WinExecAndWait32(
          'c:\command.com /c '+GetShortFileName(initDb.RootDir+'pkunzip.exe')+
          ' -o "' + GetShortFileName(ZipBestandNaam)+'" '
          +GetShortFileName(initdb.RootDir+'temp')+'\',SW_SHOWMINIMIZED);
          If ScanForFiles then MaakTotalen
          else MessageDlg('Kan de zipfile niet uit pakken,'+#13+
                          'of deze zipfile bevat geen lijsten.',mtError,[mbok],0);
     End
     Else
     Begin
         FLijstIn.Release;
         Result := False;
         exit;
     End
end;

Function GetLijstNummer(FileName:TFileName):Integer;
Const
     Nummers = ['0'..'9'];
Var
   i,LijstNummer:Integer;
   dummy:String;

Begin
     Dummy := ExtractFileName(FileName);
     Dummy := Copy(Dummy,1,Length(Dummy)-Length(ExtractFileExt(Dummy)));
     i := 1;
     While Not(Dummy[i] in Nummers) do
     Inc(i);
     Try
        LijstNummer := StrToInt(Copy(Dummy,i,6));
     Except
           Application.CreateForm(TfqryWeekNum,fqryWeekNum);
           fqryWeekNum.FileName := FileName;
           fqryWeekNum.ShowModal;
           LijstNummer := fqryWeekNum.LijstNum;
     End;
     If LijstNummer < 199001 then
     Begin
          If LijstNummer < 9001 then
             LijstNummer := LijstNummer + 200000
          Else if LijstNummer <= 9953 then
             LijstNummer := LijstNummer + 190000
          Else
          Begin
               Application.CreateForm(TfqryWeekNum,fqryWeekNum);
               fqryWeekNum.FileName := FileName;
               fqryWeekNum.ShowModal;
               LijstNummer := fqryWeekNum.LijstNum;
          End;
     End;
     Result := LijstNummer;
End;


Function TfLijstIn.ScanForFiles: Boolean;
var
   SResult: Integer;
   SearchRec: TSearchRec;
begin
    SResult := FindFirst(initdb.RootDir+'temp\*.dbf', 63, SearchRec);
    while SResult = 0 do
    Begin
    FileList.Add(ExtractFileName(SearchRec.Name));
    SResult := FindNext(SearchRec);
    End;
    FindClose(SearchRec);
    SResult := FindFirst(initdb.RootDir+'temp\*.csv', 63, SearchRec);
    while SResult = 0 do
    Begin
         FileList.Add(ChangeExt(initdb.RootDir+'temp\'+SearchRec.Name,'txt'));
         SResult := FindNext(SearchRec) ;
    end;
    FindClose(SearchRec);
    CurrentFile := -1;
    Result := ( FileList.Count > 0);
end;

Function ChangeExt(FileName:TFileName;NewExt:String):String;
Var
   NewFileName:String;
Begin
     NewFileName := Copy( ExtractFileName(FileName),1,
     Length(ExtractFileName(FileName))-Length(ExtractFileExt(FileName)) )+'.'+NewExt;
     RenameFile(FileName,ExtractFilePath(FileName)+ NewFileName);
     Result := NewFileName;
End;

Procedure TfLijstIn.MaakTotalen;
Begin
     if FileLIst.count > 0 then
     Begin
          Application.CreateForm(tTotalen,Totalen);
          Totalen.ShowModal;
     End;
End;


Procedure TfLijstIn.DoNextTable;
Begin
     CurrentFile := CurrentFile+1;
     If CurrentFile = FileList.Count then
     Begin
          if fLijstIn.Visible then
          Begin
               ShowMessage('Laatste lijst Toegevoegd');
               fLijstIn.Close;
          End;
          Exit;
     End
     Else
     With tbTemp do
     Begin
          Active := False;
          DataBaseName := initdb.RootDir+'temp';
          TableName := FileList.Strings[CurrentFile];
          try
             open;
          except
                ShowMessage('Ik kan de nieuwe gegevens in: '
                +FileList.Strings[CurrentFile]+' niet lezen');
                Exit;
          End;
          First;
     End;
     FindNextUnknown;
End;

procedure TfLijstIn.FindNextUnknown;
var
   i: Integer;
Begin
  tbTemp.DisableControls;
  Waiting := False;
  With MastData.Contract DO
  Begin
       Filter := FieldNames[1]+' = '+tbTemp.FieldByName(FieldNames[1]).AsString;
       While FindFirst Do
       Begin
            Edit;
            for i := 2 to 15 do FieldByName(FieldNames[i]).Value :=
                                tbTemp.FieldByName(FieldNames[i]).Value;

            FieldByName('Dtm_mutatie').Value := Date;
            If iIsSub('"'+FieldByName('Status').AsString+'"',rtrString)
            Then
            Begin
                 FieldByName('Bedrag_retour').Value :=
                    FieldByName('PROVTMBDG').Value;
                 if UseWeekNummer then
                     FieldByName('wkn_retour').value :=
                        tbTemp.FieldByName('wkn_retour').value
                 else FieldByName('wkn_retour').AsInteger := LijstNummer;
            End
            Else FieldByName('Bedrag_retour').Value := 0;
            Post;
            DbiSaveChanges(Handle);
            tbTemp.Next;
            If tbTemp.EOF then
            Begin
                 DoNextTable;
                 Exit;
            End;
            Filter := FieldNames[1]+' = '+
              tbTemp.FieldByName(FieldNames[1]).AsString;
       End;
  End;
  eVK_GROEP.Text := '';
  eVK_NUMMER.Text := '';
  eVK_BEDRIJF.Text := '';
  tbTemp.EnableControls;
  eVK_NUMMER.SetFocus;
  Waiting := True;
  btOk.Enabled := False;
  if iIsSub('"'+tbTemp.FieldByName('Status').AsString+'"',
                bkrString+','+rtrString+','+vrzString+','+annString) then
                btOk.Enabled := True;
End;

procedure TfLijstIn.btOKClick(Sender: TObject);

Var
   I :Integer;
Begin
     If (eVK_NUMMER.Text = '') OR (eVK_GROEP.Text = '') then
     Begin
          ShowMessage('U heeft niet alle gegevens ingevuld'+#13+
                      'Verkoper en/of Groep zijn leeg');
          Exit;
     End;
     With MastData.Contract Do
     Begin
          Insert;
          For i := 1 to 15 Do
          Begin
               FieldByName(FieldNames[i]).Value :=
               tbTemp.FieldByName(FieldNames[i]).Value;
          End;
          if UseWeekNummer then
          Begin
               FieldByName('wkn_verznd').Value :=
               tbTemp.FieldByName('wkn_verznd').Value;
               FieldByName('wkn_retour').Value :=
               tbTemp.FieldByName('wkn_retour').Value;
          End;
          If FieldByName('Dtm_verznd').Value = null then
          Begin
              Application.CreateForm(TqrVERZDTMf,qrVERZDTMf);
              qrVERZDTMf.Edit1.Text := DateToStr(FieldByName('Dtm_retour').Value);
              qrVERZDTMf.ShowModal;
              FieldByName('Dtm_verznd').Value := StrToDate(qrVERZDTMf.Edit1.Text);
          End;
          FieldByName('Vk_groep').AsString :=  eVK_GROEP.Text;
          FieldByName('Vk_Nummer').AsString := eVK_NUMMER.Text;
          FieldByName('Vk_Bedrijf').AsString := eVK_BEDRIJF.Text;
          If iIsSub('"'+FieldByName('Status').AsString+'"',rtrString)
          Then
          Begin
               FieldByName('Bedrag_retour').Value :=
                 FieldByName('PROVTMBDG').Value;
               if Not UseWeekNummer then FieldByName('wkn_retour').AsInteger := LijstNummer;
          End
          Else
          Begin
               FieldByName('Status').Value := 0;
               if Not UseWeekNummer then FieldByName('wkn_verznd').AsInteger := LijstNummer;
          End;
          FieldByName('Dtm_mutatie').Value := Date;
          Post;
          DbiSaveChanges(Handle);
     End;
     tbTemp.Next;
     If not tbTemp.EOF then
     Begin
          FindNextUnknown;
     End
     Else
     Begin
         DoNextTable;
         Exit;
     End;
End;

procedure TfLijstIn.dbeVerkoopgroepKeyPress(Sender: TObject; var Key: Char);
begin
     If Key = #13 then
     Begin
          MastData.Verkoper.Filter :=
          ('VK_NUMMER = '+''''+eVK_NUMMER.Text+'''');
          If MastData.Verkoper.FindFirst then
          Begin
               eVK_GROEP.Text := MastData.Verkoper.FieldByName('VK_GROEP').Value;
               eVK_BEDRIJF.Text := MastData.Verkoper.FieldByName('VK_BEDRIJF').Value;
               Perform(WM_NextDLGCTL,0,0);
          End
          Else
          Begin
               ShowMessage('Deze Verkoper bestaat niet.');
               eVK_NUMMER.Text := '';
          End;
          Key := #0;
     End;
end;

procedure TfLijstIn.dbgPostcodeDblClick(Sender: TObject);
begin
     eVK_GROEP.Text := MastData.Postcode.FieldByName('Vk_groep').AsString;
     eVK_NUMMER.Text := MastData.Postcode.FieldByName('Vk_Nummer').AsString;
     eVK_BEDRIJF.Text := MastData.Postcode.FieldByName('Vk_Bedrijf').AsString;
     btOK.Click;
end;

procedure TfLijstIn.btStopClick(Sender: TObject);
begin
     if MessageDlg('Niet alle gegevens zijn ingevoerd,'+#13+'toch stoppen ?', mtConfirmation, [mbOk,mbCancel], 0)
     = mrOk then fLijstIn.Close;
end;

procedure TfLijstIn.btOverslaanClick(Sender: TObject);
begin
     tbTemp.Next;
     If not tbTemp.EOF then
     Begin
         FindNextUnknown;
     End
     Else
     Begin
         DoNextTable;
         Exit;
     End;
end;

procedure TfLijstIn.dbgPostcodeColEnter(Sender: TObject);
begin
     eVK_GROEP.Text := MastData.Postcode.FieldByName('Vk_groep').AsString;
     eVK_NUMMER.Text := MastData.Postcode.FieldByName('Vk_Nummer').AsString;
     eVK_BEDRIJF.Text := MastData.Postcode.FieldByName('Vk_Bedrijf').AsString;
end;

procedure TfLijstIn.SpeedButton1Click(Sender: TObject);
begin
     Application.CreateForm(TbrPostcodef,brPostcodef);
     brPostcodef.AllowEdit := False;
     brPostcodef.ShowInsert := True;
     brPostcodef.ShowModal;
     if brPostcodef.ModalResult = mrYes then
     Begin
          eVK_NUMMER.Text := brPostcodef.VK_NUMMER;
          eVK_GROEP.Text := brPostcodef.VK_GROEP;
          eVK_BEDRIJF.Text := brPostCodef.VK_BEDRIJF;
     End;
end;

procedure TfLijstIn.FormClose(Sender: TObject; var Action: TCloseAction);
Var
   i:Integer;
begin
       dbgPostcode.Enabled := False;
       with MastData.Postcode do
       Begin
            Active := False;
            MasterSource := nil;
            MasterFields := '';
            IndexName := '';
       End;
       fLijstIn.Close;
       tbTemp.Active := False;
       tbTemp.TableName := '';
       For i := 0 to FileList.Count -1 do
         DeleteFile(initdb.RootDir+'temp\'+FileList.Strings[i]);
       If FileList.Count > 0 Then
       If MessageDlg('Wilt u de lijst '+ExtractFileName(ZipName)+' verplaatsen'+#13+
       'naar de verwerkte lijsten folder?',mtInformation, [mbOK,mbNo], 0)
       = mrOk Then
       RenameFile(initDb.RootDir+'\upload\'+ExtractFileName(ZipName),
          initDb.RootDir+'\lijsten\'+ExtractFileName(ZipName));
       FileList.Free;
       HideVerkoperOverzicht;
end;

procedure TfLijstIn.eVK_GROEPDblClick(Sender: TObject);
begin
     TEdit(Sender).ReadOnly := False;
     TEdit(Sender).Color := clWindow;
end;

procedure TfLijstIn.SpeedButton2Click(Sender: TObject);
begin
     Lock;
end;

procedure TfLijstIn.SpeedButton3Click(Sender: TObject);
begin
     ToonVerkoperOverzicht;
end;

procedure TfLijstIn.SkipLijstClick(Sender: TObject);
begin
     DoNextTable;
end;

Function GetShortFileName(Const FileName : String) : String;
var
  aTmp: array[0..255] of char;
begin
  if GetShortPathName(PChar(FileName+#0),aTmp,Sizeof(aTmp)-1)=0 then
     Result:= FileName
  else
     Result:=StrPas(aTmp);
end;

procedure TfLijstIn.FormShow(Sender: TObject);
begin
     DoNextTable;
end;

End.

