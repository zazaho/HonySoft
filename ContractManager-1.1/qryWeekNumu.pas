unit qryWeekNumu;

interface

uses
  {Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask}
  Forms, StdCtrls, Buttons, Controls, Mask, Classes,SysUtils;

type
  TfqryWeekNum = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MaskEdit1: TMaskEdit;
    BitBtn1: TBitBtn;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
         FFileName:String;
         FLijstNum:Integer;
         Procedure SetFileName(Value:String);
         Procedure SetLijstNum(Value:Integer);
         Function  GetFileName:String;
         Function  GetLijstNum:Integer;
    { Private declarations }
  public
        Property FileName:String read GetFileName write SetFileName;
        Property LijstNum:Integer read GetLijstNum write SetLijstNum;
    { Public declarations }
  end;

var
  fqryWeekNum: TfqryWeekNum;

implementation

{$R *.DFM}
Procedure TfqryWeekNum.SetFileName(Value:String);
begin
     FFileName := Value;
     Label2.Caption := ExtractFileName(Value);
end;

Procedure TfqryWeekNum.SetLijstNum(Value:Integer);
begin
     FlijstNum := Value;
end;

Function  TfqryWeekNum.GetFileName:String;
begin
     Result := FFileName;
end;

Function  TfqryWeekNum.GetLijstNum:Integer;
begin
     Result := StrToInt(MaskEdit1.Text);
end;

procedure TfqryWeekNum.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
     Try
        GetLijstNum
     Except
           CanClose := False;
           MaskEdit1.SetFocus
     End;
end;

end.
