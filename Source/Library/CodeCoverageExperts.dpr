library CodeCoverageExperts;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  ToolsAPI,
  CCE.Constants in '..\Src\Core\CCE.Constants.pas',
  CCE.Core.CodeCoverage in '..\Src\Core\CCE.Core.CodeCoverage.pas',
  CCE.Core.Interfaces in '..\Src\Core\CCE.Core.Interfaces.pas',
  CCE.Core.Project in '..\Src\Core\CCE.Core.Project.pas',
  CCE.Core.Utils in '..\Src\Core\CCE.Core.Utils.pas',
  CCE.Helpers.TreeView in '..\Src\Core\CCE.Helpers.TreeView.pas',
  CCE.ContextMenu in '..\Src\IDE\CCE.ContextMenu.pas',
  CCE.Wizard.Forms in '..\Src\IDE\CCE.Wizard.Forms.pas' {CCEWizardForms},
  CCE.dpipes in '..\Src\Third\CCE.dpipes.pas',
  CCE.dprocess in '..\Src\Third\CCE.dprocess.pas',
  CCE.DLL.Registry in 'CCE.DLL.Registry.pas';

exports
  RegisterCodeCoverageExperts Name WizardEntryPoint;

{$R *.res}

begin
end.
