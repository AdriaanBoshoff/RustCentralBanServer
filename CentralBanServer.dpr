program CentralBanServer;
{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Types,
  System.Classes,
  IPPeerServer,
  IPPeerAPI,
  IdHTTPWebBrokerBridge,
  Web.WebReq,
  Web.WebBroker,
  dmWebModule in 'dmWebModule.pas' {WebModuleActions: TWebModule},
  ServerConst in 'ServerConst.pas',
  uMisc in 'uMisc.pas',
  uBannedPlayers in 'uBannedPlayers.pas',
  uSettings in 'uSettings.pas';

{$R *.res}

function BindPort(APort: Integer): Boolean;
var
  LTestServer: IIPTestServer;
begin
  Result := True;
  try
    LTestServer := PeerFactory.CreatePeer('', IIPTestServer) as IIPTestServer;
    LTestServer.TestOpenPort(APort, nil);
  except
    Result := False;
  end;
end;

function CheckPort(APort: Integer): Integer;
begin
  if BindPort(APort) then
    Result := APort
  else
    Result := 0;
end;

procedure SetPort(const AServer: TIdHTTPWebBrokerBridge; APort: string);
begin
  if not AServer.Active then
  begin
    APort := APort.Replace(cCommandSetPort, '').Trim;
    if CheckPort(APort.ToInteger) > 0 then
    begin
      AServer.DefaultPort := APort.ToInteger;
      WriteSettingInt('port', APort.ToInteger);
      Writeln(Format(sPortSet, [APort]));
    end
    else
      Writeln(Format(sPortInUse, [APort]));
  end
  else
    Writeln(sServerRunning);
  Write(cArrow);
end;

procedure StartServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if ReadSettingString('apiKey', 'ChangeMe') = 'ChangeMe' then
  begin
    Writeln('You make a custom apiKey in the settings file before starting the server!');
    Exit;
  end;

  if not AServer.Active then
  begin
    if CheckPort(AServer.DefaultPort) > 0 then
    begin
      Writeln(Format(sStartingServer, [AServer.DefaultPort]));
      AServer.Bindings.Clear;
      AServer.Active := True;
    end
    else
      Writeln(Format(sPortInUse, [AServer.DefaultPort.ToString]));
  end
  else
    Writeln(sServerRunning);
  Write(cArrow);
end;

procedure StopServer(const AServer: TIdHTTPWebBrokerBridge);
begin
  if AServer.Active then
  begin
    Writeln(sStoppingServer);
    AServer.Active := False;
    AServer.Bindings.Clear;
    Writeln(sServerStopped);
  end
  else
    Writeln(sServerNotRunning);
  Write(cArrow);
end;

procedure AddBan(const aCommand: string);
begin
  var args := TStringList.Create;
  try
    args.DelimitedText := aCommand.Replace(cCommandAddBan, '').Trim;

    if args.Count = 3 then
    begin
      var aSteamId := args[0];
      var aReason := args[1];
      var aExpires := args[2].ToInt64;

      BannedPlayers.AddBan(aSteamId, aReason, aExpires);
    end
    else
    begin
      Writeln('Cannot add ban. Invalid Args');
    end;
  finally
    args.Free;
  end;
end;

procedure RemoveBan(const aCommand: string);
begin
  var args := TStringList.Create;
  try
    args.DelimitedText := aCommand.Replace(cCommandRemoveBan, '').Trim;

    if args.Count = 1 then
    begin
      var aSteamId := args[0];

      BannedPlayers.RemoveBan(aSteamId);
    end
    else
    begin
      Writeln('Cannot add ban. Invalid Args');
    end;
  finally
    args.Free;
  end;
end;

procedure WriteCommands;
begin
  Writeln(sCommands);
  Write(cArrow);
end;

procedure WriteStatus(const AServer: TIdHTTPWebBrokerBridge);
begin
  Writeln(sIndyVersion + AServer.SessionList.Version);
  Writeln(sActive + AServer.Active.ToString(TUseBoolStrs.True));
  Writeln(sPort + AServer.DefaultPort.ToString);
  Writeln(sBannedCount + BannedPlayers.BanCount.ToString);
  Write(cArrow);
end;

procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
  LResponse: string;
begin
  WriteCommands;
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  BannedPlayers := TBannedPlayers.Create;
  try
    BannedPlayers.AddBan('test', 'This is a test ban', -1);

    LServer.DefaultPort := APort;
    while True do
    begin
      Readln(LResponse);
      LResponse := LowerCase(LResponse);
      if LResponse.StartsWith(cCommandSetPort) then
        SetPort(LServer, LResponse)
      else if sametext(LResponse, cCommandStart) then
        StartServer(LServer)
      else if LResponse.StartsWith(cCommandAddBan) then
        AddBan(LResponse)
      else if LResponse.StartsWith(cCommandRemoveBan) then
        RemoveBan(LResponse)
      else if sametext(LResponse, cCommandStatus) then
        WriteStatus(LServer)
      else if sametext(LResponse, cCommandStop) then
        StopServer(LServer)
      else if sametext(LResponse, cCommandHelp) then
        WriteCommands
      else if sametext(LResponse, cCommandExit) then
        if LServer.Active then
        begin
          StopServer(LServer);
          break
        end
        else
          break
      else
      begin
        Writeln(sInvalidCommand);
        Write(cArrow);
      end;
    end;
  finally
    BannedPlayers.Free;
    LServer.Free;
  end;
end;

begin
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;

    GenerateSettings;

    RunServer(ReadSettingInt('port', 2855));
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.

