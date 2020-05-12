[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;

$username = Read-Host -Prompt 'Input your name. (ex Ola Nordmann)'
$email = Read-Host -Prompt 'Input your email-address (user@domain.com)'

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
choco install -y git
git config --global user.name $username

Install-Module -Force OpenSSHUtils
Start-Service ssh-agent
Start-Service sshd

ssh-keygen -t ed25519 -C $email
cat ~/.ssh/id_ed25519.pub | clip
Write-Host "The ssh Key has been copied to your clipboard. go to you gitlab, click you profile picture > Settings and navigate to SSH Keys on the leftmost menu. There you paste (CTRL-V) the key as told on the page"
