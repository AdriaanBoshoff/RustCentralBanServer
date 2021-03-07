unit dmWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TWebModuleActions = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleActionsrustBansAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModuleActions;

implementation

uses
  uBannedPlayers;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TWebModuleActions.WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' + '<head><title>Central Ban Server</title></head>' + '<body>This is the rust central ban server provided with RSMfmx</body>' + '</html>';
end;

procedure TWebModuleActions.WebModuleActionsrustBansAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  var aSteamID := Request.PathInfo.Replace('/api/rustBans/', '', [rfIgnoreCase]);
  aSteamID := aSteamID.Replace('/', '', [rfReplaceAll]);

  var data := BannedPlayers.GetBan(aSteamID);

  if data = '' then
  begin
    Response.StatusCode := 404;
    Response.Content := 'Ban does not exist';
    Handled := True;
  end
  else
  begin
    Response.StatusCode := 200;
    Response.Content := data;
    Response.ContentType := 'application/json';
    Handled := True;
  end;
end;

end.

