# Habilitar SSH en Windows 11 / Enable SSH on Windows 11

> [!WARNING]
> **Uso personal:** Este repositorio está pensado para mi uso personal e incluye **mi clave pública SSH** en [`habilita_ssh.ps1`](habilita_ssh.ps1). Si quieres utilizarlo en tus equipos, **no lo ejecutes directamente desde esta URL**; haz un *fork* o descarga el script y **cambia la variable `$pubKey` por tu propia clave pública** antes de ejecutarlo.
>
> **Personal use:** This repository is intended for my personal use and includes **my SSH public key** in [`habilita_ssh.ps1`](habilita_ssh.ps1). If you want to use it on your own machines, **do not run it directly from this URL**; fork or download the script and **replace the `$pubKey` variable with your own public key** before running it.

---

## Español

Script de PowerShell para instalar y configurar rápidamente **OpenSSH Server** en Windows 11.

### Qué hace [`habilita_ssh.ps1`](habilita_ssh.ps1)
1. Instala la característica `OpenSSH.Server` si no está instalada.
2. Arranca el servicio `sshd` y lo configura con inicio automático.
3. Verifica o crea la regla de firewall entrante para el puerto TCP `22` (`OpenSSH-Server-In-TCP`).
4. Configura PowerShell como shell por defecto para las sesiones SSH.
5. Añade la clave pública SSH (`$pubKey`) a:
   - `%ProgramData%\ssh\administrators_authorized_keys` (con los permisos NTFS requeridos para `Administradores` y `SYSTEM`).
   - `%USERPROFILE%\.ssh\authorized_keys`.

### Uso rápido (solo uso personal)
Abre **PowerShell como Administrador** y ejecuta:

```powershell
irm https://raw.githubusercontent.com/juananzgz/habilita_ssh_en_Win11/main/habilita_ssh.ps1 | iex
```

### Si no eres el autor
1. Descarga [`habilita_ssh.ps1`](habilita_ssh.ps1) o haz un *fork* del repositorio.
2. Sustituye el valor de `$pubKey` por tu propia clave pública SSH.
3. Ejecuta el script en una consola de **PowerShell como Administrador**.

---

## English

PowerShell script to quickly install and configure **OpenSSH Server** on Windows 11.

### What [`habilita_ssh.ps1`](habilita_ssh.ps1) does
1. Installs the `OpenSSH.Server` Windows capability if not already installed.
2. Starts the `sshd` service and sets its startup type to `Automatic`.
3. Verifies or creates the inbound firewall rule for TCP port `22` (`OpenSSH-Server-In-TCP`).
4. Sets PowerShell as the default shell for SSH sessions.
5. Adds the SSH public key (`$pubKey`) to:
   - `%ProgramData%\ssh\administrators_authorized_keys` (with the required NTFS permissions for `Administrators` and `SYSTEM`).
   - `%USERPROFILE%\.ssh\authorized_keys`.

### Quick usage (personal use only)
Open **PowerShell as Administrator** and run:

```powershell
irm https://raw.githubusercontent.com/juananzgz/habilita_ssh_en_Win11/main/habilita_ssh.ps1 | iex
```

### For other users
1. Download [`habilita_ssh.ps1`](habilita_ssh.ps1) or fork this repository.
2. Replace the value of `$pubKey` with your own SSH public key.
3. Run the script in an elevated **PowerShell (Administrator)** terminal.
