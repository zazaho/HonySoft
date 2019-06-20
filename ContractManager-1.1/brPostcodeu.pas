unit brPostcodeu;

interface

uses
  Forms, DB, DBTables, Buttons, StdCtrls, Grids, DBGrids, Controls,
  ExtCtrls, Classes,Messages,SysUtils,Windows,Dialogs;

type
  TbrPostcodef = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    Table1: TTable;
    ListBox1: TListBox;
    ListBox2: TListBox;
    btClose: TBitBtn;
    btOk: TBitBtn;
    btAlles: TBitBtn;
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Panel2: TPanel;
    Edit2: TEdit;
    Button2: TButton;
    Label1: TLabel;
    btInvoegen: TBitBtn;
    btPrint: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btAllesClick(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ListBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure btZoekenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Panel1Enter(Sender: TObject);
    procedure Panel1Exit(Sender: TObject);
    procedure Panel2Enter(Sender: TObject);
    procedure Panel2Exit(Sender: TObject);
    procedure btInvoegenClick(Sender: TObject);
    procedure DBGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btPrintClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Table1BeforePost(DataSet: TDataSet);
  private
    FAllowEdit:Boolean;
    FShowInsert:Boolean;
    FVK_NUMMER,FVK_GROEP,FVK_BEDRIJF:String;
    Procedure SetAllowEdit(Value: Boolean);
    Procedure SetShowInsert(Value: Boolean);
    { Private declarations }
  published
    Property AllowEdit:Boolean read FAllowEdit write SetAllowEdit Default True;
    Property ShowInsert:Boolean read FShowInsert write SetShowInsert Default False;
    Property VK_NUMMER:String read FVK_NUMMER write FVK_NUMMER;
    Property VK_GROEP:String read FVK_GROEP write FVK_GROEP;
    Property VK_BEDRIJF:String read FVK_BEDRIJF write FVK_BEDRIJF;
    { Public declarations }
  end;

var
  brPostcodef: TbrPostcodef;
  operator: Array[0..5] of TStringList;

implementation

{$R *.DFM}

Uses DataMod,initdb,WeekCalu,qrPostcodeu;

Procedure TbrPostcodef.SetAllowEdit(Value: Boolean);
begin
     FAllowEdit := Value;
     If not Value then
     Begin
          DbGrid1.ReadOnly := True;
          DBGrid1.Options := DBGrid1.Options - [dgEditing]
     End
     Else
     Begin
          DbGrid1.ReadOnly := False;
          DBGrid1.Options := DBGrid1.Options + [dgEditing];
     End;
end;

Procedure TbrPostcodef.SetShowInsert(Value: Boolean);
begin
     FShowInsert := Value;
     btInvoegen.Visible := Value;
end;

procedure TbrPostcodef.ListBox1Click(Sender: TObject);
begin
     Listbox2.Items :=  operator[LIstBox1.ItemIndex];
     ListBox2.ItemIndex := 0;
     Edit2.Visible := False;
     Label1.Visible := False;
end;

procedure TbrPostcodef.ListBox2Click(Sender: TObject);
begin
     if ListBox2.Items[ListBox2.ItemIndex] = 'tussen' then
     Begin
          Edit2.Visible := True;
          label1.Visible := True;
     End
     Else
     Begin
          Label1.Visible := False;
          Edit2.Visible := False;
     End;
end;

procedure TbrPostcodef.FormCreate(Sender: TObject);
begin
//     initdb.ConnectDatabases;
     with table1 do
     Begin
          Active := False;
          DataBaseName := initdb.RootDir+'postcode';
          TableName := initdb.postcodedb;
          Active := True;
          FieldByName('Autoinc').Visible := False;
     End;
end;

procedure TbrPostcodef.BtZoekenClick(Sender: TObject);
begin
     if (edit1.text <> '') And ((edit2.text <> '') OR (edit2.visible = false)) then
     Begin
           With Table1 do
           Begin
                Active := False;
                Case listbox1.ItemIndex of
                0:
                Begin
                     case ListBox2.ItemIndex of
                     0:
                     begin
                          filterOptions := [foCaseInsensitive,foNoPartialCompare];
                          filter := 'NAAM = '+''''+edit1.text+'''';
                          filtered := true;
                          Active := true;
                     end;
                     1:
                     Begin
                          filterOptions := [foCaseInsensitive];
                          filter := 'Naam = '+''''+edit1.text+'*'+'''';
                          filtered := true;
                          Active := true;
                     end;
                     end; {Case}
                End;
                1:
                Begin
                     case ListBox2.ItemIndex of
                     0:
                     begin
                          filterOptions := [foCaseInsensitive,foNoPartialCompare];
                          filter := 'Postcode = '+''''+edit1.text+'''';
                          filtered := true;
                          Active := true;
                     end;
                     1:
                     Begin
                          filterOptions := [foCaseInsensitive];
                          filter := 'Postcode = '+''''+edit1.text+'*'+'''';
                          filtered := true;
                          Active := true;
                     end;
                     end; {Case}
                End;
                2:
                Begin
                     filterOptions := [foCaseInsensitive];
                     filter := 'VK_Nummer = '+''''+edit1.text+'''';
                     filtered := true;
                     Active := true;
                End;
                3:
                Begin
                     filterOptions := [foCaseInsensitive];
                     filter := 'VK_Groep = '+''''+edit1.text+'''';
                     filtered := true;
                     Active := true;
                End;
                4:
                Begin
                     filterOptions := [foCaseInsensitive];
                     filter := 'VK_BEDRIJF = '+''''+edit1.text+'''';
                     filtered := true;
                     Active := true;
                End;
                5:
                Begin
                     case ListBox2.ItemIndex of
                     0:
                     begin
                          filterOptions := [foCaseInsensitive,foNoPartialCompare];
                          filter := 'DTM_Mutatie = '+edit1.text;
                          filtered := true;
                          Active := true;
                     end;
                     1:
                     Begin
                          filterOptions := [foCaseInsensitive];
                          filter := 'DTM_Mutatie < '+edit1.text;
                          filtered := true;
                          Active := true;
                     end;
                     2:
                     Begin
                          filterOptions := [foCaseInsensitive];
                          filter := 'DTM_Mutatie > '+edit1.text;
                          filtered := true;
                          Active := true;
                     end;
                     3:
                     Begin
                          filterOptions := [foCaseInsensitive];
                          filter := '((DTM_Mutatie >= '+edit1.text+
                              ') AND (DTM_Mutatie <= '+edit2.text+'))';
                          filtered := true;
                          Active := true;
                     end;


                     end; {Case}

                End;
                end; {Case}
           end;
     End;
End;

procedure TbrPostcodef.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
     If key = #13 then
        Begin
             If Edit2.Visible then
                 perform(WM_NextDlgCtl,0,0)
             Else
                  if edit1.text <> '' then
                  btOk.Click;
             Key := #0;
        End

end;

procedure TbrPostcodef.ListBox1KeyPress(Sender: TObject; var Key: Char);
begin
     If key = #13 then
        Begin
             perform(WM_NextDlgCtl,0,0);
             Key := #0;
        End;
end;

procedure TbrPostcodef.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
     If key = #13 then
     Begin
          If edit2.text <> '' then
             btOk.Click;
          Key := #0;
     End;
end;

procedure TbrPostcodef.btAllesClick(Sender: TObject);
begin
     Table1.Filtered := False;
end;

procedure TbrPostcodef.Button1Click(Sender: TObject);
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


procedure TbrPostcodef.Button2Click(Sender: TObject);
begin
     Application.CreateForm(tWeekCal,WeekCal);
     try
         WeekCal.Date := StrToDate(edit2.text);
     except
           WeekCal.Date := Now;
     end;
         WeekCal.Showmodal;
     If WeekCal.ModalResult = mrOk then
     Edit2.Text := DateToStr(WeekCal.Date);
end;

procedure TbrPostcodef.Panel1Enter(Sender: TObject);
begin
     If ListBox1.ItemIndex = 5 then
     Button1.visible := true;
end;

procedure TbrPostcodef.Panel1Exit(Sender: TObject);
begin
     Button1.Visible := False;
end;

procedure TbrPostcodef.Panel2Enter(Sender: TObject);
begin
     If ListBox1.ItemIndex = 5 then
     Button2.visible := true;
end;

procedure TbrPostcodef.Panel2Exit(Sender: TObject);
begin
     Button2.Visible := False;
end;

procedure TbrPostcodef.btInvoegenClick(Sender: TObject);
begin
     if DbGrid1.SelectedRows.Count > 0 then
     Begin
          VK_NUMMER := Table1.FieldByName('VK_NUMMER').Value;
          VK_GROEP  := Table1.FieldByName('VK_GROEP').Value;
          VK_BEDRIJF := Table1.FieldByName('VK_BEDRIJF').Value;
     End
     Else
     ModalResult := mrNone;
end;

procedure TbrPostcodef.DBGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
   i:Integer;
   MyBookmark: TBookmark;

begin
     if (key = VK_DELETE) AND (ssShift in Shift) then
     Begin
          if AllowEdit And (DbGrid1.SelectedRows.Count > 0) And
          (MessageDlg('Weet u zeker dat u alle geselecteerde gegevens wilt verwijderen?',
          mtWarning, [mbYes, mbNo], 0) = mrYes) then Dbgrid1.SelectedRows.Delete;
     End
     Else if key = VK_RETURN then
     Begin
          if ShowInsert then btInvoegen.Click;
     end
     Else if (Key = 65) And (ssCtrl in Shift) then
     With Table1 do
     Begin
          If RecordCount > 0 then
          Begin
               MyBookmark := GetBookmark;
               DisableControls;
               First;
               For i := 1 to RecordCount do
               Begin
                    DBGrid1.SelectedRows.CurrentRowSelected := True;
                    Next
               End;
               GotoBookmark(MyBookmark);
               FreeBookmark(MyBookmark);
               EnableControls;
          End;
     End;
end;

procedure TbrPostcodef.btPrintClick(Sender: TObject);
begin
     Application.CreateForm(TqrPostcode,qrPostcode);
     qrPostcode.QuickReport.Preview;
//     qrPostcode.Free;
end;

procedure TbrPostcodef.SpeedButton1Click(Sender: TObject);
begin
     Lock;
end;

procedure TbrPostcodef.SpeedButton2Click(Sender: TObject);
begin
     ToonVerkoperOverzicht;
end;

procedure TbrPostcodef.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     HideVerkoperOverzicht;
end;

procedure TbrPostcodef.Table1BeforePost(DataSet: TDataSet);
begin
     Table1.FieldByName('DTM_Mutatie').Value := Date;
end;

initialization
     operator[0] := TStringlist.Create;
     operator[1] := TStringlist.Create;
     operator[2] := TStringlist.Create;
     operator[3] := TStringlist.Create;
     operator[4] := TStringlist.Create;
     operator[5] := TStringlist.Create;
     operator[0].add('is gelijk aan');
     operator[0].add('begint met');
     operator[1].add('is gelijk aan');
     operator[1].add('begint met');
     operator[2].add('is gelijk aan');
     operator[3].add('is gelijk aan');
     operator[4].add('is gelijk aan');
     operator[5].add('is gelijk aan');
     operator[5].add('vóór');
     operator[5].add('na');
     operator[5].add('tussen');
end.
