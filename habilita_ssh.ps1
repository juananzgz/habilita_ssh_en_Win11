# 1. Instalar OpenSSH Server (si no viene ya instalado)
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# 2. Arrancar el servicio y dejarlo en inicio automático
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# 3. Verificar o crear la regla de firewall para el puerto 22
if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

# 4. Establecer PowerShell como shell por defecto para sesiones SSH
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force

# 5. Añadir clave pública SSH a authorized_keys (administradores y usuario actual)
$pubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkMqYIthWQXeEA9EMZsB18UBWkOVPyEJDx2m7cVQPf4bIWFq6Ll0EcGM+XJuwt5kQnafFlw5RB65YeW+GujVQnxe/3wcyMvxGwWca+Dj1+TWhaqdIC7ne1Ra5bvFyUJqfrp7e3pqLw11oXk7b35FcfI0KJMbO65FGX7opCKTNvM3CNNRXUpcdapyyd4rIl1rnfMhGLHfPCfFU/etHh1hXeVE6v/W24zX8zVy7Ntry+jUr88/+uTKV+DFbwBBh4r18nLnqfJJ1Jzjm7oI6zwi8xVkKOr+TIags1YiF4+mHi6J2pUz6gL6AKqNdaK9jDGSP5Fra4/FoWXGNMPBa+12wTvJTq+JRzoHrYfetl3p0tXRr6qyAu15OKcZ40Qf9vAJGyKWiA+/zQR6OsMw5HoWHRnVSZFz7bIalinJxKBLKo3gBvyyaFNe4Rn6XgfXPQZ+twM/QpmUScH2qi9kt1ePlGy3J/dCwYL9TXmIqUPnD5fuLOwJXi2gHCTy3YyDGrj6CwUAv4caYSXdJydR/ZBrTMwIoJhtLrONKQk1DGFyXvEuwhDLDZ9LXPs0NkVfZb3AlK9V7+K1XgkzaCGlteE1DLEdhxy0guZWoaEDFIc8444h1UYmQa740Ljq6OHEXxlBNTwDeIibAynF9QHbmiTxtjZAd+i1M6Q9R02iuC8xjBew== id_rsa_agy"

# 5a. Para usuarios del grupo Administradores (ruta por defecto en OpenSSH para Windows)
$adminAuthKeys = "$env:ProgramData\ssh\administrators_authorized_keys"
$adminSshDir = Split-Path -Path $adminAuthKeys -Parent
if (!(Test-Path $adminSshDir)) {
    New-Item -ItemType Directory -Path $adminSshDir -Force | Out-Null
}
if (!(Test-Path $adminAuthKeys) -or !(Select-String -Path $adminAuthKeys -SimpleMatch $pubKey -Quiet)) {
    Add-Content -Path $adminAuthKeys -Value $pubKey -Encoding ascii
}
# Permisos obligatorios para administrators_authorized_keys (SIDs independientes del idioma: Administradores y SYSTEM)
icacls.exe $adminAuthKeys /inheritance:r /grant "*S-1-5-32-544:F" /grant "*S-1-5-18:F" | Out-Null

# 5b. Para el usuario actual (en caso de cuenta estándar o configuración personalizada)
$userSshDir = "$env:USERPROFILE\.ssh"
$userAuthKeys = "$userSshDir\authorized_keys"
if (!(Test-Path $userSshDir)) {
    New-Item -ItemType Directory -Path $userSshDir -Force | Out-Null
}
if (!(Test-Path $userAuthKeys) -or !(Select-String -Path $userAuthKeys -SimpleMatch $pubKey -Quiet)) {
    Add-Content -Path $userAuthKeys -Value $pubKey -Encoding ascii
}
