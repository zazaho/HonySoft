unit COmzetRu;

interface

uses
  Forms, DBTables, DB,
  Tquerypl, Quickrep, Controls, StdCtrls, Classes, ExtCtrls,SysUtils;

type
  TfPercentR2 = class(TForm)
    Title: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
    qrbGroephdr: TQRBand;
    QRDBText1: TQRDBText;
    QRLabel1: TQRLabel;
    qrbVerkoopInfo: TQRBand;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText6: TQRDBText;
    qrbSelectie: TQRBand;
    SelectieText: TQRLabel;
    qrbGroepftr: TQRBand;
    QRShape3: TQRShape;
    QRDBCalc2: TQRDBCalc;
    QRLabel2: TQRLabel;
    QRShape1: TQRShape;
    qrbPaginaftr: TQRBand;
    QRSysData3: TQRSysData;
    qrbSummary: TQRBand;
    QRDBCalc1: TQRDBCalc;
    ColumnHeader: TQRBand;
    QRLabel4: TQRLabel;
    QuickReport: TQuickReport;
    QRDetailLink2: TQRDetailLink;
    qryBedrijf: TQuery;
    qryGroep: TQuery;
    BedrijfSrc: TDataSource;
    Groepsrc: TDataSource;
    qryNaam: TQuery;
    NaamSrc: TDataSource;
    EnhQuery1: TEnhQuery;
    qryVerkoper: TQuery;
    NummerSrc: TDataSource;
    qrbBedrijfhdr: TQRBand;
    qrbBedrijfftr: TQRBand;
    QRDBText4: TQRDBText;
    QRDetailLink1: TQRDetailLink;
    QRDBCalc3: TQRDBCalc;
    QRLabel3: TQRLabel;
    QRLabel6: TQRLabel;
    QRDBText5: TQRDBText;
    QRDBText7: TQRDBText;
    QRLabel5: TQRLabel;
    QRLabel7: TQRLabel;
    QRDBCalc4: TQRDBCalc;
    QRDBCalc5: TQRDBCalc;
    QRDBCalc6: TQRDBCalc;
    QRShape2: TQRShape;
    QRShape4: TQRShape;
    QRDBText8: TQRDBText;
    QRLabel11: TQRLabel;
    QRLabel12: TQRLabel;
    QRLabel13: TQRLabel;
    qryVerkoperVK_NUMMER: TStringField;
    qryVerkoperTotin: TFloatField;
    qryVerkoperTotuit: TFloatField;
    qryVerkoperNumIn: TIntegerField;
    qryVerkoperNumUit: TIntegerField;
    qrcIn2: TQRDBCalc;
    QrcUit3: TQRDBCalc;
    QrcIn4: TQRDBCalc;
    QrcUit4: TQRDBCalc;
    QrcIn3: TQRDBCalc;
    qrcUit2: TQRDBCalc;
    QRLabel9: TQRLabel;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    procedure StartUp;
    procedure qrbGroepftrBeforePrint(var PrintBand: Boolean);
    procedure qrbBedrijfftrBeforePrint(var PrintBand: Boolean);
    procedure qrbSummaryBeforePrint(var PrintBand: Boolean);
    procedure qrbVerkoopInfoBeforePrint(var PrintBand: Boolean);
  private
    fFromDate,fToDate:TDateTime;
    fFromWeek,fToWeek:Integer;
    fDoDate:Boolean;
    { Private declarations }
  public
    property FromDate:TDateTime read fFromDate write fFromDate ;
    property ToDate:TDateTime read fToDate write fToDate ;
    property FromWeek:Integer read fFromWeek write fFromWeek;
    property ToWeek:Integer read fToWeek write fToWeek;
    Property DoDate:Boolean read fDoDate write fDoDate default False;
    { Public declarations }
  end;
Function SafeDiv(teller,noemer:Integer): Single;

var
  fPercentR2: TfPercentR2;

implementation
Uses InitDb;

{$R *.DFM}

procedure TfPercentR2.StartUp;
begin
  With EnhQuery1 do
  Begin
       Active := False;
       DeleteFile(Initdb.RootDir+'temp\temp.db');
       DatabaseName := initDb.Rootdir+'contract';
       DestDatabaseName := initdb.RootDir+'temp';

       Sql.Clear;
       Sql.Add('SELECT * from "'+initdb.contractdb+'"');
       if DoDate = True then
       Begin
            Sql.Add('where (DTM_VERZND >= :FromDate) AND (DTM_VERZND <= :ToDate)');
            ParamByName('FromDate').AsDate := FromDate;
            ParamByName('ToDate').AsDate := ToDate;
            SelectieText.Caption := 'Verzonden-Retour vanaf '+DateToStr(FromDate)+
                                    ' tot en met '+DateToStr(ToDate);

       End
       Else
       begin
            Sql.Add('where (WKN_VERZND >= :FromWeek) AND (WKN_VERZND <= :ToWeek)');
            ParamByName('FromWeek').AsString := IntToStr(FromWeek);
            ParamByName('ToWeek').AsString := IntToStr(ToWeek);
            SelectieText.Caption := 'Verzonden-Retour vanaf week '+IntToStr(FromWeek)+
                                    ' tot en met week '+IntToStr(ToWeek);
       End;
       Execute;
  End;
  With qryBedrijf do
  Begin
       Active := False;
       DatabaseName := initDb.Rootdir+'temp';
       Open;
  End;
  With qryGroep do
  Begin
       Active := False;
       DatabaseName := initDb.Rootdir+'temp';
       Open;
  End;
  With qryVerkoper do
  Begin
       Active := False;
       DatabaseName := initDb.Rootdir+'temp';
       Open;
  End;
  With qryNaam do
  Begin
       Active := False;
       DatabaseName := initDb.Rootdir+'verkoper';
       Open;
  End;
end;

procedure TfPercentR2.qrbGroepftrBeforePrint(var PrintBand: Boolean);
begin
     QRLabel13.Caption :=
       FloatToStrF(SafeDiv(QRCIn2.AsInteger,QRCUit2.AsInteger)*100,ffFixed,7,2)+' %'
end;

procedure TfPercentR2.qrbBedrijfftrBeforePrint(var PrintBand: Boolean);
begin
     QRLabel11.Caption :=
       FloatToStrF(SafeDiv(QRCIn3.AsInteger,QRCUit3.AsInteger)*100,ffFixed,7,2)+' %'
end;

procedure TfPercentR2.qrbSummaryBeforePrint(var PrintBand: Boolean);
begin
     QRLabel12.Caption :=
       FloatToStrF(SafeDiv(QRCIn4.AsInteger,QRCUit4.AsInteger)*100,ffFixed,7,2)+' %'
end;

procedure TfPercentR2.qrbVerkoopInfoBeforePrint(var PrintBand: Boolean);
begin
     QRLabel9.Caption :=
       FloatToStrF(SafeDiv(QryVerkoper.FieldByName('NumIn').Value,
       QryVerkoper.FieldByName('NumUit').Value)*100,ffFixed,7,2)+' %'
end;

Function SafeDiv(teller,noemer:Integer): Single;
Begin
     if Noemer = 0 then Result := 0.0
     Else Result := Teller/Noemer;
End;

end.
