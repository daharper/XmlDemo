unit Forms.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, System.ImageList, Vcl.ImgList, Vcl.ToolWin,
  Vcl.ExtCtrls, Vcl.StdCtrls, Winapi.WebView2, Winapi.ActiveX, Vcl.Edge, Base.Dynamic;

type
  TMainForm = class(TForm)
    ilMain: TImageList;
    tbrMain: TToolBar;
    tbtDemo0: TToolButton;
    btbSeperator0: TToolButton;
    tbtDemo1: TToolButton;
    btbSeperator1: TToolButton;
    tbtDemo2: TToolButton;
    btbSeperator2: TToolButton;
    tbtDemo3: TToolButton;
    btbSeperator3: TToolButton;
    tbtDemo4: TToolButton;
    btbSeperator4: TToolButton;
    Browser: TEdgeBrowser;
    CodeBrowser: TEdgeBrowser;
    BottomSplitter: TSplitter;
    tbtDemo5: TToolButton;
    btbSeperator5: TToolButton;
    tbtDemo6: TToolButton;
    btbSeperator6: TToolButton;
    tbtDemo7: TToolButton;
    btbSeperator7: TToolButton;
    tbtDemo8: TToolButton;
    btbSeperator8: TToolButton;
    tbtDemo9: TToolButton;
    btbSeperator9: TToolButton;
    tbtDemo10: TToolButton;
    tbtDemo11: TToolButton;
    btbSeperator11: TToolButton;
    tbtDemo12: TToolButton;
    btbSeperator10: TToolButton;
    tbtDemo13: TToolButton;
    btbSeperator12: TToolButton;
    btbSeperator13: TToolButton;
    ToolButton6: TToolButton;
    procedure DemoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
  private
    function GetUrlPath(const aFilename: string): string;
    function GetContent(const aBrowser: TEdgeBrowser): string;

    procedure SetContent(const aBrowser: TEdgeBrowser; const aValue: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  idURI,
  System.Generics.Collections,
  System.Generics.Defaults,
  System.StrUtils,
  System.IOUtils,
  System.NetEncoding,
  System.Threading,
  Base.Integrity,
  Base.Xml,
  Utils.XmlRegistry,
  Forms.About;

{----------------------------------------------------------------------------------------------------------------------}
procedure TMainForm.DemoClick(Sender: TObject);
begin
  var button := Sender as TToolButton;
  var id     := button.Tag;
  var demo   := TXmlDemo(id);
  var xml    := XmlRegistry.Xml[demo];
  var code   := XmlRegistry.Code[demo];

  SetContent(Browser, xml);
  SetContent(CodeBrowser, code);
end;

{----------------------------------------------------------------------------------------------------------------------}
function TMainForm.GetUrlPath(const aFilename: string): string;
begin
  Result := 'file://' + TIdURI.PathEncode(aFilename).Replace('%5C', '/');
end;

{----------------------------------------------------------------------------------------------------------------------}
function TMainForm.GetContent(const aBrowser: TEdgeBrowser): string;
begin
  Result := aBrowser.ExecuteScript('editor.getModel().getValue();', '');
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TMainForm.SetContent(const aBrowser: TEdgeBrowser; const aValue: string);
var
  scope: TScope;
begin
  var base64 := scope.Owns(TBase64Encoding.Create(0));
  var text   := base64.Encode(aValue);

  aBrowser.ExecuteScript('editor.getModel().setValue(atob("' + text + '"));');
  aBrowser.ExecuteScript('editor.revealLine(1);');
  aBrowser.ExecuteScript('editor.setPosition({lineNumber: 1, column: 1});');
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TMainForm.FormShow(Sender: TObject);
begin
  var monaco := TPath.Combine(ExtractFileDir(ParamStr(0)), 'Monaco');

  var path := TPath.Combine(monaco, 'index.html');
  var url  := GetUrlPath(path);

  Browser.Visible := true;
  Browser.Navigate(url);

  path := TPath.Combine(monaco, 'pascal.html');
  url  := GetUrlPath(path);

  CodeBrowser.Visible := true;
  CodeBrowser.Navigate(url);
end;

{----------------------------------------------------------------------------------------------------------------------}
procedure TMainForm.ToolButton6Click(Sender: TObject);
begin
  TAboutForm.Execute;
end;

end.

