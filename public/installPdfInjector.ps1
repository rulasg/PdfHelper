
Set-MyInvokeCommandAlias -Alias "RepoClone" -Command 'gh repo clone {repowithowner} {folder}'
Set-MyInvokeCommandAlias -Alias "DotnetBuild" -Command 'dotnet build {projectFolder} -c Release -o {outFolder}'

# LOCAL
# - pdfInjector
#     - bin
#         - PdfInjector.exe
#     - PdfInjectorRepo
#         - .git
#         - src
#             - PdfInjector

# Variables
$LOCAL = $PSScriptRoot
$PDF_INJECTOR_FOLDER = $LOCAL | split-path -Parent | Join-Path -ChildPath "pdfInjector"

$PDF_INJECTOR_BIN          = $PDF_INJECTOR_FOLDER | Join-Path -ChildPath "bin"
$PDF_INJECTOR_EXE          = $PDF_INJECTOR_FOLDER | Join-Path -ChildPath "bin" -AdditionalChildPath "PdfInjector"
$PDF_INJECTOR_REPO_PATH    = $PDF_INJECTOR_FOLDER | Join-Path -ChildPath "repo"
$PDF_INJECTOR_PROJECT_PATH = $PDF_INJECTOR_FOLDER | Join-Path -ChildPath "repo" -AdditionalChildPath "src"

$pdfInjectorRepo = "rulasg/PdfInjector"

<#
.SYNOPSIS
    Install the PdfInjector tool for the module to use
.DESCRIPTION
    Clones the PdfInjector repository and builds the project to have the executable available
#>
function Install-PdfInjector{
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    # Check if already installed
    if (Test-PdfInjector){
        Write-Verbose "PdfInjector already available"
        return $true;
    }

    # Copy the repo
    $result = Copy-PdfInjector -RepoWithOwner $pdfInjectorRepo -Destination $PDF_INJECTOR_REPO_PATH
    if(! $result){
        Write-Error "Failed to copy PdfInjector"
        return $false
    }

    # Build the project
    $result = Build-PdfInjector -projectFolder $PDF_INJECTOR_PROJECT_PATH -outFolder $PDF_INJECTOR_BIN
    $result ? "PdfInjector installed" : "Failed to build PdfInjector" | Write-Verbose

    return Test-PdfInjector;
} Export-ModuleMember -Function Install-PdfInjector

<#
.SYNOPSIS
    Remove the PdfInjector tool from the module folder
#>
function Remove-PdfInjector{
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([bool])]
    param(
    )

    $folder = $PDF_INJECTOR_FOLDER

    if ($PDF_INJECTOR_FOLDER | Test-Path) {
        if ($PSCmdlet.ShouldProcess($PDF_INJECTOR_FOLDER, "Remove folder")) {
            Remove-Item -Path $Folder -Recurse -Force
            $ret = ! ($Folder | Test-Path)
        } else {
            $ret = $true
        }
    }

    return $ret
} Export-ModuleMember -Function Remove-PdfInjector


function Test-PdfInjector{
    [CmdletBinding()]
    param()

    return $PDF_INJECTOR_EXE | Test-Path
} Export-ModuleMember -Function Test-PdfInjector

<#
.SYNOPSIS
    Copy the PdfInjector repository to the LOCAL folder
#>
function Copy-PdfInjector{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Repo to clone
        [Parameter(Mandatory,Position=0)][string]$RepoWithOwner,
        #folder to copy the repo
        [Parameter(Mandatory,Position=1)][string]$Destination
    )

    $pdfInjectorGit = $Destination | Join-Path -ChildPath ".git"

    if($pdfInjectorGit | Test-Path){
        return $true
    }

    if ($PSCmdlet.ShouldProcess($pdfInjectorRepo, "Clone repo to $Destination")) {
        $params = @{
            repowithowner = $pdfInjectorRepo
            folder = $Destination
        }

        $result = Invoke-MyCommand -Command RepoClone -Parameters $params
        $result | Write-Verbose

        $ret = $pdfInjectorGit | Test-Path

    } else {
        $ret = $true
    }

    return $ret
    
} Export-ModuleMember -Function Copy-PdfInjector

<#
.SYNOPSIS
    Build the PdfInjector project
#>
function Build-PdfInjector{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        #folder to build
        [Parameter(Mandatory,Position=0)][string]$ProjectFolder,
        #folder to output
        [Parameter(Mandatory,Position=1)][string]$OutFolder
    )

    $params = @{
        projectFolder = $ProjectFolder
        outFolder = $OutFolder
    }

    if ($PSCmdlet.ShouldProcess("PdfInject", "Build")) {
        $output = Invoke-MyCommand -Command DotnetBuild -Parameters $params
        $output | Write-Verbose
        return Test-PdfInjector
    } else {
        return $true
    }


}