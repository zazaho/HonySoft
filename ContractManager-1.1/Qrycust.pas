unit QryCust;

interface

uses
  Forms, Controls, StdCtrls, ExtCtrls, Mask, Buttons, Classes,SysUtils,Dialogs;

type
  TQueryCustDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    FromEdit: TEdit;
    ToEdit: TEdit;
    CancelBtn: TButton;
    OkBtn: TButton;
    Msglab: TLabel;
    PopupCalBtnFrom: TSpeedButton;
    PopupCalToBtn: TSpeedButton;
    Bevel1: TBevel;
    FromWeekEdit: TMaskEdit;
    ToWeekEdit: TMaskEdit;
    RadioGroup1: TRadioGroup;
    procedure OkBtnClick(Sender: TObject);
    procedure PopupCalBtnFromClick(Sender: TObject);
    procedure PopupCalToBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    function GetFromDate: TDateTime;
    function GetToDate: TDateTime;
    Function GetFromWeek : Integer;
    Function GetToWeek : Integer;
    procedure SetFromDate(NewDate: TDateTime);
    procedure SetToDate(NewDate: TDateTime);
    procedure SetFromWeek(NewWeek:Integer);
    procedure SetToWeek(NewWeek:Integer);
  public
    property FromDate: TDateTime read GetFromDate write SetFromDate;
    property ToDate: TDateTime read GetToDate write SetToDate;
    property FromWeek:Integer read GetFromWeek write SetFromWeek;
    property ToWeek:Integer read GetToWeek write SetToWeek;
  end;

var
  QueryCustDlg: TQueryCustDlg;

implementation

{$R *.DFM}

uses WeekCalu,Utils;

Function TQueryCustDlg.GetFromWeek : Integer;
begin
     try Result := StrToInt(FromWeekEdit.Text)
     Except Result := 0
     End;
end;

Function TQueryCustDlg.GetToWeek : Integer;
begin
     try Result := StrToInt(ToWeekEdit.Text)
     Except Result := 0
     End;
end;

procedure TQueryCustDlg.SetFromWeek(NewWeek:Integer);
begin
     FromWeekEdit.Text := IntToStr(NewWeek);
end;

procedure TQueryCustDlg.SetToWeek(NewWeek:Integer);
begin
     ToWeekEdit.Text := IntToStr(NewWeek);
end;

procedure TQueryCustDlg.SetFromDate(NewDate: TDateTime);
begin
  FromEdit.Text := DateToStr(NewDate);
  FromWeek := Date2Week(NewDate);
end;

procedure TQueryCustDlg.SetToDate(NewDate: TDateTime);
begin
  ToEdit.Text := DateToStr(NewDate);
  ToWeek := Date2Week(NewDate);
end;

function TQueryCustDlg.GetFromDate: TDateTime;
begin
  if FromEdit.Text = '' then Result := 0
  else Result := StrToDate(FromEdit.Text);
end;

function TQueryCustDlg.GetToDate: TDateTime;
begin
  if ToEdit.Text = '' then Result := 0
  else Result := StrToDate(ToEdit.Text);
end;

procedure TQueryCustDlg.OkBtnClick(Sender: TObject);
//var Test: TdateTime;
begin
  try
    {Test := }StrToDate(FromEdit.Text); { validate date strings }
    {Test := }StrToDate(ToEdit.Text);
    if (ToDate <> 0) and (ToDate < FromDate) then
    begin
      ShowMessage('De "TOT" datum mag niet kleiner zijn dan de "Van" datum');
      ModalResult := mrNone;
    end
    else ModalResult := mrOk;
  except
    ShowMessage('  Geen geldige datum');
    ModalResult := mrNone;
  end;
end;

procedure TQueryCustDlg.PopupCalBtnFromClick(Sender: TObject);
begin
  Application.CreateForm(TWeekCal,WeekCal);
  try
     WeekCal.Date := StrToDate(FromEdit.Text);
  except
        WeekCal.Date := now-60;
  end;
    { start with current date }
  if WeekCal.ShowModal = mrOk then
    Begin
         FromDate := WeekCal.Date;
    End;
end;

procedure TQueryCustDlg.PopupCalToBtnClick(Sender: TObject);
begin
  Application.CreateForm(TWeekCal,WeekCal);
  try
     WeekCal.Date := StrToDate(ToEdit.Text);
  except
        WeekCal.Date := now -30;
  end;
  if WeekCal.ShowModal = mrOk then
    Begin
    ToDate := WeekCal.Date;
    End;
end;

procedure TQueryCustDlg.CancelBtnClick(Sender: TObject);
begin
  ToEdit.Text := '';
  FromEdit.Text := '';
end;

end.
