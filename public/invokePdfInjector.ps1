
# Variables
$PDF_INJECTOR_PROJECT_FILE = $PDF_INJECTOR_FOLDER | Join-Path -ChildPath "repo" -AdditionalChildPath "src", "PdfInjector", "PdfInjector.csproj"

# Commands
Set-MyInvokeCommandAlias -Alias InvokePdfInjector -Command 'dotnet run --project {projectFile} -- {parameters}'

# --help | -h      | -?   : Prints this help message

# --stampname      | -s   : Stamp name (e.g. 'solidify_training_v1')
# --pdftemplate    | -t   : Path to the PDF template
# --pdfoutput      | -o   : Path to the output PDF file
# --studentname    | -sn  : Student name
# --studenthandle  | -sh  : Student handle
# --studentcompany | -sc  : Student company
# --trainername    | -tn  : Trainer name
# --trainerhandle  | -th  : Trainer handle
# --trainercompany | -tc  : Trainer company
# --coursename     | -cn  : Course name
# --coursedate     | -cd  : Course date
# --id             | -i   : Certificate identifier

function Invoke-PdfInjector {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateSet('Default','solidify_training_v1')][string]$StampName,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$PdfTemplate,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$PdfOutput,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$StudentName,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$StudentHandle,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$StudentCompany,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$TrainerName,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$TrainerHandle,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$TrainerCompany,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$CourseName,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$CourseDate,
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)][string]$Id
    )

    begin{
        # Install and Build PdfInjector
        if(! ( Test-PdfInjector )){
            if(!( Install-PdfInjector)){
                Write-Error "PdfInjector not found"
                return
            }
        }
    }

    process{

        # $parameters = "-s $StampName -t $PdfTemplate -o $PdfOutput -sn $StudentName -sh $StudentHandle -sc $StudentCompany -tn $TrainerName -th $TrainerHandle -tc $TrainerCompany -cn $CourseName -cd $CourseDate -i $Id"
        $parameters = '-s "{s}" -t "{t}" -o "{o}" -sn "{sn}" -sh "{sh}" -sc "{sc}" -tn "{tn}" -th "{th}" -tc "{tc}" -cn "{cn}" -cd "{cd}" -i "{i}"'
        $parameters = $parameters -replace "{s}", $StampName
        $parameters = $parameters -replace "{t}", $PdfTemplate
        $parameters = $parameters -replace "{o}", $PdfOutput
        $parameters = $parameters -replace "{sn}", $StudentName
        $parameters = $parameters -replace "{sh}", $StudentHandle
        $parameters = $parameters -replace "{sc}", $StudentCompany
        $parameters = $parameters -replace "{tn}", $TrainerName
        $parameters = $parameters -replace "{th}", $TrainerHandle
        $parameters = $parameters -replace "{tc}", $TrainerCompany
        $parameters = $parameters -replace "{cn}", $CourseName
        $parameters = $parameters -replace "{cd}", $CourseDate
        $parameters = $parameters -replace "{i}", $Id

        $param = @{
            parameters = $parameters
            projectFile = $PDF_INJECTOR_PROJECT_FILE
        }

        $result = Invoke-MyCommand -Command InvokePdfInjector -Parameters $param

        if($result.Contains('Name injected successfully into the PDF.')){
            $result | Write-Verbose
            $ret = $PdfOutput
        } else {
            Write-Error $result
            $ret = $null
        }

        return $ret
    }

} Export-ModuleMember -Function Invoke-PdfInjector

