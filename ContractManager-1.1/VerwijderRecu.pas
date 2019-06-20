unit VerwijderRecu;

interface

uses
  Forms, Mask, StdCtrls, Controls, Buttons, Classes,SysUtils,Dialogs;

type
  TfqrVerwijderRec = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    MaskEdit1: TMaskEdit;
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    fDatum:TDateTime;
    fDoContract:Boolean;
    Procedure SetDatum(Value:TDateTime);
    Function GetDatum:TDateTime;
    { Private declarations }
  public
    Property datum:TDateTime read GetDatum write setdatum;
    Property DoContract:Boolean read fDoContract Write fDoContract;
    { Public declarations }
  end;

var
  fqrVerwijderRec: TfqrVerwijderRec;

implementation
Uses initDb;
Const
     Dirs:Array[False..True] of String = ('postcode','contract');

{$R *.DFM}
Procedure TfqrVerwijderRec.SetDatum(Value:TDateTime);
begin
     maskedit1.text := DateToStr(Value);
     fDatum := Value;
end;
Function TfqrVerwijderRec.GetDatum:TDateTime;
begin
     Result := StrToDate(maskedit1.text);
end;
procedure TfqrVerwijderRec.SpeedButton1Click(Sender: TObject);
Var
   OpenDialog: TopenDialog;
begin
     OpenDialog := TOpenDialog.Create(Self);
     With OpenDialog Do
     Begin
          DefaultExt := 'db';
          InitialDir := initdb.RootDir+dirs[DoContract];
          Title := 'Kies de lijst om de oude gegevens in te bewaren';
          Options := [ofPathMustExist,ofOverwritePrompt,ofNoReadOnlyReturn,
          ofHideReadOnly,ofNoChangeDir];
          Filter := 'Paradox Files|*.DB';
          Execute;
          Edit1.Text := ExtractFileName(OpenDialog.FileName);
          Free;
     End;

end;

procedure TfqrVerwijderRec.BitBtn1Click(Sender: TObject);
begin
     If edit1.Text <> '' then modalResult := mrOk;
end;

end.
