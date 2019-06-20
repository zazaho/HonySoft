unit ContractPrintu;

interface

uses
  Forms, DB, DBTables, Quickrep,
  Controls, StdCtrls, Classes, ExtCtrls;

type
  TfContractPrint = class(TForm)
    Title: TQRBand;
    QRSysData1: TQRSysData;
    QRSysData2: TQRSysData;
    QRBand2: TQRBand;
    QRDBText6: TQRDBText;
    QRDBText2: TQRDBText;
    QRDBText3: TQRDBText;
    QRDBText4: TQRDBText;
    QRDBText5: TQRDBText;
    QRDBText7: TQRDBText;
    QRDBText8: TQRDBText;
    QRDBText9: TQRDBText;
    QRDBText10: TQRDBText;
    QRDBText11: TQRDBText;
    QRDBText12: TQRDBText;
    QRDBText13: TQRDBText;
    QRDBText14: TQRDBText;
    QRShape1: TQRShape;
    QRLabel2: TQRLabel;
    QRBand5: TQRBand;
    QRSysData3: TQRSysData;
    QuickReport: TQuickReport;
    Query2: TQuery;
    DataSource2: TDataSource;
    QRShape2: TQRShape;
    QRDBText1: TQRDBText;
    QRDBText15: TQRDBText;
    QRLabel1: TQRLabel;
    QRDBText16: TQRDBText;
    QRDBText17: TQRDBText;
    QRDBText18: TQRDBText;
    QRDBText19: TQRDBText;
    QRBand1: TQRBand;
    QRLabel3: TQRLabel;
    QRLabel4: TQRLabel;
    QRDBCalc1: TQRDBCalc;
    QRDBCalc2: TQRDBCalc;
    QRDBText20: TQRDBText;
    procedure FormCreate(Sender: TObject);
  end;

var
  fContractPrint: TfContractPrint;

implementation
Uses initDb,qryContract;

{$R *.DFM}

procedure TfContractPrint.FormCreate(Sender: TObject);
begin
     With Query2 do
     Begin
          Active := False;
          DatabaseName := initdb.RootDir+'contract';
          Sql.Clear;
          Sql.AddStrings(fqryContract.qry.Sql);
          Sql.Add('Order by VK_BEDRIJF,VK_GROEP,VK_NUMMER');
          Open;
     End;
end;

end.
