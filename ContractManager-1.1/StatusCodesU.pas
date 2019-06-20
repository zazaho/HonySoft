unit StatusCodesU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfStatusCodes = class(TForm)
    Label1: TLabel;
    eBkr: TEdit;
    eAnn: TEdit;
    Label2: TLabel;
    eVrz: TEdit;
    Label3: TLabel;
    eRtr: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    eWarm: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fStatusCodes: TfStatusCodes;

implementation

uses utils;

{$R *.DFM}
procedure TfStatusCodes.FormShow(Sender: TObject);
begin
     eBkr.text := bkrString;
     eAnn.text := annString;
     eVrz.text := vrzString;
     eRtr.text := rtrString;
     eWarm.text := warmString;
end;

procedure TfStatusCodes.Button1Click(Sender: TObject);
begin
     bkrString := eBkr.text;
     annString := eAnn.text;
     vrzString := eVrz.text;
     rtrString := eRtr.text;
     warmString := eWarm.text;
     WriteStatusStrings;
     close;
end;

end.
