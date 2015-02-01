<#
Verb-Noun.ps1

    .SYNOPSIS
        A brief description of the function or script. 

    .DESCRIPTION
        A detailed description of the function or script. 

    .PARAMETER  <Parameter-Name>
        The description of a parameter. Add a .PARAMETER keyword for
        each parameter in the function or script syntax.

    .EXAMPLE
        A sample command that uses the function or script, optionally followed
        by sample output and a description. Repeat this keyword for each example.

#>
param
(
    [parameter(Mandatory = $true)][array]$A = $null,
    [string]$B
)
Write-Host "Your Script Goes here!"
