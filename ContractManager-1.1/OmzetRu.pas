unit OmzetRu;

interface

uses
  Forms, Tquerypl, DB, DBTables, Quickrep, Controls, StdCtrls, Classes,
  ExtCtrls,SysUtils;

type
  TfOmzetR = class(TForm)
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
    QRLabel8: TQRLabel;
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
    qryVerkoperTotin: TFloatField;
    qryVerkoperVK_NUMMER: TStringField;
    qryVerkoperQRDBCalc: TQRDBCalc;
    qryVerkoperQRDBCalc2: TQRDBCalc;
    qryVerkoperQRDBCalc3: TQRDBCalc;
    qryVerkoperQRDBCalc4: TQRDBCalc;
    qryVerkoperQRDBCalc5: TQRDBCalc;
    EnhQuery1VK_BEDRIJF: TStringField;
    EnhQuery1VK_GROEP: TStringField;
    EnhQuery1VK_NUMMER: TStringField;
    EnhQuery1bedrag_retour: TFloatField;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRShape2: TQRShape;
    procedure StartUp;
    procedure QRDBText4Print(sender: TObject; var Value: string);
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

var
  fOmzetR: TfOmzetR;

implementation
Uses InitDb,Utils;

{$R *.DFM}

procedure TfOmzetR.StartUp;
begin
  With EnhQuery1 do
  Begin
       Active := False;
       DeleteFile(Initdb.RootDir+'temp\temp.db');
       DatabaseName := initDb.Rootdir+'contract';
       DestDatabaseName := initdb.RootDir+'temp';

       Sql.Clear;
       Sql.Add('SELECT * from "'+initdb.contractdb+'"');
       Sql.Add('WHERE (NOT klant_status IN (:kstatus))');
       ParamByName('kstatus').AsString := warmString;
       if DoDate = True then
       Begin
            Sql.Add('AND (DTM_RETOUR >= :FromDate) AND (DTM_RETOUR <= :ToDate)');
            ParamByName('FromDate').AsDate := FromDate;
            ParamByName('ToDate').AsDate := ToDate;
            SelectieText.Caption := 'Omzet gegevens vanaf '+DateToStr(FromDate)+
                                    ' tot en met '+DateToStr(ToDate);

       End
       Else
       begin
            Sql.Add('AND (WKN_RETOUR >= :FromWeek) AND (WKN_RETOUR <= :ToWeek)');
            ParamByName('FromWeek').AsString := IntToStr(FromWeek);
            ParamByName('ToWeek').AsString := IntToStr(ToWeek);
            SelectieText.Caption := 'Omzet gegevens vanaf week '+IntToStr(FromWeek)+
                                    ' tot week en met '+IntToStr(ToWeek);
       End;
       Sql.Add('Order by VK_GROEP');
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

procedure TfOmzetR.QRDBText4Print(sender: TObject; var Value: string);
begin
     Value := UpperCase(Value);
end;

end.
