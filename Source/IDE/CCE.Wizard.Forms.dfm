object CCEWizardForms: TCCEWizardForms
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 354
  ClientWidth = 727
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pgcWizard: TPageControl
    Left = 0
    Top = 41
    Width = 727
    Height = 272
    ActivePage = tsPaths
    Align = alClient
    TabOrder = 0
    object tsFiles: TTabSheet
      Caption = 'Files'
      object edtExeName: TLabeledEdit
        Left = 10
        Top = 79
        Width = 607
        Height = 21
        EditLabel.Width = 72
        EditLabel.Height = 13
        EditLabel.Caption = 'Delphi Project'
        TabOrder = 2
      end
      object btnSelectExeName: TButton
        Left = 623
        Top = 77
        Width = 33
        Height = 25
        Caption = '...'
        TabOrder = 3
        OnClick = btnSelectExeNameClick
      end
      object edtMapFileName: TLabeledEdit
        Left = 11
        Top = 135
        Width = 607
        Height = 21
        EditLabel.Width = 82
        EditLabel.Height = 13
        EditLabel.Caption = 'Map File Project'
        TabOrder = 4
      end
      object btnSelectMapFile: TButton
        Left = 624
        Top = 133
        Width = 33
        Height = 25
        Caption = '...'
        TabOrder = 5
        OnClick = btnSelectMapFileClick
      end
      object edtCoverageExeName: TLabeledEdit
        Left = 11
        Top = 23
        Width = 607
        Height = 21
        EditLabel.Width = 78
        EditLabel.Height = 13
        EditLabel.Caption = 'Code Coverage'
        TabOrder = 0
        Text = 'CodeCoverage.exe'
      end
      object btnSelectCodeCoverage: TButton
        Left = 624
        Top = 21
        Width = 33
        Height = 25
        Caption = '...'
        TabOrder = 1
        OnClick = btnSelectCodeCoverageClick
      end
    end
    object tsPaths: TTabSheet
      Caption = 'Paths'
      ImageIndex = 1
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 313
    Width = 727
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnNext: TButton
      Left = 396
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Next'
      TabOrder = 0
      OnClick = btnNextClick
    end
    object btnPrevious: TButton
      Left = 224
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Previous'
      TabOrder = 1
      OnClick = btnPreviousClick
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 727
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 15
      Top = 3
      Width = 159
      Height = 35
      Margins.Left = 15
      Align = alLeft
      Caption = 'Code Coverage Wizard'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitHeight = 21
    end
  end
  object openTextDialog: TOpenTextFileDialog
    Filter = 'Test Project |*.exe|Map Project|*.map'
    Left = 12
    Top = 313
  end
end
