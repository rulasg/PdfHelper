function PdfHelperTest_InstallPdfInjector_Success{

    # To avoid the building and installing of the pdfInjector, we skip the test
    # This will be tested on the Calls to the tool.
    Assert-SkipTest

    $local = $PSScriptRoot | Split-Path -Parent | Split-Path -Parent
    $pdfInjectorExe = $local | Join-Path -ChildPath "pdfInjector" -AdditionalChildPath "bin" ,"PdfInjector"
    
    # Arrange
    $result =  Remove-PdfInjector
    Assert-IsTrue -Condition $result
    Assert-ItemNotExist -Path $pdfInjectorExe
    
    # Action
    $result = Install-PdfInjector -Verbose
    
    # Assert
    Assert-IsTrue -Condition $result
    Assert-ItemExist -Path $pdfInjectorExe

    # Cleanup
    $result =  Remove-PdfInjector
    Assert-ItemNotExist -Path $pdfInjectorExe
    Assert-ItemNotExist -Path $pdfInjectorExe

 }