program CManager;

uses
  Forms,
  CManageru in 'CManageru.pas' {MainForm},
  Splash in 'SPLASH.PAS' {SplashForm},
  DataMod in 'DataMod.pas' {MastData: TDataModule};

{$R *.RES}

begin
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Update;
  Application.Title := 'Contracten Manager';
  Application.HelpFile := '';
  Application.CreateForm(TMastData, MastData);
  Application.CreateForm(TMainForm, MainForm);
  SplashForm.Hide;
  SplashForm.Free;
  Application.Run;
end.
