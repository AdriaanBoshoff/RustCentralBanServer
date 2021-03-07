unit dmWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TWebModuleActions = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModuleActions;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TWebModuleActions.WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' + '<head><title>Central Ban Server</title></head>' + '<body>This is the rust central ban server provided with RSMfmx</body>' + '</html>';
end;

end.

