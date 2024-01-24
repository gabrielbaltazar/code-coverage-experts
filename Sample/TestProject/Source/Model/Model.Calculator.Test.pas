unit Model.Calculator.Test;

interface

uses
  DUnitX.TestFramework,
  Model.Calculator,
  System.SysUtils;

type
  [TestFixture]
  TCalculatorTest = class
  private
    FCalculator: TCalculator;
    FResult: Double;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Sum;

    [Test]
    procedure Subtract;
  end;

implementation

procedure TCalculatorTest.Setup;
begin
  FCalculator := TCalculator.Create;
  FResult := 0;
end;

procedure TCalculatorTest.Subtract;
begin
  FResult := FCalculator.Subtract(10, 5);
  Assert.AreEqual<Double>(5, FResult);
end;

procedure TCalculatorTest.Sum;
begin
  FResult := FCalculator.Sum(10, 5);
  Assert.AreEqual<Double>(15, FResult);
end;

procedure TCalculatorTest.TearDown;
begin
  FCalculator.Free;
end;

end.
