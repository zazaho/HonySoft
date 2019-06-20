unit Splash;

interface

uses
    Forms, ExtCtrls, Controls, StdCtrls,Classes;

type
  TSplashForm = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Bevel1: TBevel;
    Label1: TLabel;
    Image1: TImage;
  end;

var
  SplashForm: TSplashForm;

implementation

{$R *.DFM}

end.
