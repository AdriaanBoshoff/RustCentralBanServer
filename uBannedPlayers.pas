unit uBannedPlayers;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  System.JSON.Types, System.JSON.Writers;

type
  TPlayer = record
    SteamID: string;
    Reason: WideString;
    Expires: Int64;
  end;

type
  TBannedPlayers = class
  private
    var
      Bans: TDictionary<string, TPlayer>;
    const
      BANS_FILE = 'bans.json';
    procedure SaveBans;
    procedure LoadBans;
  public
    procedure AddBan(const aSteamID: string; const aReason: WideString; const aExpires: Int64);
    procedure RemoveBan(const aSteamID: string);
    function GetBan(const aSteamID: string): WideString;
    function BanCount: Integer;
  published
    constructor Create;
    destructor Free;
  end;

var
  BannedPlayers: TBannedPlayers;

implementation

uses
  uMisc, System.IOUtils, System.JSON;

{ TBannedPlayers }

procedure TBannedPlayers.AddBan(const aSteamID: string; const aReason: WideString; const aExpires: Int64);
begin
  var pCheckDup: TPlayer;
  if not Bans.TryGetValue(aSteamID, pCheckDup) then
  begin
    var aPlayer: TPlayer;
    aPlayer.SteamID := aSteamID;
    aPlayer.Reason := aReason;
    aPlayer.Expires := aExpires;

    Bans.Add(aPlayer.SteamID, aPlayer);
    Writeln('Added Ban - ' + aSteamID);

    if aSteamID <> 'test' then
      SaveBans;
  end;
end;

function TBannedPlayers.BanCount: Integer;
begin
  Result := Bans.Count;
end;

constructor TBannedPlayers.Create;
begin
  Bans := TDictionary<string, TPlayer>.Create;
  LoadBans;
end;

destructor TBannedPlayers.Free;
begin
  Bans.Free;
end;

function TBannedPlayers.GetBan(const aSteamID: string): WideString;
begin
  var aPlayer: TPlayer;

  if Bans.TryGetValue(aSteamID, aPlayer) then
  begin
    var StringWriter := TStringWriter.Create;
    var Writer := TJsonTextWriter.Create(StringWriter);
    try
      Writer.Formatting := TJsonFormatting.Indented;

      try
        Writer.WriteStartObject;
        Writer.WritePropertyName('steamId');
        Writer.WriteValue(aPlayer.SteamID);
        Writer.WritePropertyName('reason');
        Writer.WriteValue(aPlayer.Reason);
        Writer.WritePropertyName('expiryDate');
        Writer.WriteValue(aPlayer.Expires);
        Writer.WriteEndObject;

        Result := StringWriter.ToString;
      except
        on E: Exception do
        begin
          Result := '';
          Writeln('============================');
          Writeln('ERROR Getting Ban:');
          Writeln('Procedure        : GetBan');
          Writeln('Reason           : ' + E.Message);
          Writeln('SteamID Requested: ' + aSteamID);
          Writeln('============================');
        end;
      end;
    finally
      Writer.Free;
      StringWriter.Free;
    end;
  end
  else
  begin
    Result := '';
    Writeln('Get Ban "' + aSteamID + '" - Ban does not exist.');
//    Writeln('============================');
//    Writeln('ERROR Getting Ban:');
//    Writeln('Procedure        : GetBan');
//    Writeln('Reason           : Ban does not exist.');
//    Writeln('SteamID Requested: ' + aSteamID);
//    Writeln('============================');
  end;
end;

procedure TBannedPlayers.LoadBans;
begin
  Bans.Clear;

  var aFile := ExtractFilePath(ParamStr(0)) + BANS_FILE;

  if not FileExists(aFile) then
  begin
    Writeln('There are no saved bans to load yet.');
    Exit;
  end;

  var jsonBytes := TFile.ReadAllBytes(aFile);

  var jdata := TJSONObject.ParseJSONValue(jsonBytes, 0, True) as TJSONArray;
  try
    for var aBan in jdata do
    begin
      var aPlayer: TPlayer;
      aPlayer.SteamID := aBan.GetValue<string>('steamId');
      aPlayer.Reason := aBan.GetValue<string>('reason');
      aPlayer.Expires := aBan.GetValue<Int64>('expiryDate');

      Bans.Add(aPlayer.SteamID, aPlayer);
    end;

    Writeln('Loaded ' + Bans.Count.ToString + ' Bans');
  finally
    jdata.Free;
  end;
end;

procedure TBannedPlayers.RemoveBan(const aSteamID: string);
begin
  Bans.Remove(aSteamID);
  Writeln('Removed ban - ' + aSteamID);
end;

procedure TBannedPlayers.SaveBans;
begin
  var StringWriter := TStringWriter.Create;
  var Writer := TJsonTextWriter.Create(StringWriter);
  try
    Writer.Formatting := TJsonFormatting.Indented;
    try
      Writer.WriteStartArray;
      for var aPlayer in Bans.Values do
      begin
        Writer.WriteStartObject;
        Writer.WritePropertyName('steamId');
        Writer.WriteValue(aPlayer.SteamID);
        Writer.WritePropertyName('reason');
        Writer.WriteValue(aPlayer.Reason);
        Writer.WritePropertyName('expiryDate');
        Writer.WriteValue(aPlayer.Expires);
        Writer.WriteEndObject;
      end;
      Writer.WriteEndArray;

      SaveToFile(StringWriter.ToString, ExtractFilePath(ParamStr(0)) + BANS_FILE);

      Writeln('Saved ' + Bans.Count.ToString + ' bans');
    except
      on E: Exception do
      begin
        Writeln('============================');
        Writeln('ERROR Savings Bans:');
        Writeln('Procedure        : SaveBans');
        Writeln('Reason           : ' + E.Message);
        Writeln('============================');
      end;
    end;
  finally
    Writer.Free;
    StringWriter.Free;
  end;
end;

end.

