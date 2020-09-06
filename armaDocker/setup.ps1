#######INIT MESSAGES##########

Write-Host "RPFramework container is launching..." -ForegroundColor "red"
if ($env:FAST_START -gt 0) {
    Write-Host "Keep in mind you have FAST_START enabled, `n
    please stop the container and disable it if you changed your password recently/ `n
    haven't logged in at least once in your steam account"
}
if ($env:VALIDATE_SERVER -gt 0) {
    Write-Host "Keep in mind you have VALIDATE_SERVER enabled, `n
    this means steamcmd will check on each docker run for the integrity of the arma server `n
    Disable it if you want faster startup"
}

function verifyCorrectAuthCode([string]$SteamUserName, [string]$SteamPassword, [string]$SteamCode) {
    if ([string]::IsNullOrEmpty($SteamCode)) { throw "ERR:Invalid auth code(null),insert the code in the email you received" }
    $job = Start-Job -ScriptBlock {
        Param($SteamUserName, $SteamPassword, $SteamCode)
        steamcmd +set_steam_guard_code $SteamCode +login $SteamUserName $SteamPassword +quit
    } -ArgumentList $SteamUserName, $SteamPassword, $SteamCode 
    Start-Sleep -Seconds 3     
    $grep1 = Receive-Job $job | Select-String -Pattern "Failed" -SimpleMatch
    if (-not [string]::IsNullOrEmpty($grep1)) { throw "ERR:Invalid auth code,insert the code in the email you received" }
}

function updateServer([string]$SteamUserName, [string]$SteamPassword) {
    if ($env:FAST_START -gt 0) {return}
    $validate = $env:VALIDATE_SERVER;
    Write-Host "Updating/Installing Server, validate: $validate" -ForegroundColor "blue"
    if ($validate -gt 0) {
        steamcmd +login $SteamUserName $SteamPassword +force_install_dir "/arma3" +app_update 233780 validate +quit 
    }
    else {
        Write-Host "Downloading/Validating latest arma3server build" -ForegroundColor "blue"
        steamcmd +login $SteamUserName $SteamPassword +force_install_dir "/arma3" +app_update 233780 +quit 
    }
}
function verifyCredentials([string]$SteamUN, [string]$SteamPWD) {
    if ([string]::IsNullOrEmpty($SteamUN) -or ([string]::IsNullOrEmpty($SteamPWD))) { throw "ERR:Provided password/username is null. Check envVars.env file" }
    $job = Start-Job -ScriptBlock {
        Param($SteamUN, $SteamPWD)
        steamcmd +login $SteamUN $SteamPWD +quit
    } -ArgumentList $SteamUN, $SteamPWD 
    Start-Sleep -Seconds 3     
    $grep = Receive-Job $job | Select-String -Pattern "Invalid Password" -SimpleMatch
    if  (-not [string]::IsNullOrEmpty($grep)) {
        throw "ERR:Invalid username/password combination,check envVars.env File"
    }
    else {
        Write-Host "Provided Credentials are correct" -ForegroundColor "green"
    }
}


[string] $SteamPassword = $env:STEAM_PASSWORD
[string] $SteamUserName = $env:STEAM_USER
$isRequired = $false;

#check if credentials provided
verifyCredentials $SteamUserName $SteamPassword

#check if steam_code is required
if ($env:FAST_START -lt 1) {
    Write-Host "Triggering steam guard code(if enabled), please wait"
    $job = Start-Job -ScriptBlock {
        Param($SteamUserName, $SteamPassword)
        steamcmd +login $SteamUserName $SteamPassword +quit
    } -ArgumentList $SteamUserName, $SteamPassword
    Start-Sleep -Seconds 5
    Stop-Job $job
    $grep = Receive-Job $job | Select-String -Pattern "set_steam_guard_code" -SimpleMatch
    $isRequired = -not [string]::IsNullOrEmpty($grep)
    Write-Host "Steam guard code required: $isRequired"
}

if ($isRequired) {
    verifyCorrectAuthCode $SteamUserName $SteamPassword $env:STEAM_GUARD_CODE
}
updateServer $SteamUserName $SteamPassword

#Mysql query
Out-File -FilePath "/configFiles/setupDB.sh" -InputObject $env:MYSQL_RPF_COMMAND
$mysqlUsr = "";
$mysqlPwd = "";
if ( [string]::IsNullOrEmpty($env:MYSQL_USER) -or [string]::IsNullOrEmpty($env:MYSQL_PASSWORD)) {
    $mysqlUsr = "root"
    $mysqlPwd = $env:MYSQL_ROOT_PASSWORD
}
else {
    $mysqlUsr = $env:MYSQL_USER
    $mysqlPwd = $env:MYSQL_PASSWORD
}

Write-Host "Verifying database is set up" -ForegroundColor "blue"
Start-Job -ScriptBlock {
    Param($mysqlUsr, $mysqlPwd)
    sh /configFiles/setupDB.sh $mysqlUsr $mysqlPwd
} -ArgumentList $mysqlUsr, $mysqlPwd

Set-Location /arma3

Write-Host "Launching Arma Server" -ForegroundColor "green"
Out-File -FilePath "/arma3/start.sh" -InputObject $env:ARMA3_LAUNCH_COMMAND
sh /arma3/start.sh