unit uMisc;

interface

implementation

uses
  System.Classes, System.SysUtils;

function LoadFromFile(const aFile: string): WideString;
begin
  var sList := TStringList.Create;
  try
    try
      sList.LoadFromFile(aFile, TEncoding.UTF8);
      Result := sList.Text;
    except
      on E: Exception do
      begin
        Result := '';
        Writeln('============================');
        Writeln('ERROR Loading FILE:');
        Writeln('Procedure: LoadFromFile');
        Writeln('Reason   : File does not exist.');
        Writeln('Path     : ' + aFile);
        Writeln('============================');
      end;
    end;
  finally
    sList.Free;
  end;
end;

procedure SaveToFile(const aText, aFile: WideString);
begin
  var sList := TStringList.Create;
  try
    sList.Text := aText;

    try
      sList.SaveToFile(aFile, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        Writeln('============================');
        Writeln('ERROR Writing FILE:');
        Writeln('Procedure: SaveToFile');
        Writeln('Reason   : ' + E.Message);
        Writeln('Path     : ' + aFile);
        Writeln('============================');
      end;
    end;
  finally
    sList.Free;
  end;
end;

end.

