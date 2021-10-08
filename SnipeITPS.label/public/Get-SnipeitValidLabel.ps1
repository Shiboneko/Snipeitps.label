function Get-SnipeitValidLabel {


    (Get-ChildItem -Path $PSScriptRoot\..\Labels -File -Filter "*.prn").Name

}