program Overzetten;

uses
  Forms,
  ZetOverU in 'ZetOverU.pas' {fZetOver};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfZetOver, fZetOver);
  Application.Run;
end.
