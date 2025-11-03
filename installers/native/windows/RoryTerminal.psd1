# Module manifest for RoryTerminal

@{

# Script module or binary module file associated with this manifest.
RootModule = 'RoryTerminal.psm1'

# Version number of this module.
ModuleVersion = '3.0.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'

# Author of this module
Author = 'Roderick Lawrence Renwick'

# Company or vendor of this module
CompanyName = 'RLR-GitHub'

# Copyright statement for this module
Copyright = '(c) 2024 Roderick Lawrence Renwick. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Rory Terminal PowerShell Module - Cyberpunk terminal themes with Matrix animations. Provides cmdlets for managing themes, running animations, and integrating with Windows Terminal.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Get-RoryTheme',
    'Set-RoryTheme',
    'Start-RoryMatrix',
    'Show-RoryThemeSelector',
    'Install-RoryTerminal',
    'Uninstall-RoryTerminal'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Terminal', 'Theme', 'Cyberpunk', 'Matrix', 'Customization', 'WindowsTerminal', 'PowerShell')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/RLR-GitHub/terminal-themes/blob/main/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/RLR-GitHub/terminal-themes'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = @'
## Version 3.0.0
- Initial release of RoryTerminal PowerShell module
- 5 cyberpunk themes (Halloween, Christmas, Easter, Hacker, Matrix)
- Windows Terminal integration
- GUI theme selector
- Matrix animations
- Automated theme management cmdlets
'@

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
HelpInfoURI = 'https://github.com/RLR-GitHub/terminal-themes/wiki'

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
