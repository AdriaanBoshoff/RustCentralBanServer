unit dmWebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TWebModuleActions = class(TWebModule)
    procedure WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleActionsrustBansAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
    procedure WebModuleActionsAddRustBansAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWebModuleActions;

implementation

uses
  uBannedPlayers, System.JSON, uSettings;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TWebModuleActions.WebModule1DefaultHandlerAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Response.Content := '<html>' + '<head><title>Central Ban Server</title></head>' + '<body>This is the rust central ban server provided with RSMfmx</body>' + '</html>';
end;

procedure TWebModuleActions.WebModuleActionsAddRustBansAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  var jdata := TJSONObject.ParseJSONValue(Request.Content);
  try
    try
      var aKey := jdata.GetValue<string>('apiKey');

      if aKey = ReadSettingString('apiKey', '') then
      begin
        var aSteamId := jdata.GetValue<string>('steamId');
        var aReason := jdata.GetValue<string>('reason');
        var aExpires := jdata.GetValue<Int64>('expiryDate');

        BannedPlayers.AddBan(aSteamId, aReason, aExpires);

        Response.StatusCode := 200;

        Handled := True;
      end
      else
      begin
        Response.StatusCode := 403;
        Handled := True;
      end;
    except
      on E: Exception do
      begin
        Response.StatusCode := 500;
        Writeln(E.Message);
        Handled := True;
      end;
    end;
  finally
    jdata.Free;
  end;
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

