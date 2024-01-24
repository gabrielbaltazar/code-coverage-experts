unit Model.Calculator;

interface

uses
  System.SysUtils,
  System.StrUtils;

type
  TCalculator = class
  public
    function Sum(ANum1, ANum2: Double): Double;
    function Subtract(ANum1, ANum2: Double): Double;
    function Multiply(ANum1, ANum2: Double): Double;
  end;

implementation

{ TCalculator }

function TCalculator.Multiply(ANum1, ANum2: Double): Double;
begin
  Result := ANum1 * ANum2;
end;

function TCalculator.Subtract(ANum1, ANum2: Double): Double;
begin
  Result := ANum1 - ANum2;
end;

function TCalculator.Sum(ANum1, ANum2: Double): Double;
begin
  Result := ANum1 + ANum2;
end;

end.
