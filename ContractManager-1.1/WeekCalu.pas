unit weekcalu;

interface

uses
  SysUtils,Forms,Utils,
  StdCtrls, Buttons, Grids, Calendar, Controls, ExtCtrls, Classes;

type
  TWeekCal = class(TForm)
    Calendar1: TCalendar;
    ThisDay: TLabel;
    Lyear: TBitBtn;
    Nyear: TBitBtn;
    LMonth: TBitBtn;
    NMonth: TBitBtn;
    Today: TBitBtn;
    Ok: TBitBtn;
    P1: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Cancel: TBitBtn;
    procedure Calendar1Change(Sender: TObject);
    procedure NyearClick(Sender: TObject);
    procedure LyearClick(Sender: TObject);
    procedure NMonthClick(Sender: TObject);
    procedure LMonthClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TodayClick(Sender: TObject);
  private
    fWeekNummer :Integer;
//    FDate :TDateTime;
    procedure SetDate(Date: TDateTime);
    function GetDate: TDateTime;
    { Private declarations }
  public
    { Public declarations }
    property Date: TDateTime read GetDate write SetDate;
    property WeekNummer :Integer read fWeekNummer write FWeekNummer;
  end;

var
  WeekCal: TWeekCal;

implementation

{$R *.DFM}

procedure TWeekCal.SetDate(Date: TDateTime);
begin
 Calendar1.CalendarDate := Date;
end;

function TWeekCal.GetDate: TDateTime;
begin
  Result := Calendar1.CalendarDate;
end;

procedure TWeekCal.FormCreate(Sender: TObject);
begin
     ClientHeight:=P1.Height;
     ClientWidth:=P1.Width;
     Calendar1Change(Self);
end;


procedure TWeekCal.Calendar1Change(Sender: TObject);
Var
   Jaar,Maand,Dag:Word;

begin
     DecodeDate(Calendar1.CalendarDate,jaar,maand,dag);
     WeekNummer := Date2Week(Calendar1.CalendarDate);
     Caption := 'Weeknummer: '+IntTostr(weeknummer);
     ThisDay.Caption := FormatDateTime(LongDateFormat, Calendar1.CalendarDate);
//     WeekCal.Date := Calendar1.CalendarDate;
end;

procedure TWeekCal.NyearClick(Sender: TObject);
begin
     Calendar1.NextYear;
end;

procedure TWeekCal.LyearClick(Sender: TObject);
begin
     Calendar1.PrevYear;
end;

procedure TWeekCal.NMonthClick(Sender: TObject);
begin
     Calendar1.NextMonth;
end;

procedure TWeekCal.LMonthClick(Sender: TObject);
begin
     Calendar1.PrevMonth;
end;



procedure TWeekCal.TodayClick(Sender: TObject);
begin
     Calendar1.CalendarDate := Trunc(Now);
end;

end.
