unit uSettings;

interface

procedure WriteSettingString(const aKey, aValue: string);

procedure WriteSettingInt(const aKey: string; aValue: Integer);

function ReadSettingString(const aKey, aDefaultValue: string): string;

function ReadSettingInt(const aKey: string; const aDefaultValue: Integer): Integer;

procedure GenerateSettings;

implementation

uses
  System.IniFiles, System.SysUtils;

const
  SETTINGS_FILE = 'settings.ini';

procedure WriteSettingString(const aKey, aValue: string);
begin
  var aFile := ExtractFilePath(ParamStr(0)) + SETTINGS_FILE;

  var ini := TIniFile.Create(aFile);
  try
    try
      ini.WriteString('settings', aKey, aValue);
    except
      on E: Exception do
      begin
        Writeln('============================');
        Writeln('ERROR Writing Setting STRING:');
        Writeln('Procedure: WriteSettingString');
        Writeln('Reason   : ' + E.Message);
        Writeln('Path     : ' + aFile);
        Writeln('============================');
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure WriteSettingInt(const aKey: string; aValue: Integer);
begin
  var aFile := ExtractFilePath(ParamStr(0)) + SETTINGS_FILE;

  var ini := TIniFile.Create(aFile);
  try
    try
      ini.WriteInteger('settings', aKey, aValue);
    except
      on E: Exception do
      begin
        Writeln('============================');
        Writeln('ERROR Writing Setting INT:');
        Writeln('Procedure: WriteSettingInt');
        Writeln('Reason   : ' + E.Message);
        Writeln('Path     : ' + aFile);
        Writeln('============================');
      end;
    end;
  finally
    ini.Free;
  end;
end;

function ReadSettingString(const aKey, aDefaultValue: string): string;
begin
  var aFile := ExtractFilePath(ParamStr(0)) + SETTINGS_FILE;

  var ini := TIniFile.Create(aFile);
  try
    try
      Result := ini.ReadString('settings', aKey, aDefaultValue);
    except
      on E: Exception do
      begin
        Writeln('============================');
        Writeln('ERROR Reading Setting STRING:');
        Writeln('Procedure: ReadSettingString');
        Writeln('Reason   : ' + E.Message);
        Writeln('Path     : ' + aFile);
        Writeln('============================');
      end;
    end;
  finally
    ini.Free;
  end;
end;

function ReadSettingInt(const aKey: string; const aDefaultValue: Integer): Integer;
begin
  var aFile := ExtractFilePath(ParamStr(0)) + SETTINGS_FILE;

  var ini := TIniFile.Create(aFile);
  try
    try
      Result := ini.ReadInteger('settings', aKey, aDefaultValue);
    except
      on E: Exception do
      begin
        Writeln('============================');
        Writeln('ERROR Reading Setting INT:');
        Writeln('Procedure: ReadSettingInt');
        Writeln('Reason   : ' + E.Message);
        Writeln('Path     : ' + aFile);
        Writeln('============================');
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure GenerateSettings;
begin
  if ReadSettingInt('port', 0) = 0 then
    WriteSettingInt('port', 2855);

  if ReadSettingString('apiKey', 'ChangeMe') = 'ChangeMe' then
    WriteSettingString('apiKey', 'ChangeMe');
end;

end.

