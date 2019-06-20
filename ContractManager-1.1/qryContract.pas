unit qryContract;

interface

uses
  Forms, DB, DBTables, Grids, DBGrids, DBCtrls, StdCtrls, Buttons,
  ExtCtrls, Mask, Controls, ComCtrls, Classes,SysUtils,Messages;

type
  TfqryContract = class(TForm)
    PageControl1: TPageControl;
    TabInvoer: TTabSheet;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    qry: TQuery;
    Panel1: TPanel;
    DBNavigator1: TDBNavigator;
    dsInvoer: TDataSource;
    Panel2: TPanel;
    chbPostcode: TCheckBox;
    mePostcode: TMaskEdit;
    chbContractNum: TCheckBox;
    RGStatus: TRadioGroup;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
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
    DBEdit10: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    meContractNum: TEdit;
    Label8: TLabel;
    DBEdit19: TDBEdit;
    GroupBox1: TGroupBox;
    meDatumVoor: TMaskEdit;
    meDatumNa: TMaskEdit;
    meDatumTussen1: TMaskEdit;
    meDatumTussen2: TMaskEdit;
    cbDatum: TComboBox;
    meWKVoor: TMaskEdit;
    meWKna: TMaskEdit;
    meWKTussen1: TMaskEdit;
    meWKTussen2: TMaskEdit;
    cbWKN: TComboBox;
    chbDatumVoor: TRadioButton;
    chbDatumNa: TRadioButton;
    chbDatumTussen: TRadioButton;
    chbWKVoor: TRadioButton;
    chbWKNa: TRadioButton;
    chbWKTussen: TRadioButton;
    GroupBox2: TGroupBox;
    dblVK_NUMMER: TDBLookupComboBox;
    chbVerkoper: TCheckBox;
    chbGroep: TCheckBox;
    dblGroep: TDBLookupComboBox;
    chbBedrijf: TCheckBox;
    dblBedrijf: TDBLookupComboBox;
    Query1: TQuery;
    Query2: TQuery;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    btPrint: TSpeedButton;
    RadioButton1: TRadioButton;
    chbNaam: TCheckBox;
    eNaam: TEdit;
    SpeedButton1: TSpeedButton;
    DBEdit20: TDBEdit;
    cbProduct: TCheckBox;
    eProduct: TEdit;
    cbKStatus: TCheckBox;
    eKstatus: TEdit;
    TabSql: TTabSheet;
    eSql: TEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btZoekClick(Sender: TObject);
    procedure btAllesClick(Sender: TObject);
    procedure chbRecNumClick(Sender: TObject);
    procedure KeyUpEnter(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControl1Enter(Sender: TObject);
    procedure PageControl1Exit(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure qryBeforePost(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
end;

Const
     Datas  :Array[0..2] of String = ('DTM_MUTATIE','DTM_RETOUR','DTM_VERZND');
     Weeks :Array[0..1] of String = ('WKN_VERZND','WKN_RETOUR');

var
  fqryContract: TfqryContract;
  VerkoperList: TStringList;

implementation
Uses DataMod,initDb,ContractPrintu,utils;

{$R *.DFM}

procedure TfqryContract.FormCreate(Sender: TObject);
begin
  with qry do
  Begin
       Active := False;
       DatabaseName := initDb.RootDir+'contract';
       Sql.Clear;
       Sql.Add('Select * from "'+initDb.Contractdb+'"');
       Open;
  End;
  with query1 do
  Begin
       Active := False;
       DatabaseName := InitDb.RootDir+'Verkoper';
       Sql.Add('SELECT DISTINCT VK_GROEP FROM "'+initdb.Verkoperdb+'"');
       Open;
  End;
  with query2 do
  Begin
       Active := False;
       DatabaseName := InitDb.RootDir+'Verkoper';
       Sql.Add('SELECT DISTINCT VK_BEDRIJF FROM "'+initdb.Verkoperdb+'"');
       Open;
  End;

  cbDatum.ItemIndex := 1;
  cbWKN.ItemIndex := 1;
End;


procedure TfqryContract.btZoekClick(Sender: TObject);
Var
   i: Integer;
begin
     i := 0;
     qry.DisableControls;
     qry.Active := False;
     With Qry.Sql do
     Begin
          clear;
          Add('Select * from "'+initdb.contractdb+'"');
          if chbVerkoper.Checked then
          Begin
               Add('where (VK_NUMMER = "'+dblVK_NUMMER.Text+'")');
               i := i + 1;
          End;
          if chbGroep.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('(VK_GROEP = "'+dblGROEP.Text+'")');
               i := i + 1;
          End;
          if cbProduct.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('(product like "'+eProduct.Text+'%")');
               i := i + 1;
          End;
          if cbKStatus.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('(Klant_status = "'+eKStatus.Text+'")');
               i := i + 1;
          End;
          if chbBedrijf.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('(VK_BEDRIJF = "'+dblBEDRIJF.Text+'")');
               i := i + 1;
          End;
          if chbDatumVoor.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('('+Datas[cbDatum.ItemIndex]+' < :ToDate)');
               Qry.ParamByName('ToDate').AsDate :=StrToDate(meDatumVoor.Text);
               i := i + 1;
          End;
          if chbDatumNa.Checked then
          Begin
               If i > 0 then qry.Sql.Add(' and ')
               Else qry.Sql.Add('where ');
               Add('('+Datas[cbDatum.ItemIndex]+' > :FromDate)');
               Qry.ParamByName('FromDate').AsDate :=StrToDate(meDatumNa.Text);
               i := i + 1;
          End;
          if chbDatumTussen.Checked then
          Begin
               If i > 0 then qry.Sql.Add(' and ')
               Else qry.Sql.Add('where ');
               Add('('+Datas[cbDatum.ItemIndex]+' >= :FromDate)');
               Add(' AND ('+Datas[cbDatum.ItemIndex]+' <= :ToDate)');
               Qry.ParamByName('FromDate').AsDate :=StrToDate(meDatumTussen1.Text);
               Qry.ParamByName('ToDate').AsDate :=StrToDate(meDatumTussen2.Text);
               i := i + 1;
          End;

          if chbWKVoor.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('('+Weeks[cbWKN.ItemIndex]+' < "'+meWKVoor.Text+'")');
               i := i + 1;
          End;
          if chbWKNa.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('('+Weeks[cbWKN.ItemIndex]+' > "'+meWKNa.Text+'")');
               i := i + 1;
          End;
          if chbWKTussen.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('('+Weeks[cbWKN.ItemIndex]+' >= "'+meWKTussen1.Text+'")');
               Add(' AND ('+Weeks[cbWKN.ItemIndex]+' <= "'+meWKTussen2.Text+'")');
               i := i + 1;
          End;

          if RGStatus.ItemIndex in [0,1,2,3,4] then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Case RGStatus.ItemIndex of
               0: Add('(Status in ('+bkrString+'))');
               1: Add('(Status in ('+annString+'))');
               2: Add('(Status in ('+vrzString+'))');
               3: Add('(Status in ('+rtrString+'))');
               4: Add('(Status like "'+Edit1.Text+'%")');
               end; //case
               i := i + 1;
          End;
          if chbContractNum.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('(Contract like '+'"'+meContractNum.Text+'%")');
               i := i + 1
          End;
          if chbNaam.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else Add('where ');
               Add('(Naam like '+'"'+eNaam.Text+'%")');
               i := i + 1
          End;
          if chbPostcode.Checked then
          Begin
               If i > 0 then Add(' and ')
               Else
               Add('where ');
               Add('(Postcode = "' + mePostCode.Text + '")');
          End;
     End;
     qry.Open;
     qry.EnableControls;
end;

procedure TfqryContract.btAllesClick(Sender: TObject);
begin
     qry.Active := False;
     qry.Sql.Clear;
     qry.Sql.Add('select * from "'+initDb.ContractDb+'"');
     qry.Open;
end;

procedure TfqryContract.chbRecNumClick(Sender: TObject);
begin
     If Sender is TCheckBox then
     Begin
          if TCheckBox(Sender).Checked then
          perform(WM_NextDlgCtl,0,0);
     End
     Else perform(WM_NextDlgCtl,0,0);
end;

procedure TfqryContract.KeyUpEnter(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if key = 13 then
     if ssCtrl in Shift then bitBtn2.Click
     Else perform(wm_nextdlgctl,0,0);
end;

procedure TfqryContract.PageControl1Enter(Sender: TObject);
begin
     DBGrid1.DataSource := dsInvoer;
     DBGRid1.Enabled := True;
end;

procedure TfqryContract.PageControl1Exit(Sender: TObject);
begin
     DBGrid1.DataSource := nil;
     DBGRID1.Enabled := False;
end;

procedure TfqryContract.btPrintClick(Sender: TObject);
begin
     Application.CreateForm(TfContractPrint,fContractPrint);
     fContractPrint.quickreport.preview;
end;

procedure TfqryContract.SpeedButton1Click(Sender: TObject);
begin
     Lock;
end;

procedure TfqryContract.qryBeforePost(DataSet: TDataSet);
begin
     qry.FieldByName('DTM_Mutatie').Value := Date;
end;

procedure TfqryContract.Button1Click(Sender: TObject);
begin
     With Qry do
     Begin
          active := false;
          sql.Clear;
          sql.Add(eSql.Text);
          ExecSql;
          Active := True;
     End;
end;

end.
