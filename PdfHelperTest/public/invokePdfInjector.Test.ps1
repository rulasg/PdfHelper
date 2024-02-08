# Variables
$local = $PSScriptRoot
$root = $local | split-path -Parent | split-path -Parent 
$PDF_TEMPLATE =  $root | Join-Path -ChildPath 'pdfInjector' -AdditionalChildPath 'repo','src','PdfInjectorTest','Pdftemplate.pdf' 

function PdfHelperTest_InvokePdfInjector_Default_Success{

    Install-PdfInjector

    $pdfOutFile = './result_V1.pdf'

    $param = @{
        StampName = "Default"
        PdfTemplate = $PDF_TEMPLATE
        PdfOutput = $pdfOutFile
        StudentName = "Student Name"
        StudentHandle = "studentHandle"
        StudentCompany = "studentCompany"
        TrainerName = "trainerName"
        TrainerHandle = "trainerHandle"
        TrainerCompany = "trainerCompany"
        CourseName = "courseName"
        CourseDate = "courseDate"
        Id = "1234567890"
    }

    $result = Invoke-PdfInjector @param

    Assert-IsNotNull -Object $result
    Assert-AreEqual -Expected $pdfOutFile -Presented $result
    Assert-ItemExist -Path $result

}

function PdfHelperTest_InvokePdfInjector_V1_Success{

    Install-PdfInjector

    $pdfOutFile = './result_V1.pdf'

    $param = @{
        StampName = "solidify_training_v1"
        PdfTemplate = $PDF_TEMPLATE
        PdfOutput = $pdfOutFile
        StudentName = "Student Name"
        StudentHandle = "studentHandle"
        StudentCompany = "studentCompany"
        TrainerName = "trainerName"
        TrainerHandle = "trainerHandle"
        TrainerCompany = "trainerCompany"
        CourseName = "courseName"
        CourseDate = "courseDate"
        Id = "1234567890"
    }

    $result = Invoke-PdfInjector @param

    Assert-IsNotNull -Object $result
    Assert-AreEqual -Expected $pdfOutFile -Presented $result
    Assert-ItemExist -Path $result
}

function PdfHelperTest_InvokePdfInjector_V1_Success_MultiUser{

    $pdf = @{
        StampName = "solidify_training_v1"
        PdfTemplate = $PDF_TEMPLATE

    }
    $training = @{
        TrainerName = "trainerName"
        TrainerHandle = "trainerHandle"
        TrainerCompany = "trainerCompany"
        CourseName = "courseName"
        CourseDate = "courseDate"
    }

    'MagnusTim','rulasg','raulgeu' | ForEach-Object {
        $id = [GUID]::NewGuid().ToString()
        $pdfOutFile = "{0}_{1}.pdf" -f $_,$id

        $user = @{
            PdfOutput = $pdfOutFile
            StudentHandle = $_
            StudentName = Get-UserName -handle $_
            StudentCompany = "Contoso"
            Id = [GUID]::NewGuid().ToString()
        }

        $result = Invoke-PdfInjector @pdf @training @user

        Assert-AreEqual -Expected $pdfOutFile -Presented $result
        Assert-ItemExist -Path $result
    }

}

function Get-UserName($handle){

    # $user = Invoke-MyCommandJson -Command 'gh api users/$handle'
    # $ret = $user.name

    switch ($handle) {
        rulasg { $ret = 'Raul Gonzalez'}
        raulgeu { $ret = 'Raul Dibildos'}
        magnustim { $ret = 'Magnus Timner'}
        Default {$ret = "Unknown User Name"}
    }
    
    return $ret
}

function PdfHelperTest_InvokePdfInjector_V2_Success{

    Install-PdfInjector

    $pdfOutFile = './result_V1.pdf'

    $param = @{
        StampName = "solidify_training_v1"
        PdfTemplate = $PDF_TEMPLATE
        PdfOutput = $pdfOutFile
        StudentName = "Student Name"
        StudentHandle = "studentHandle"
        StudentCompany = "studentCompany"
        TrainerName = "trainerName"
        TrainerHandle = "trainerHandle"
        TrainerCompany = "trainerCompany"
        CourseName = "courseName"
        CourseDate = "courseDate"
        Id = "1234567890"
    }

    $result = Invoke-PdfInjector @param

    Assert-IsNotNull -Object $result
    Assert-AreEqual -Expected $pdfOutFile -Presented $result
    Assert-ItemExist -Path $result
}

function PdfHelperTest_InvokePdfInjector_V2_Success_Missing_StudentHandle{

    Install-PdfInjector

    $pdfOutFile = './result_V1.pdf'

    $param = @{
        StampName = "solidify_training_v2"
        PdfTemplate = $PDF_TEMPLATE
        PdfOutput = $pdfOutFile
        StudentName = "Student Name"
        # StudentHandle = "studentHandle"
        StudentCompany = "studentCompany"
        TrainerName = "trainerName"
        TrainerHandle = "trainerHandle"
        TrainerCompany = "trainerCompany"
        CourseName = "courseName"
        CourseDate = "courseDate"
        Id = "1234567890"
    }

    $result = Invoke-PdfInjector @param

    Assert-IsNotNull -Object $result
    Assert-AreEqual -Expected $pdfOutFile -Presented $result
    Assert-ItemExist -Path $result
}

function PdfHelperTest_InvokePdfInjector_V2_Success_Missing_StudentCompany{

    Install-PdfInjector

    $pdfOutFile = './result_V1.pdf'

    $param = @{
        StampName = "solidify_training_v2"
        PdfTemplate = $PDF_TEMPLATE
        PdfOutput = $pdfOutFile
        StudentName = "Student Name"
        StudentHandle = "studentHandle"
        # StudentCompany = "studentCompany"
        TrainerName = "trainerName"
        TrainerHandle = "trainerHandle"
        TrainerCompany = "trainerCompany"
        CourseName = "courseName"
        CourseDate = "courseDate"
        Id = "1234567890"
    }

    $result = Invoke-PdfInjector @param

    Assert-IsNotNull -Object $result
    Assert-AreEqual -Expected $pdfOutFile -Presented $result
    Assert-ItemExist -Path $result
}

function PdfHelperTest_InvokePdfInjector_V2_Success_Missing_StudentCompany_StudentHAndle{

    Install-PdfInjector

    $pdfOutFile = './result_V1.pdf'

    $param = @{
        StampName = "solidify_training_v2"
        PdfTemplate = $PDF_TEMPLATE
        PdfOutput = $pdfOutFile
        StudentName = "Student Name"
        # StudentHandle = "studentHandle"
        # StudentCompany = "studentCompany"
        TrainerName = "trainerName"
        TrainerHandle = "trainerHandle"
        TrainerCompany = "trainerCompany"
        CourseName = "courseName"
        CourseDate = "courseDate"
        Id = "1234567890"
    }

    $result = Invoke-PdfInjector @param

    Assert-IsNotNull -Object $result
    Assert-AreEqual -Expected $pdfOutFile -Presented $result
    Assert-ItemExist -Path $result
}