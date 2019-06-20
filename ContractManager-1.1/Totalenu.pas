unit Totalenu;

interface

uses
  {Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, Grids, StdCtrls, Buttons, ExtCtrls}
  Forms, DB, DBTables, StdCtrls, ExtCtrls, Buttons, Controls, Grids,
  Classes,SysUtils,Dialogs;

type
  TTotalen = class(TForm)
    StringGrid1: TStringGrid;
    BitBtn1: TBitBtn;
    Table1: TTable;
    SpeedButton1: TSpeedButton;
    Panel1: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Totalen: TTotalen;

implementation
Uses Contractu3,initdb,utils;
{$R *.DFM}

procedure TTotalen.FormCreate(Sender: TObject);
Var
   dummy,i,Rtal,TotRtal,Vtal,TotVtal,Atal,TotAtal:Integer;
   Rdrag,TotRdrag,Vdrag,TotVdrag,Adrag,TotAdrag:Real;
begin
     TotRtal :=0;TotVtal :=0;TotATal :=0;
     TotRdrag:= 0;TotVdrag:= 0;TotAdrag:= 0;
     Label1.Caption := 'Totalen van lijsten uit week: '+IntToSTr(LijstNummer);
     Table1.Active := False;
     Table1.DataBaseName := initdb.rootdir+'temp';
     With StringGrid1 Do
     Begin
          Cells[1,0] := 'verzonden#';
          Cells[2,0] := 'verzonden';
          Cells[3,0] := 'Retour#';
          Cells[4,0] := 'Retour';
          Cells[5,0] := 'Annulatie#';
          Cells[6,0] := 'Annulatie';
          for i := 1 to contractu3.Filelist.Count do
          Begin
               Cells[0,i] := LowerCase(contractu3.FileList[i-1]);
               With Table1 do
               Begin
                    Rtal := 0; Vtal:=0;Atal :=0;
                    Rdrag:= 0;Vdrag:= 0;Adrag:= 0;
                    TableName := contractu3.FileList[i-1];
                    Open;
                    First;
                    While not EOF do
                    Begin
                       Dummy := FieldByName('CONTRACT').AsInteger;
                       If Length(FieldByName('STATUS').AsString) > 0 then
                       Begin
                          If iIsSub('"'+FieldByName('STATUS').AsString+'"',vrzString) then
                          Begin
                               Vtal := Vtal + 1;
                               Vdrag := VDrag + FieldByName('PROVTMBDG').AsFloat;
                          End
                          Else If iIsSub('"'+FieldByName('STATUS').AsString+'"',rtrString) then
                          Begin
                               Rtal := Rtal + 1;
                               Rdrag := RDrag + FieldByName('PROVTMBDG').AsFloat;
                          End
                          Else If iIsSub('"'+FieldByName('STATUS').AsString+'"',bkrString+','+
                                                                        annString) then
                          Begin
                               Atal := Atal + 1;
                               Adrag := ADrag + FieldByName('PROVTMBDG').AsFloat;
                          End
                       End
                       Else ShowMessage('Ik kan de gegevens van contract nummer: '
                       +IntToStr(FieldByName('Contract').AsInteger)+' niet tonen in het totaal.');
                       Next;
                    End;
               End;
               Cells[1,i] := IntToStr(Vtal);
               Cells[2,i] := FloatToStrF(VDrag,ffCurrency,7,2);
               Cells[3,i] := IntToStr(RTal);
               Cells[4,i] := FloatToStrF(RDrag,ffCurrency,7,2);
               Cells[5,i] := IntToStr(Atal);
               Cells[6,i] := FloatToStrF(Adrag,ffCurrency,7,2);
               TotVtal := TotVtal + VTal;
               TotRtal := TotRtal + RTal;
               TotAtal := TotAtal + ATal;
               TotVdrag := TotVdrag + Vdrag;
               TotRdrag := TotRdrag + Rdrag;
               TotAdrag := TotAdrag + Adrag;
               Table1.Active := False;
          End;
     i := contractu3.Filelist.Count +1;
     Cells[0,i] := 'TOTAAL:';
     Cells[1,i] := IntToStr(TotVtal);
     Cells[2,i] := FloatToStrF(TotVDrag,ffCurrency,7,2);
     Cells[3,i] := IntToStr(TotRTal);
     Cells[4,i] := FloatToStrF(TotRDrag,ffCurrency,7,2);
     Cells[5,i] := IntToStr(TotAtal);
     Cells[6,i] := FloatToStrF(TotAdrag,ffCurrency,7,2);
     End;
End;

procedure TTotalen.SpeedButton1Click(Sender: TObject);
begin
     Print;
end;

end.
