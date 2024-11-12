#!/usr/bin/pwsh -Command
try {
	Get-Command aria2c -ErrorAction Stop | Out-Null
	Write-Host -f Green "[✔] aria2c is installed."
	if ((!$args) -or (!$args.startswith("https://gofile.io/d/")) ){
	Write-Host "Need an URL`naria2c should be installed to work" -f red
	
	}

	else {
		$token=(irm -Method Post https://api.gofile.io/accounts).data.token

		$link = $args[0]

		$Id = $link.split("/")[4]

		$webToken = irm https://gofile.io/dist/js/alljs.js | grep "var fetchData" | %{$_.Split('"')[1]}


		#export
		$content = "https://api.gofile.io/contents/$Id" + "?wt=$webToken"

		
		$valid=(irm -Uri $content -Headers @{ "Authorization" = "Bearer $token" }).status
		
		#Request to Server and get JSON Response
		$b = irm -Headers @{ "Authorization" = "Bearer $token"} $content


		if($valid -ne "ok") {
			Write-Host "Files does not exist" -f red
		}

		else {

			$dl_link=$b.data.children.psobject.Properties.Value.link
			aria2c -x3 --header "Cookie: accountToken=$token" --header "Accept-Encoding: gzip, deflate, br" --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0" "$dl_link"
			
			}
	
	}

} catch {
	Write-Host "[x] install aria2c first!!" -f Red
}




