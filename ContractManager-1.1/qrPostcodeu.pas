unit qrPostcodeu;

interface

uses
  Forms, DB, DBTables,
  Quickrep, Controls, StdCtrls, Classes, ExtCtrls;

type
  TqrPostcode = class(TForm)
    QuickReport:TQuickReport;
    PageHeader:TQRBand;
    QRSysData:TQRSysData;
    QRSysData2:TQRSysData;
    QRSysData3:TQRSysData;
    QRBand:TQRBand;
    QRLabelNAAM:TQRLabel;
    QRLabelPOSTCODE:TQRLabel;
    QRLabelHSNR:TQRLabel;
    QRLabelVK_GROEP:TQRLabel;
    QRLabelVK_NUMMER:TQRLabel;
    QRLabelDTM_MUTATIE:TQRLabel;
    QRBand2:TQRBand;
    QRDBTextNAAM:TQRDBText;
    QRDBTextPOSTCODE:TQRDBText;
    QRDBTextHSNR:TQRDBText;
    QRDBTextVK_GROEP:TQRDBText;
    QRDBTextVK_NUMMER:TQRDBText;
    QRDBTextDTM_MUTATIE:TQRDBText;
    DataSource1: TDataSource;
    Table1: TTable;
    procedure FormCreate(Sender: TObject);
  end;

var
  qrPostcode: TqrPostcode;

implementation

Uses brPostCodeu;
{$R *.DFM}

procedure TqrPostcode.FormCreate(Sender: TObject);
begin
     With Table1 do
     Begin
          DatabaseName := brPostcodef.Table1.DatabaseName;
          TableName := brPostcodef.Table1.TableName;
          FilterOptions := brPostcodef.Table1.FilterOptions;
          Filter := brPostcodef.Table1.Filter;
          Filtered := brPostcodef.Table1.Filtered;
          Active := True;
     end;
End;
end.
