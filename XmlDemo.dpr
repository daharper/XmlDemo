program XmlDemo;

uses
  Vcl.Forms,
  Forms.Main in 'Forms\Forms.Main.pas' {MainForm},
  Base.Xml in 'Base\Base.Xml.pas',
  Base.Core in 'Base\Base.Core.pas',
  Base.Dynamic in 'Base\Base.Dynamic.pas',
  Base.Integrity in 'Base\Base.Integrity.pas',
  Base.Conversions in 'Base\Base.Conversions.pas',
  Base.Messaging in 'Base\Base.Messaging.pas',
  Base.Reflection in 'Base\Base.Reflection.pas',
  Vcl.Themes,
  Vcl.Styles,
  Utils.XmlRegistry in 'Utils\Utils.XmlRegistry.pas',
  Forms.About in 'Forms\Forms.About.pas' {AboutForm};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := true;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Xml Demo';
  TStyleManager.TrySetStyle('Windows11 Modern Dark');
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.Run;
end.
