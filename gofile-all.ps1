#!/usr/bin/pwsh -Command
$isAriaInstalled = Get-Command aria2c -ErrorAction SilentlyContinue
if ( -not $isAriaInstalled) {
    Write-Host "aria2c is not installed" -ForegroundColor Red
    exit 1
}

if ((!$args) -or (!$args.startswith("https://gofile.io/d/")) ){
    Write-Host "Need an URL`naria2c should be installed to work" -f red
    exit 1
}

$token=(irm -Method Post https://api.gofile.io/accounts).data.token

$link = $args[0]

$Id = $link.split("/")[4]

$webToken = "4fd6sg89d7s6"


#export
$content = "https://api.gofile.io/contents/$Id" + "?wt=$webToken"

$valid=(irm -Uri $content -Headers @{ "Authorization" = "Bearer $token" }).status

#Request to Server and get JSON Response
$b = irm -Headers @{ "Authorization" = "Bearer $token"} $content


if($valid -ne "ok") {
   Write-Host "Files does not exist" -f red
   exit 1
}

$dl_link=$b.data.children.psobject.Properties.Value.link | Out-File /tmp/temp.txt -Force
aria2c -x3 --header "Authorization: Bearer $token" -i /tmp/temp.txt -Z 
Remove-Item /tmp/temp.txt
