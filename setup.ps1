# TODO: Fancier cmdlet

$env:GOARM=6
$env:GOARCH="arm"
$env:GOOS="linux"

# First Run
# go tool dist install -v pkg/runtime
# go install -v -a std
# Install-Module Posh-SSH

if ($piCredentials -eq $null) {
  $piCredentials = Get-Credential -Message "Enter credentials for pi."
}

if ($piHostname -eq $null) {
  $piHostname = Read-Host -Prompt 'Enter the IP Address of the pi.'
}

New-SSHSession -ComputerName $piHostname -Credential $piCredentials
New-SFTPSession -ComputerName $piHostname -Credential $piCredentials

Write-Host "
# Now you can run the following
go build main.go
Set-SFTPFile 0 main /home/pi/ -Overwrite
`$pi = New-SSHShellStream -Index 0
`$pi.WriteLine(`"./main`")
`$pi.Read()
# `$pi.close() when you want to `"^c`"
"
