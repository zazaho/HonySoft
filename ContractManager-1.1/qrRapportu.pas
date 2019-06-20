unit qrRapportu;

interface

uses
  Forms, StdCtrls, Buttons, Classes, Controls, ExtCtrls,SysUtils;

type
  TqrRapportf = class(TForm)
    RadioGroup1: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
Function SmartWeek(EersteDatum:Boolean):TDateTime;

var
  qrRapportf: TqrRapportf;
  FromDate,ToDate:TDateTime;
  FromWeek,ToWeek:Integer;

implementation

uses QryCust, {PercentRu}ComzetRu, OmzetRu;

{$R *.DFM}
Function SmartWeek(EersteDatum:Boolean):TDateTime;
Const
     ExtraDays  :Array[1..7] of Word = (1,0,6,5,4,3,2);
     FewerDays  :Array[1..7] of Word = (6,0,1,2,3,4,5);
Var
   Year,Month,Day:Word;
   Dummy:TDateTime;

begin
     Try
         DecodeDate(Now,year,month,day);
         If Day < 14 then DecodeDate(Now-day,year,month,day);
         If EersteDatum then
         Begin
              If Month = 1 then
              Begin
                   Dummy := EncodeDate(year - 1,12,15);
                   Result := EncodeDate(year-1,12,15+ExtraDays[DayOfWeek(Dummy)]);
              End
              Else
              Begin
                   Dummy := Encodedate(year,Month-1,15);
                   Result := EncodeDate(year,month-1,15+ExtraDays[DayOfWeek(Dummy)]);
              End;
         End
         Else
         Begin
              Dummy := EncodeDate(year,month,14);
              Result := EncodeDate(year,month,14-FewerDays[DayOfWeek(Dummy)]);
         End;
     Except
           if EersteDatum then Result := now - 30
           else Result := now
     End;
end;

procedure TqrRapportf.BitBtn1Click(Sender: TObject);
begin
     Case RadioGroup1.ItemIndex of
     0:
     Begin
          Application.CreateForm(TqueryCustDlg,QueryCustDlg);
          with QueryCustDlg do
          Begin
               FromDate := SmartWeek(True);
               ToDate := SmartWeek(False);
               ShowModal;
          End;
          If QueryCustDlg.ModalResult = mrOk then
          Begin
               Application.CreateForm(TfOmzetR,fOmzetR);
               with fOmzetR do
               Begin
                    FromDate := QueryCustDlg.FromDate;
                    ToDate := QueryCustDlg.ToDate;
                    FromWeek := QueryCustDlg.FromWeek;
                    ToWeek := QueryCustDlg.ToWeek;
                    DoDate := (QueryCustDlg.RadioGroup1.ItemIndex = 0);
                    StartUp;
                    QuickReport.Preview;
               End;
          End
     end;
     1:
     Begin
          Application.CreateForm(TqueryCustDlg,QueryCustDlg);
          with QueryCustDlg do
          Begin
               FromDate := Now - 60;
               ToDate := Now -30;
               ShowModal;
          End;
          If QueryCustDlg.ModalResult = mrOk then
          Begin
               Application.CreateForm(TfPercentR2,fPercentR2);
               with fPercentR2 do
               Begin
                    FromDate := QueryCustDlg.FromDate;
                    ToDate := QueryCustDlg.ToDate;
                    FromWeek := QueryCustDlg.FromWeek;
                    ToWeek := QueryCustDlg.ToWeek;
                    DoDate := (QueryCustDlg.RadioGroup1.ItemIndex = 0);
                    StartUp;
                    QuickReport.Preview;
               End;
          End
     end;
     End; // case
end;

end.
