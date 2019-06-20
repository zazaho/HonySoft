unit DataMod;

{ See the comments in MAIN.PAS for information about this project }

interface

uses
  Windows, SysUtils,Controls, Forms, Dialogs,
  DB, DBTables, AmLock,Bde, Classes;

type
  TMastData = class(TDataModule)
    Verkoper: TTable;
    contract: TTable;
    postcode: TTable;
    VerkoperSrc: TDataSource;
    ContractSrc: TDataSource;
    PostcodeSrc: TDataSource;
    postcodeAutoinc: TAutoIncField;
    postcodeNAAM: TStringField;
    postcodePOSTCODE: TStringField;
    postcodeHSNR: TStringField;
    postcodeVK_GROEP: TStringField;
    postcodeVK_NUMMER: TStringField;
    postcodeDTM_MUTATIE: TDateField;
    postcodeVK_BEDRIJF: TStringField;
    AmLockApp1: TAmLockApp;
    BatchMove1: TBatchMove;
    tbTemp: TTable;
    procedure postcodeBeforePost(DataSet: TDataSet);
  end;
Procedure Lock;
Procedure ToonVerkoperOverzicht;
Procedure HideVerkoperOverzicht;

Procedure CopyFiles(FromDir,ToDir,FromFiles,ToFiles:String);
Procedure ArchiveerContract(FileName:String;Datum:TDateTime);
Procedure ArchiveerPostcode(FileName:String;Datum:TDateTime);

var
  MastData: TMastData;

implementation

Uses fVerkoperOu,initDb;


Procedure ArchiveerContract(FileName:String;Datum:TDateTime);
Var
   NumRecVoor:Integer;
begin
     CopyFiles(initDb.RootDir+'templat\contract\',initDb.RootDir+'contract\',
     'contract',Copy(FileName,1,length(FileName)-length(ExtractFileExt(FileName))));
     with MastData.Contract do
     Begin
          filterOptions := [foCaseInsensitive];
          Filter := '(DTM_VERZND <= ' + DateToStr(Datum) +
          ') And (Not Status = ' + '''' + 'B*' + '''' + ')' ;
          Filtered := true;
     End;
     If MastData.Contract.RecordCount > 0 then
     Begin
          With MastData.tbTemp do
          Begin
               DataBaseName := initDb.RootDir+'contract';
               TableName := FileName;
               Open;
               NumRecVoor:= RecordCount;
          End;
          With MastData.BatchMove1 do
          Begin
               Source := MastData.Contract;
               Execute;
          End;
          DbiSaveChanges(MastData.tbTemp.Handle);
          If (MastData.tbTemp.RecordCount - NumRecVoor =
             MastData.Contract.RecordCount) OR
             (MessageDlg('Er zijn :'+IntToStr(MastData.tbTemp.RecordCount - NumRecVoor)+
             ' bewaard. Maar er worden er: '+IntToStr(MastData.Contract.RecordCount)+
             ' verwijderd. Doorgaan ?',mtConfirmation,[mbCancel,mbOk],0) = mrOk)
          then
          Begin
          With MastData.Contract do
          Begin
               First;
               Repeat delete until EOF;
               Filtered := False;
               Filter := '';
          End;
          DbiSaveChanges(MastData.Contract.Handle);
          End;
          MastData.tbTemp.Active := False;
          MastData.tbTemp.TableName := '';
     End
     Else
         ShowMessage('Er zijn geen geannuleerde/getekende records die zo oud zijn');
end;

Procedure ArchiveerPostcode(FileName:String;Datum:TDateTime);
Var
   NumRecVoor:Integer;
begin
     CopyFiles(initDb.RootDir+'templat\postcode\',initDb.RootDir+'postcode\',
     'postcode',Copy(FileName,1,length(FileName)-length(ExtractFileExt(FileName))));
     with MastData.Postcode do
     Begin
          Filter := 'DTM_MUTATIE <= '+DateToStr(Datum);
          Filtered := true;
     End;
     If MastData.Postcode.RecordCount > 0 then
     Begin
          With MastData.tbTemp do
          Begin
               DataBaseName := initDb.RootDir+'postcode';
               TableName := FileName;
               Open;
               NumRecVoor := RecordCount;
          End;
          With MastData.BatchMove1 do
          Begin
               Source := MastData.Postcode;
               Execute;
          End;
          DbiSaveChanges(MastData.tbTemp.Handle);
          If (MastData.tbTemp.RecordCount - NumRecVoor =
             MastData.Postcode.RecordCount) OR
             (MessageDlg('Er zijn :'+IntToStr(MastData.tbTemp.RecordCount - NumRecVoor)+
             ' bewaard. Maar er worden er: '+IntToStr(MastData.Postcode.RecordCount)+
             ' verwijderd. Doorgaan ?',mtConfirmation,[mbCancel,mbOk],0) = mrOk)
          then
          With MastData.Postcode do
          Begin
               First;
               Repeat delete until EOF;
               Filtered := False;
               Filter := '';
          End;
          DbiSaveChanges(MastData.Postcode.Handle);
          MastData.tbTemp.Active := False;
          MastData.tbTemp.TableName := '';
     End
     Else
         ShowMessage('Er zijn geen records die zo oud zijn');
end;

Procedure CopyFiles(FromDir,ToDir,FromFiles,ToFiles:String);
Var
   Result:Integer;
   SearchRec:TSearchRec;
   DummyFrom,DummyTo:String;

begin
     Result := FindFirst(FromDir+FromFiles+'.*', faAnyFile, SearchRec);
     while Result = 0 do
     begin
          DummyFrom := FromDir+SearchRec.Name+#0;
          DummyTo := ToDir+ToFiles+ExtractFileExt(SearchRec.Name)+ #0;
          CopyFile(@DummyFrom[1],@DummyTo[1],TRUE);
          Result := FindNext(SearchRec);
     end;
     FindClose(SearchRec);
End;

Procedure Lock;
Begin
     MastData.AmLockApp1.OnLockUnlock;
End;

Procedure ToonVerkoperOverzicht;
begin
     Application.CreateForm(TfVerkoperO,fVerkoperO);
     fVerkoperO.Show;
end;

Procedure HideVerkoperOverzicht;
var
  I: Integer;
  F: TForm;
begin
  for I := 0 to Application.ComponentCount - 1 do
  begin
    if Application.Components[I] = fVerkoperO then
    begin
      F := TForm(Application.Components[I]);
      if F.Visible then F.Close;
    end;
  end;
end;

{$R *.DFM}

{ Utility Functions }

procedure TMastData.postcodeBeforePost(DataSet: TDataSet);
begin
     MastData.Postcode.FieldByName('DTM_Mutatie').Value := Date;
end;

end.

