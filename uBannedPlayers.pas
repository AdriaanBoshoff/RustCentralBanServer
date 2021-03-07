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
    BannedPlayers: TDictionary<string, TPlayer>;
  public
    procedure AddBan(const aSteamID: string; const aReason: WideString; const aExpires: Int64);
    procedure RemoveBan(const aSteamID: string);
    function GetBan(const aSteamID: string): WideString;
  published
    constructor Create;
    destructor Free;
  end;

var
  BannedPlayers: TBannedPlayers;

implementation

{ TBannedPlayers }

procedure TBannedPlayers.AddBan(const aSteamID: string; const aReason: WideString; const aExpires: Int64);
begin
  var aPlayer: TPlayer;
  aPlayer.SteamID := aSteamID;
  aPlayer.Reason := aReason;
  aPlayer.Expires := aExpires;

  BannedPlayers.Add(aPlayer.SteamID, aPlayer);
end;

constructor TBannedPlayers.Create;
begin
  BannedPlayers := TDictionary<string, TPlayer>.Create;
end;

destructor TBannedPlayers.Free;
begin
  BannedPlayers.Free;
end;

function TBannedPlayers.GetBan(const aSteamID: string): WideString;
begin
  var aPlayer: TPlayer;

  if BannedPlayers.TryGetValue(aSteamID, aPlayer) then
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
    Writeln('============================');
    Writeln('ERROR Getting Ban:');
    Writeln('Procedure        : GetBan');
    Writeln('Reason           : Ban does not exist.');
    Writeln('SteamID Requested: ' + aSteamID);
    Writeln('============================');
  end;
end;

procedure TBannedPlayers.RemoveBan(const aSteamID: string);
begin
  BannedPlayers.Remove(aSteamID);
end;

end.

