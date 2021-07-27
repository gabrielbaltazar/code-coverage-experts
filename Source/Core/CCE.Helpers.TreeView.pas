unit CCE.Helpers.TreeView;

interface

uses
  System.SysUtils,
  System.Classes,
  Vcl.ComCtrls,
  Vcl.Controls;

type TCCEHelperTreeView = class helper for TTreeView

  public
    procedure AddPath(APath: String);
    function GetNodeParent(AParentCaption: String; AParentLevel: Integer): TTreeNode;
    function FindNode(ACaption: String; ALevel: Integer; ANodeParent: TTreeNode): TTreeNode;

    function SelectedPath: string;
end;

implementation

{ TCCEHelperTreeView }


function TCCEHelperTreeView.GetNodeParent(AParentCaption: String; AParentLevel: Integer): TTreeNode;
var
  i: Integer;
  node: TTreeNode;
begin
  result := nil;
  for i := 0 to Pred(Items.Count) do
  begin
    if (Items[i].Level = AParentLevel) and
       (Items[i].Text.ToLower = AParentCaption.ToLower)
    then
      Exit( Items[i] );
  end;
end;

function TCCEHelperTreeView.SelectedPath: string;
var
  node: TTreeNode;
  parent: TTreeNode;
begin
  node := Self.Selected;
  result := node.Text;
  parent := node.Parent;

  if parent = nil then
  begin
    Result := result + '\';
    exit;
  end;

  repeat
    result := parent.Text + '\' + Result;
    parent := parent.Parent
  until (parent = nil);
end;

{ TCCEHelperTreeView }

procedure TCCEHelperTreeView.AddPath(APath: String);
var
  i: Integer;
  list: TStringList;
  nodeParent: TTreeNode;
  node: TTreeNode;
  text: String;
begin
  list := TStringList.Create;
  try
    list.Delimiter := '\';
    list.StrictDelimiter := True;
    list.DelimitedText := APath;

    nodeParent := nil;
    for i := 0 to Pred(list.Count) do
    begin
      text := list[i];
      node := FindNode(text, i, nodeParent);

      if Assigned(node) then
        Continue;

      if (i > 0) and (nodeParent = nil) then
        nodeParent := GetNodeParent(list[i - 1], i - 1);

      node := FindNode(text, i, nodeParent);
      if not Assigned(node) then
        nodeParent := Items.AddChild(nodeParent, text)
    end;

  finally
    list.Free;
  end;
end;

function TCCEHelperTreeView.FindNode(ACaption: String; ALevel: Integer; ANodeParent: TTreeNode): TTreeNode;
var
  i: Integer;
  childNode: TTreeNode;
begin
  result := nil;
  if Assigned(ANodeParent) then
  begin
    childNode := ANodeParent.getFirstChild;

    while childNode <> nil do
    begin
      if childNode.Text.ToLower = ACaption.ToLower then
        Exit( childNode );

      childNode := ANodeParent.GetNextChild(childNode);
    end;

    Exit;
  end;

  for i := 0 to Pred(Items.Count) do
  begin
    if (Items[i].Level = ALevel) and
       (Items[i].Text.ToLower = ACaption.ToLower)
    then
    begin
      if not Assigned(ANodeParent) then
        Exit(Items[i])
      else
      if ANodeParent.Text.ToLower = Items[i].Parent.Text.ToLower then
        Exit(Items[i]);

    end;
  end;
end;

end.
