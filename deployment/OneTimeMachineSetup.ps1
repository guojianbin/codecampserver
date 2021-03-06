
$application ="Application"
$aPassword = "super l0ng and sc@ry 9@ssw06d"
$deployment = "Deployment"    
$dPassword = $aPassword 
$remoteDeployment = "build"
$rdPassword = $aPassword

$dbServerInstance = ".\SqlExpress"
$dbName = "CodeCampServer_dev"
$webAppPoolName = "WebApp"
    
if($args.length -eq 1){
    $aPassword = $args[0]
    $dPassword = $args[0]
    $rdPassword = $args[0]
}

function create-account ([string]$accountName,$password ) {    
   $hostname = hostname    
   $comp = [adsi] "WinNT://$hostname"
   $user = $comp.Create("User", $accountName)    
   $user.SetPassword($password)  
   $user.userflags = $user.userflags + 65536 # flag  
   $user.SetInfo()       
} 



function add-user-to-group ([string]$accountName,$group ) {      
   $hostname = hostname    
   $group = [ADSI]"WinNT://$hostname/$group,group"
   $group.add("WinNT://$hostname/$accountName")
} 

function create-sql-login($accountName,$instance,$admin) {
    $hostname = hostname
    $loginName = "$hostname\$accountName"
    invoke-sqlcmd -ServerInstance $instance -Query "CREATE LOGIN [$loginName] FROM WINDOWS"
    if($admin) {
        invoke-sqlcmd -ServerInstance $instance -Query "sp_addsrvrolemember '$loginName', 'sysadmin'"
    }
}

function create-database-login($accountName,$instance,$database){
    $hostname = hostname
    $loginName = "$hostname\$accountName"
    invoke-sqlcmd -ServerInstance $instance -Query "Use $database CREATE USER [$accountName] FOR LOGIN [$loginName]"    
    invoke-sqlcmd -ServerInstance $instance -Query "Use $database EXEC sp_addrolemember 'db_datareader', '$accountName'"
    invoke-sqlcmd -ServerInstance $instance -Query "Use $database EXEC sp_addrolemember 'db_datawriter', '$accountName'"
}


function set-deployment-service($accountName,$password)
{
    $hostname=hostname
    $svc=gwmi win32_service -filter "name='MsDepSvc'"
    $svc.change($null,$null,$null,$null,$null,$null,"$hostname\$accountName",$password,$null,$null,$null) | null
    & .\ntrights.exe +r SeServiceLogonRight -u "$hostname\$accountName" 
    
    set-service msdepsvc -StartupType Automatic
    start-service msdepsvc
}

function create-user-account($accountName,$password)
{
    create-account -accountName $accountName  -password $password
    add-user-to-group -accountName  $accountName  -group "Users"
}

function create-admin-account($accountName,$password)
{
    create-user-account -accountName $accountName  -password $password
    add-user-to-group -accountName  $accountName  -group "Administrators"
}

function create-webserver(){
    Import-Module WebAdministration
    create-user-account -accountName $application  -password $aPassword
    create-admin-account -accountName  $deployment  -password  $dPassword
    create-admin-account -accountName  $remoteDeployment -password  $rdPassword
    create-app-pool  -accountName $application -password $aPassword -appPool $webAppPoolName
    set-deployment-service  -accountName $deployment  -password $dPassword 
}

function create-app-pool($accountName,$password,$appPool)
{    
    new-item IIS:\AppPools\$appPool    
    $demoPool = Get-Item IIS:\AppPools\$appPool
    $demoPool.processModel.userName = $accountName
    $demoPool.processModel.password = $password
    $demoPool.processModel.identityType = 3
    $demoPool | Set-Item
}

function create-database-server(){
    Add-PSSnapin SqlServerCmdletSnapin100    
    create-user-account -accountName $application  -password $aPassword
    create-admin-account -accountName  $deployment  -password  $dPassword
    create-sql-login -accountName $application  -instance $dbServerInstance
    create-database-login -accountName $application  -instance $dbServerInstance -database $dbName
    create-sql-login -accountName $deployment  -instance $dbServerInstance -admin $true
}

create-webserver
create-database-server
