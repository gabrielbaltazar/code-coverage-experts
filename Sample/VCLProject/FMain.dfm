object FrmMain: TFrmMain
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'VCL Project'
  ClientHeight = 409
  ClientWidth = 715
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 21
  object Label1: TLabel
    Left = 48
    Top = 72
    Width = 71
    Height = 21
    Caption = 'Number 1'
  end
  object Label2: TLabel
    Left = 216
    Top = 72
    Width = 71
    Height = 21
    Caption = 'Number 2'
  end
  object Label3: TLabel
    Left = 48
    Top = 200
    Width = 43
    Height = 21
    Caption = 'Result'
  end
  object Label4: TLabel
    Left = 48
    Top = 328
    Width = 26
    Height = 21
    Caption = 'Text'
  end
  object Label5: TLabel
    Left = 424
    Top = 328
    Width = 43
    Height = 21
    Caption = 'Result'
  end
  object EdtNumber1: TEdit
    Left = 48
    Top = 95
    Width = 145
    Height = 29
    NumbersOnly = True
    TabOrder = 0
  end
  object EdtNumber2: TEdit
    Left = 216
    Top = 95
    Width = 145
    Height = 29
    NumbersOnly = True
    TabOrder = 1
  end
  object EdtResult: TEdit
    Left = 48
    Top = 223
    Width = 145
    Height = 29
    NumbersOnly = True
    ReadOnly = True
    TabOrder = 2
  end
  object BtnSum: TButton
    Left = 48
    Top = 152
    Width = 105
    Height = 25
    Caption = 'Sum'
    TabOrder = 3
    OnClick = BtnSumClick
  end
  object BtnSubtract: TButton
    Left = 176
    Top = 152
    Width = 105
    Height = 25
    Caption = 'Subtract'
    TabOrder = 4
    OnClick = BtnSubtractClick
  end
  object EdtText: TEdit
    Left = 48
    Top = 351
    Width = 233
    Height = 29
    TabOrder = 5
  end
  object BtnOnlyNumber: TButton
    Left = 287
    Top = 353
    Width = 105
    Height = 25
    Caption = 'Only Number'
    TabOrder = 6
    OnClick = BtnOnlyNumberClick
  end
  object EdtResultOnlyNumber: TEdit
    Left = 424
    Top = 351
    Width = 145
    Height = 29
    ReadOnly = True
    TabOrder = 7
  end
end
