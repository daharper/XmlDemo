unit Forms.About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Buttons;

type
  TAboutForm = class(TForm)
    Panel1: TPanel;
    mmoAbout: TMemo;
    OkButton: TButton;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
  private
    { Private declarations }
  public
    class procedure Execute;
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

uses
  Base.Integrity;

{ TAboutForm }

{----------------------------------------------------------------------------------------------------------------------}
class procedure TAboutForm.Execute;
var
  scope: TScope;
begin
  var dlg := scope.Owns(TAboutForm.Create(nil));

  dlg.ShowModal;
end;

end.
