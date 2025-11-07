# Windows to Linux Deployment Guide
## Transfer Your HR Assistant Suite from Windows to Linux Server

---

## 🎯 Overview

This guide helps you transfer your HR Assistant Suite from your Windows development machine to your Linux server (Gateway GR 360 F1).

**Current Location**: `C:\Users\Ritesh\Desktop\Cursor 1`  
**Target Server**: Gateway GR 360 F1 (Ubuntu/Debian)

---

## 📋 What You'll Need

- [ ] Windows machine with your application
- [ ] Linux server (Gateway GR 360 F1)
- [ ] Server IP address
- [ ] SSH credentials (username and password)
- [ ] SFTP/SCP client (or use built-in Windows tools)

---

## 🔄 File Transfer Methods

### Method 1: Using SCP (Command Line) ⭐ RECOMMENDED

SCP is built into Windows 10/11 PowerShell.

**Step 1**: Open PowerShell as Administrator

**Step 2**: Navigate to your project folder
```powershell
cd "C:\Users\Ritesh\Desktop\Cursor 1"
```

**Step 3**: Transfer files to server
```powershell
scp -r * username@server_ip:~/hr-assistant/
```

Replace:
- `username` with your Linux username
- `server_ip` with your server's IP address

**Example**:
```powershell
scp -r * ritesh@192.168.1.100:~/hr-assistant/
```

You'll be prompted for your password. Enter it and press Enter.

**Pros**:
- Fast and built-in
- No additional software needed
- Good for quick updates

**Cons**:
- Command line only
- Need to type correctly

---

### Method 2: Using WinSCP (GUI) ⭐ EASIEST

WinSCP is a free, user-friendly SFTP client for Windows.

**Step 1**: Download WinSCP
- Visit: https://winscp.net/
- Download and install

**Step 2**: Connect to Server
1. Open WinSCP
2. Click "New Session"
3. Enter connection details:
   - **File protocol**: SFTP
   - **Host name**: Your server IP
   - **Port number**: 22
   - **User name**: Your Linux username
   - **Password**: Your Linux password
4. Click "Login"

**Step 3**: Transfer Files
1. On the left side: Navigate to `C:\Users\Ritesh\Desktop\Cursor 1`
2. On the right side: Navigate to `/home/username/` and create `hr-assistant` folder
3. Select all files on the left
4. Drag and drop to the right side
5. Wait for transfer to complete

**Pros**:
- Visual, easy to use
- Can see transfer progress
- Can resume interrupted transfers
- Great for beginners

**Cons**:
- Need to download additional software

---

### Method 3: Using FileZilla (GUI)

FileZilla is another popular free SFTP client.

**Step 1**: Download FileZilla
- Visit: https://filezilla-project.org/
- Download "FileZilla Client"
- Install

**Step 2**: Connect to Server
1. Open FileZilla
2. Enter at the top:
   - **Host**: `sftp://your_server_ip`
   - **Username**: Your Linux username
   - **Password**: Your Linux password
   - **Port**: 22
3. Click "Quickconnect"

**Step 3**: Transfer Files
1. Left panel: Navigate to `C:\Users\Ritesh\Desktop\Cursor 1`
2. Right panel: Navigate to `/home/username/` and create `hr-assistant` folder
3. Select all files in left panel
4. Right-click → Upload
5. Wait for transfer to complete

**Pros**:
- Visual interface
- Free and open source
- Cross-platform

**Cons**:
- Need to download additional software

---

### Method 4: Using Git (Version Control)

If you're using Git, this is the cleanest method.

**On Windows**:
```powershell
cd "C:\Users\Ritesh\Desktop\Cursor 1"
git init
git add .
git commit -m "Initial commit"
git remote add origin your_git_repo_url
git push -u origin main
```

**On Linux Server**:
```bash
ssh username@server_ip
cd ~
git clone your_git_repo_url hr-assistant
cd hr-assistant
```

**Pros**:
- Version control
- Easy updates
- Professional workflow

**Cons**:
- Need Git repository (GitHub, GitLab, etc.)
- More setup required

---

## 📝 Step-by-Step: Using WinSCP (Detailed)

### 1. Install WinSCP

**Download**:
1. Open browser
2. Go to: https://winscp.net/eng/download.php
3. Click "Download WinSCP"
4. Run installer
5. Follow installation wizard (keep default settings)

### 2. First Time Setup

**Launch WinSCP**:
1. Click Start → WinSCP
2. You'll see "Login" dialog

**Configure Connection**:
```
File protocol: SFTP
Host name: [Your server IP, e.g., 192.168.1.100]
Port number: 22
User name: [Your Linux username]
Password: [Your Linux password]
```

**Save Session** (Optional but recommended):
1. Click "Save" button
2. Enter session name: "HR Assistant Server"
3. Save password: ✓ (if you trust your PC)
4. Click "OK"

### 3. Connect and Transfer

**Connect**:
1. Click "Login" button
2. If first time connecting, you'll see security warning
3. Click "Yes" to trust the server
4. You're now connected!

**Transfer Files**:
1. Left panel = Your Windows computer
2. Right panel = Linux server
3. Navigate on left to: `C:\Users\Ritesh\Desktop\Cursor 1`
4. Navigate on right to: `/home/username/`
5. Create folder on right: Right-click → New → Directory → Name it "hr-assistant"
6. Open the "hr-assistant" folder on right
7. Select all files/folders on left (Ctrl+A)
8. Drag to right panel
9. Transfer starts!

**Monitor Transfer**:
- Progress shown at bottom
- Don't close WinSCP during transfer
- Large files (venv folder) will take time

**When Complete**:
- You'll see "No ongoing operations" at bottom
- All files appear in right panel
- You can close WinSCP

---

## ⚠️ Important: What to Transfer

### ✅ Files to INCLUDE:

- `app.py` - Main application
- `run.py` - Development runner
- `run_production.py` - Production runner
- `requirements_for_server.txt` - Dependencies
- `.env` - Environment variables (will need to edit on server)
- `HR_docs/` folder - PDF documents
- `uploads/` folder - Uploaded files
- `combined_db.db` - Database
- `static/` folder - CSS, JS, images
- `templates/` folder - HTML templates
- `deploy_scripts/` folder - Installation scripts
- All `.md` documentation files
- `migrate_database.py` - If you have it

### ❌ Files to EXCLUDE (Optional - saves time):

You can skip these to save transfer time (they'll be recreated on server):

- `venv/` folder - Will be recreated on Linux
- `__pycache__/` folders - Python cache
- `.git/` folder - If you're not using Git on server

**To skip these in WinSCP**:
1. Before transferring, select files manually (don't use Ctrl+A)
2. Or transfer everything and delete these folders on server

---

## 🔍 Verify Transfer Success

After transfer completes, verify on your Linux server:

**SSH into server**:
```powershell
ssh username@server_ip
```

**Check files are present**:
```bash
cd ~/hr-assistant
ls -la
```

You should see all your files listed.

**Check file count** (approximate):
```bash
find . -type f | wc -l
```

Should be 100+ files (excluding venv).

**Check important files**:
```bash
ls -la app.py run_production.py .env HR_docs/
```

All should exist.

---

## 🚨 Common Transfer Issues

### Issue 1: Permission Denied

**Error**: `Permission denied (publickey,password)`

**Solution**:
- Double-check username and password
- Verify you can SSH: `ssh username@server_ip`
- Ensure SSH is enabled on server

### Issue 2: Connection Timeout

**Error**: `Connection timed out`

**Solution**:
- Verify server IP is correct
- Check if server is running
- Verify firewall allows port 22
- Try pinging server: `ping server_ip`

### Issue 3: Transfer Interrupts

**Error**: Transfer stops midway

**Solution**:
- Using WinSCP: Right-click → Resume
- Using SCP: Run command again (will skip existing files)
- Check internet connection
- Use wired connection if possible

### Issue 4: Files Not Found on Server

**Error**: Files transferred but not visible

**Solution**:
```bash
# Check where you are
pwd

# List all files including hidden
ls -la

# Search for a specific file
find ~ -name "app.py"
```

### Issue 5: .env File Not Transferred

**Issue**: .env might not transfer (hidden file)

**Solution**:
- In WinSCP: View → Show Hidden Files
- In FileZilla: Server → Force showing hidden files
- Or recreate .env on server manually

---

## 📊 Transfer Time Estimates

Typical transfer times (depends on internet speed):

| File/Folder | Size | Time (10 Mbps) | Time (100 Mbps) |
|-------------|------|----------------|-----------------|
| Application files (without venv) | ~50 MB | 40 seconds | 4 seconds |
| venv folder | ~2 GB | 27 minutes | 2.7 minutes |
| HR_docs PDFs | ~10 MB | 8 seconds | 1 second |
| uploads folder | Varies | Varies | Varies |
| **Total (with venv)** | ~2.1 GB | ~30 minutes | ~3 minutes |
| **Total (without venv)** | ~100 MB | ~1 minute | ~6 seconds |

**Recommendation**: Skip `venv` folder during transfer - it will be recreated on Linux server.

---

## ✅ Post-Transfer Checklist

After successful transfer:

- [ ] SSH into server: `ssh username@server_ip`
- [ ] Navigate to folder: `cd ~/hr-assistant`
- [ ] Verify files present: `ls -la`
- [ ] Check app.py exists: `ls -la app.py`
- [ ] Check deployment scripts exist: `ls -la deploy_scripts/`
- [ ] Ready to run installation script

**Next Step**: Follow `DEPLOYMENT_CHECKLIST.md`

---

## 🔄 Transferring Updates Later

When you make changes on Windows and need to update server:

**Method 1: Transfer specific files only**
```powershell
scp app.py username@server_ip:~/hr-assistant/
```

**Method 2: Using WinSCP**
1. Connect to server
2. Navigate to file on left
3. Drag updated file to right
4. Confirm overwrite

**After transferring updates**:
```bash
# On Linux server
sudo systemctl restart hr-assistant
```

---

## 💡 Pro Tips

1. **Save Session in WinSCP** - Don't enter credentials every time
2. **Use synchronized browsing** - WinSCP feature to keep both panels in sync
3. **Transfer compressed** - Zip files on Windows, transfer, unzip on Linux
4. **Use .gitignore patterns** - Skip unnecessary files
5. **Test SSH first** - Always verify SSH works before transferring files
6. **Backup before transfer** - Keep copy of your Windows files

---

## 🔒 Security Tips

1. **Don't transfer .env with real keys over unsecured networks**
2. **Use SSH keys instead of passwords** (more secure)
3. **Change default SSH port** on server (optional)
4. **Use VPN** if transferring over public WiFi
5. **Verify server identity** first time connecting

---

## 📞 Need Help?

If you encounter issues:

1. **SSH Issues**: Check server SSH service is running
2. **File Transfer Issues**: Try different method (WinSCP vs SCP)
3. **Permission Issues**: Ensure you have write access on server
4. **Network Issues**: Check firewall, internet connection

**Test basic connectivity**:
```powershell
# From Windows PowerShell
ping server_ip
ssh username@server_ip
```

---

## 🎯 Quick Reference Commands

**From Windows PowerShell**:
```powershell
# Transfer entire folder
scp -r "C:\Users\Ritesh\Desktop\Cursor 1" username@server_ip:~/hr-assistant/

# Transfer specific file
scp "C:\Users\Ritesh\Desktop\Cursor 1\app.py" username@server_ip:~/hr-assistant/

# Transfer multiple files
scp app.py run.py username@server_ip:~/hr-assistant/

# Check if SSH works
ssh username@server_ip

# If using key-based auth
scp -i path\to\key.pem -r * username@server_ip:~/hr-assistant/
```

**On Linux Server** (verify transfer):
```bash
# Go to application folder
cd ~/hr-assistant

# List files
ls -la

# Check disk space
df -h

# Count files
find . -type f | wc -l

# Search for specific file
find . -name "app.py"

# Check file size
du -sh ~/hr-assistant
```

---

## ✨ Success!

Once files are transferred:
- ✅ You have all application files on Linux server
- ✅ You're ready to run the installation script
- ✅ Follow DEPLOYMENT_CHECKLIST.md for next steps

**Good luck with your deployment! 🚀**

---

**Last Updated**: October 27, 2025  
**Source**: Windows 10/11  
**Target**: Gateway GR 360 F1 (Ubuntu/Debian)

