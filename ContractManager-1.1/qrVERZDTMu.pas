unit qrVERZDTMu;

interface

uses
  Forms, StdCtrls, Buttons, Controls, Classes,SysUtils, Mask;

type
  TqrVERZDTMf = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    BitBtn1: TBitBtn;
    Edit1: TMaskEdit;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  qrVERZDTMf: TqrVERZDTMf;

implementation
Uses WeekCalu;

{$R *.DFM}

procedure TqrVERZDTMf.SpeedButton1Click(Sender: TObject);
begin
     Application.CreateForm(tWeekCal,WeekCal);
     try
         WeekCal.Date := StrToDate(edit1.text);
     except
           WeekCal.Date := Now;
     end;
         WeekCal.Showmodal;
     If WeekCal.ModalResult = mrOk then
     Edit1.Text := DateToStr(WeekCal.Date);

end;

end.
