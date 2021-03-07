unit uSettings;

interface

procedure WriteSettingString(const aKey, aValue: string);

procedure WriteSettingInt(const aKey: string; aValue: Integer);

function ReadSettingString(const aKey, aDefaultValue: string): string;

function ReadSettingInt(const aKey: string; const aDefaultValue: Integer): Integer;

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
    ini.WriteString('settings', aKey, aValue);
  finally
    ini.Free;
  end;
end;

procedure WriteSettingInt(const aKey: string; aValue: Integer);
begin
  var aFile := ExtractFilePath(ParamStr(0)) + SETTINGS_FILE;

  var ini := TIniFile.Create(aFile);
  try
    ini.WriteInteger('settings', aKey, aValue);
  finally
    ini.Free;
  end;
end;

function ReadSettingString(const aKey, aDefaultValue: string): string;
begin
  var aFile := ExtractFilePath(ParamStr(0)) + SETTINGS_FILE;

  var ini := TIniFile.Create(aFile);
  try
    Result := ini.ReadString('settings', aKey, aDefaultValue);
  finally
    ini.Free;
  end;
end;

function ReadSettingInt(const aKey: string; const aDefaultValue: Integer): Integer;
begin
  var aFile := ExtractFilePath(ParamStr(0)) + SETTINGS_FILE;

  var ini := TIniFile.Create(aFile);
  try
    Result := ini.ReadInteger('settings', aKey, aDefaultValue);
  finally
    ini.Free;
  end;
end;

end.

