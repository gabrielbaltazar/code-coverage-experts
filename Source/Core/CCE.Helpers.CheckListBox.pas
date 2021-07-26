unit CCE.Helpers.CheckListBox;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.StdCtrls,
  Vcl.CheckLst;

type TCheckListBoxHelper = class helper for TCheckListBox

  public
    function Contains(Value: string): Boolean;
    function AddOrSet(Value: String): TCheckListBox; overload;
    function AddOrSet(Value: String; bChecked: Boolean): TCheckListBox; overload;

    function Remove(Index: Integer): TCheckListBox; overload;
    function Remove(Value: String): TCheckListBox; overload;
    function Remove: TCheckListBox; overload;

    function IsSelected(Index: Integer): Boolean; overload;
    function IsSelected: Boolean; overload;
    function Value: String; overload;
    function Value(Index: Integer): string; overload;

    function SelectAll: TCheckListBox;
    function UnSelectAll: TCheckListBox;

    function Check(Value: String): TCheckListBox;
    function UnCheck(Value: String): TCheckListBox;
end;

implementation

{ TCheckListBoxHelper }

function TCheckListBoxHelper.Value: String;
begin
  result := Items[ItemIndex];
end;

function TCheckListBoxHelper.AddOrSet(Value: String): TCheckListBox;
begin
  result := Self;
  if not Contains(Value) then
    Items.Add(Value);
end;

function TCheckListBoxHelper.AddOrSet(Value: String; bChecked: Boolean): TCheckListBox;
begin
  result := Self;
  AddOrSet(Value);
  Self.Checked[Items.IndexOf(Value)] := bChecked;
end;

function TCheckListBoxHelper.Contains(Value: string): Boolean;
var
  i: Integer;
begin
  result := False;
  for i := 0 to Pred(Items.Count) do
    if Items[i].ToLower = Value.ToLower then
      Exit( True );
end;

function TCheckListBoxHelper.IsSelected: Boolean;
begin
  result := Self.Checked[ItemIndex];
end;

function TCheckListBoxHelper.Remove(Value: String): TCheckListBox;
begin
  Result := Self;
  Remove(Items.IndexOf(Value));
end;

function TCheckListBoxHelper.Remove: TCheckListBox;
begin
  result := Self;
  Remove(ItemIndex);
end;

function TCheckListBoxHelper.Remove(Index: Integer): TCheckListBox;
begin
  result := Self;
  Self.Items.Delete(Index);
end;

function TCheckListBoxHelper.Check(Value: String): TCheckListBox;
begin
  result := Self;
  Checked[Items.IndexOf(Value)] := True;
end;

function TCheckListBoxHelper.SelectAll: TCheckListBox;
begin
  result := Self;
  Self.CheckAll(TCheckBoxState.cbChecked);
end;

function TCheckListBoxHelper.UnCheck(Value: String): TCheckListBox;
begin
  result := Self;
  Checked[Items.IndexOf(Value)] := False;
end;

function TCheckListBoxHelper.UnSelectAll: TCheckListBox;
begin
  result := Self;
  Self.CheckAll(TCheckBoxState.cbUnchecked);
end;

function TCheckListBoxHelper.IsSelected(Index: Integer): Boolean;
begin
  result := Checked[Index];
end;

function TCheckListBoxHelper.Value(Index: Integer): string;
begin
  result := Items[Index];
end;

end.
