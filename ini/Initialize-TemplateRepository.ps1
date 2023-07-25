# NOTE: it is not recommended to change ANY of the Parameters, but area avilable.

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [String]$TemplateProjectName = "template-python",
    [String]$ConfigIniFileName = "config.ini.json",
    [String]$ConfigMetaFileName = "config.meta.json"
)


# defining config
$RootPath = (Get-Item $PSScriptRoot).Parent.FullName
$ConfigPath = (Get-ChildItem $RootPath -Recurse -Filter "config").FullName

$ConfigFile = (Get-ChildItem $ConfigPath -Recurse -Filter "*$ConfigIniFileName").FullName
$MetaFile = (Get-ChildItem $ConfigPath -Recurse -Filter "*$ConfigMetaFileName").FullName

$Config = Get-Content $ConfigFile | ConvertFrom-Json
$Meta = Get-Content $MetaFile | ConvertFrom-Json

# collecting project name
$ProjectName = (Get-Item $RootPath).Name

# collecting changable files in permitted directories
$Directories = (Get-ChildItem $RootPath -Directory -Force -Exclude ini, .vscode, docs, *cache)
[System.Collections.ArrayList]$Files = (Get-ChildItem $RootPath -File).FullName
foreach ($Dir in $Directories.FullName) {
    $Files += (Get-ChildItem $Dir -File -Recurse -Exclude *.pyc).FullName
}

function ReplaceContents {
    # places contents in a given file if the updated contents are not the same
    param (
        [String]$JobName,
        [Array]$Files,
        [String]$OldText,
        [String]$NewText
    )
    
    foreach ($File in $Files) {
        $Contents = [System.IO.File]::ReadAllText($File)
        $UpdatedContents = $Contents.Replace($OldText, $NewText)

        if ( $Contents -ne $UpdatedContents ) {
            Set-Content -Path $File -Value $UpdatedContents
            Write-Output "Replace-Content  [$JobName] : Updated  $File"
        }
    }
}

function RenameDirectory {
    # places contents in a given file if the updated contents are not the same
    param (
        [String]$JobName,
        [Array]$Directories,
        [String]$OldName,
        [String]$NewName
    )
    
    foreach ($Dir in $Directories) {
        if ( $Dir.Name -eq $OldName ) {
            Rename-Item -Path $Dir.FullName -NewName $NewName
            Write-Output "Rename-Directory  [$JobName] : Updated  $($Dir.FullName)   to   $NewName"
        }
    }
}


# ----- Excecuting Jobs -----

# replace README logo
ReplaceContents -JobName "ProjectLogoPath" `
    -Files $Files `
    -OldText $Meta.ProjectLogoPath `
    -NewText $Config.ProjectLogoPath

# replace README tagline
ReplaceContents -JobName "ProjectTagline" `
    -Files $Files `
    -OldText $Meta.ProjectTagline `
    -NewText $Config.ProjectTagline

# replace stackshare account in README
ReplaceContents -JobName "StackShareAccount" `
    -Files $Files `
    -OldText "https://stackshare.io/$($Meta.StackShareAccount)" `
    -NewText "https://stackshare.io/$($Config.StackShareAccount)"


# replace codecov account in README
ReplaceContents -JobName "CodeCovAccount" `
    -Files $Files `
    -OldText "https://codecov.io/gh/$($Meta.CodeCovAccount)" `
    -NewText "https://codecov.io/gh/$($Config.CodeCovAccount)"

# replace github account in README
ReplaceContents -JobName "GitHubAccount" `
    -Files $Files `
    -OldText "$($Meta.GitHubAccount)/$ProjectName" `
    -NewText "$($Config.GitHubAccount)/$ProjectName"

# replace dockerhub account in ci file
ReplaceContents -JobName "DockerHubAccount" `
    -Files $Files `
    -OldText "image: $($Meta.DockerHubAccount)" `
    -NewText "image: $($Config.DockerHubAccount)"

# replace ProjectName everywhere
ReplaceContents -JobName "ProjectName" `
    -Files $Files `
    -OldText $TemplateProjectName `
    -NewText $ProjectName

# Updating pyproject to include new ProjectName as module
# NOTE: Python modules must be snake_case 
ReplaceContents -JobName "ProjectModuleName" `
    -Files $Files `
    -OldText "snek_case" `
    -NewText $ProjectName.Replace("-", "_")

# renaming directories for ProjectName
# NOTE: Python modules must be snake_case 
RenameDirectory -JobName "ProjectDirectoryName" `
    -Directories $Directories `
    -OldName "snek_case" `
    -NewName $ProjectName.Replace("-", "_")

# Replacing config.meta for next interation
$Config | ConvertTo-Json  | Set-Content $MetaFile
Write-Output "New Metadata Saved to $MetaFile"
