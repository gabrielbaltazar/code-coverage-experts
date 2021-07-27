object CCEWizardForms: TCCEWizardForms
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 486
  ClientWidth = 904
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
    Width = 904
    Height = 404
    ActivePage = tsTreeView
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
        Text = 
          'D:\Desenvolvimento\workspace\Delphi\FormacaoDelphiSenior\Tests\P' +
          'rojetoBase\Bin\FormacaoERPTest.exe'
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
        Text = 
          'D:\Desenvolvimento\workspace\Delphi\FormacaoDelphiSenior\Tests\P' +
          'rojetoBase\Bin\FormacaoERPTest.map'
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
      object edtOutputReport: TLabeledEdit
        Left = 11
        Top = 191
        Width = 607
        Height = 21
        EditLabel.Width = 76
        EditLabel.Height = 13
        EditLabel.Caption = 'Output Report'
        TabOrder = 6
        Text = '.\Report'
      end
      object btnOutputReport: TButton
        Left = 624
        Top = 189
        Width = 33
        Height = 25
        Caption = '...'
        TabOrder = 7
        OnClick = btnOutputReportClick
      end
      object grpOutputFormat: TGroupBox
        Left = 11
        Top = 232
        Width = 606
        Height = 141
        Caption = 'Output'
        TabOrder = 8
        object chkXmlReport: TCheckBox
          Left = 16
          Top = 24
          Width = 393
          Height = 17
          Caption = 'XML coverage output as '#39'CodeCoverage_Summary.xml'#39' (-xml)'
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object chkHtmlReport: TCheckBox
          Left = 16
          Top = 47
          Width = 393
          Height = 17
          Caption = 'HTML coverage output as '#39'CodeCoverage_Summary.html'#39' (-html)'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object chkEmmaReport: TCheckBox
          Left = 16
          Top = 70
          Width = 393
          Height = 17
          Caption = 'EMMA coverage output as '#39'coverage.es'#39' (-emma)'
          TabOrder = 2
        end
        object chkLog: TCheckBox
          Left = 16
          Top = 93
          Width = 105
          Height = 17
          Caption = 'Generate Log'
          Checked = True
          State = cbChecked
          TabOrder = 3
        end
        object chkUseRelativePath: TCheckBox
          Left = 16
          Top = 116
          Width = 129
          Height = 17
          Caption = 'Use Relative Path'
          Checked = True
          State = cbChecked
          TabOrder = 4
        end
      end
    end
    object tsPaths: TTabSheet
      Caption = 'Paths'
      ImageIndex = 1
      object Label1: TLabel
        Left = 3
        Top = 5
        Width = 28
        Height = 13
        Caption = 'Paths'
      end
      object Label2: TLabel
        Left = 3
        Top = 197
        Width = 27
        Height = 13
        Caption = 'Units'
      end
      object chklstPaths: TCheckListBox
        Left = 3
        Top = 24
        Width = 878
        Height = 145
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 17
        ParentFont = False
        PopupMenu = pmPaths
        TabOrder = 0
      end
      object chkLstUnits: TCheckListBox
        Left = 3
        Top = 216
        Width = 878
        Height = 158
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = []
        ItemHeight = 17
        ParentFont = False
        PopupMenu = pmUnits
        TabOrder = 1
      end
    end
    object tsTreeView: TTabSheet
      Caption = 'tsTreeView'
      ImageIndex = 2
      object tvPaths: TTreeView
        Left = 11
        Top = 16
        Width = 414
        Height = 345
        Indent = 19
        TabOrder = 0
        OnClick = tvPathsClick
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 445
    Width = 904
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnNext: TButton
      Left = 324
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Next'
      TabOrder = 0
      OnClick = btnNextClick
    end
    object btnPrevious: TButton
      Left = 224
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Previous'
      TabOrder = 1
      OnClick = btnPreviousClick
    end
    object btnFinish: TButton
      Left = 436
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Finish'
      TabOrder = 2
      OnClick = btnFinishClick
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 904
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 15
      Top = 3
      Width = 160
      Height = 35
      Margins.Left = 15
      Align = alLeft
      Caption = 'Code Coverage Experts'
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
  object pmPaths: TPopupMenu
    Left = 368
    object SelectAll1: TMenuItem
      Caption = 'Check All'
      OnClick = SelectAll1Click
    end
    object UnselectAll1: TMenuItem
      Caption = 'UnCheck All'
      OnClick = UnselectAll1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ChgeckUnits1: TMenuItem
      Caption = 'Check Units'
    end
    object RemovePath1: TMenuItem
      Caption = 'UnCheck Units'
      OnClick = RemovePath1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
  end
  object pmUnits: TPopupMenu
    Left = 448
    object MenuItem1: TMenuItem
      Caption = 'Select All'
      OnClick = MenuItem1Click
    end
    object MenuItem2: TMenuItem
      Caption = 'UnSelect All'
      OnClick = MenuItem2Click
    end
  end
  object openTextDialog: TOpenTextFileDialog
    Left = 600
    Top = 8
  end
end
