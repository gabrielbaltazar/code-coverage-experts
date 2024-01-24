unit Model.Formatter;

interface

uses
  System.SysUtils,
  System.StrUtils;

type
  TFormatter = class
  public
    function OnlyNumbers(const AText: string): string;
  end;

implementation

{ TFormatter }

function TFormatter.OnlyNumbers(const AText: string): string;
var
  I: Integer;
begin
  Result := EmptyStr;
  for I := 1 to AText.Length do
  begin
    if AText[I] in ['0'..'9'] then
      Result := Result + AText[I];
  end;
end;

end.
