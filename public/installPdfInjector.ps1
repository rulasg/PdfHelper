
Set-MyInvokeCommandAlias -Alias "RepoClone" -Command 'gh repo clone {repowithowner} {folder}'
Set-MyInvokeCommandAlias -Alias "DotnetBuild" -Command 'dotnet build {projectFolder} -c Release -o {outFolder}'

# local
# - pdfInjector
#     - bin
#         - PdfInjector.exe
#     - PdfInjectorRepo
#         - .git
#         - src
#             - PdfInjector

# Variables
$local = $PSScriptRoot
$modulePath = $local | split-path -Parent

$pdfInjectorFolder      = $modulePath | Join-Path -ChildPath "pdfInjector"
$pdfInjectorBin         = $pdfInjectorFolder | Join-Path -ChildPath "bin"
$pdfInjectorExe         = $pdfInjectorFolder | Join-Path -ChildPath "bin" -AdditionalChildPath "PdfInjector"
$pdfInjectorRepoPath    = $pdfInjectorFolder | Join-Path -ChildPath "repo"
$pdfInjectorProjectPath = $pdfInjectorFolder | Join-Path -ChildPath "repo" -AdditionalChildPath "src"

$pdfInjectorRepo = "rulasg/PdfInjector"

function Install-PdfInjector{
    [CmdletBinding()]
    param()

    # Check if already installed
    if (Test-PdfInjector){
        Write-Verbose "PdfInjector already available"
        return $true;
    }

    # Copy the repo
    $result = Copy-PdfInjector -RepoWithOwner $pdfInjectorRepo -Destination $pdfInjectorRepoPath
    if(! $result){
        Write-Error "Failed to copy PdfInjector"
        return $false
    }

    # Build the project
    $result = Build-PdfInjector -projectFolder $pdfInjectorProjectPath -outFolder $pdfInjectorBin
    $result ? "PdfInjector installed" : "Failed to build PdfInjector" | Write-Verbose

    return Test-PdfInjector;
} Export-ModuleMember -Function Install-PdfInjector

function Remove-PdfInjector{
    [CmdletBinding()]
    param()

    if ($pdfInjectorFolder | Test-Path) {
        Remove-Item -Path $pdfInjectorFolder -Recurse -Force
    }

    $ret = ! ($pdfInjectorFolder | Test-Path)

    return $ret
} Export-ModuleMember -Function Remove-PdfInjector


function Test-PdfInjector{
    [CmdletBinding()]
    param()

    return $pdfInjectorExe | Test-Path
} Export-ModuleMember -Function Test-PdfInjector

<#
.SYNOPSIS
    Copy the PdfInjector repository to the local folder
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