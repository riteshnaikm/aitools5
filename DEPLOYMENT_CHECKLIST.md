# HR Assistant Suite - Deployment Checklist
## Gateway GR 360 F1 (Ubuntu/Debian)

Use this checklist to ensure a smooth deployment process.

---

## 📦 Pre-Deployment

### On Your Local Machine (Windows)

- [ ] **Verify all API keys are ready**
  - [ ] Groq API Key
  - [ ] Pinecone API Key
  - [ ] Google Gemini API Key

- [ ] **Prepare HR Documents**
  - [ ] All PDF files are in `HR_docs/` folder
  - [ ] Files are not corrupted
  - [ ] Files have proper naming

- [ ] **Test application locally**
  - [ ] Run: `venv\Scripts\activate && python run.py`
  - [ ] Verify it starts without errors
  - [ ] Test basic functionality

- [ ] **Backup your database and uploads**
  - [ ] Copy `combined_db.db` to safe location
  - [ ] Copy `uploads/` folder contents

- [ ] **Server information ready**
  - [ ] Server IP address: ________________
  - [ ] SSH username: ________________
  - [ ] SSH password/key: ________________
  - [ ] Domain name (if any): ________________

---

## 🚀 Deployment Steps

### Step 1: Transfer Files to Server

- [ ] **Connect to server via SSH**
  ```bash
  ssh username@server_ip
  ```

- [ ] **Create application directory**
  ```bash
  mkdir -p ~/hr-assistant
  ```

- [ ] **Transfer files from Windows to Linux**
  
  **Option A: Using SCP** (from your Windows PowerShell)
  ```powershell
  scp -r "C:\Users\Ritesh\Desktop\Cursor 1\*" username@server_ip:~/hr-assistant/
  ```
  
  **Option B: Using SFTP client** (WinSCP, FileZilla)
  - Connect to server
  - Upload all files to `~/hr-assistant/`
  
- [ ] **Verify files transferred correctly**
  ```bash
  cd ~/hr-assistant
  ls -la
  ```

### Step 2: Run Automated Installation

- [ ] **Make installation script executable**
  ```bash
  chmod +x deploy_scripts/install.sh
  ```

- [ ] **Run installation script**
  ```bash
  bash deploy_scripts/install.sh
  ```

- [ ] **Wait for installation to complete** (5-10 minutes)

- [ ] **Note any errors or warnings**

### Step 3: Configure Environment

- [ ] **Edit .env file with actual API keys**
  ```bash
  nano .env
  ```
  
  Update these lines:
  ```
  GROQ_API_KEY=your_actual_groq_key
  PINECONE_API_KEY=your_actual_pinecone_key
  GEMINI_API_KEY=your_actual_gemini_key
  ```
  
  Save: `Ctrl+X`, then `Y`, then `Enter`

- [ ] **Verify .env file permissions**
  ```bash
  ls -la .env
  # Should show: -rw------- (600)
  ```

- [ ] **Verify HR documents are present**
  ```bash
  ls -la HR_docs/
  ```

### Step 4: Start the Service

- [ ] **Start HR Assistant service**
  ```bash
  sudo systemctl start hr-assistant
  ```

- [ ] **Check service status**
  ```bash
  sudo systemctl status hr-assistant
  ```
  
  Should show: `Active: active (running)`

- [ ] **View logs for any errors**
  ```bash
  sudo journalctl -u hr-assistant -n 50
  ```

- [ ] **Verify service will start on boot**
  ```bash
  sudo systemctl is-enabled hr-assistant
  # Should show: enabled
  ```

### Step 5: Configure Firewall

- [ ] **Check firewall status**
  ```bash
  sudo ufw status
  ```

- [ ] **Enable firewall if not already enabled**
  ```bash
  sudo ufw allow 22/tcp
  sudo ufw allow 5000/tcp
  sudo ufw enable
  ```

- [ ] **Verify rules are in place**
  ```bash
  sudo ufw status numbered
  ```

### Step 6: Test the Application

- [ ] **Test locally on server**
  ```bash
  curl http://localhost:5000
  ```
  
  Should return HTML content

- [ ] **Get server IP address**
  ```bash
  hostname -I
  ```
  
  IP Address: ________________

- [ ] **Test from your browser**
  - Open: `http://[SERVER_IP]:5000`
  - Page should load

- [ ] **Test key features**
  - [ ] HR Policy Assistant works
  - [ ] Resume Evaluator works
  - [ ] File upload works
  - [ ] Chat functionality works

---

## 🌐 Optional: Nginx Setup (Recommended)

- [ ] **Run Nginx setup script**
  ```bash
  bash deploy_scripts/nginx-setup.sh your_domain_or_ip
  ```

- [ ] **Verify Nginx is running**
  ```bash
  sudo systemctl status nginx
  ```

- [ ] **Test via Nginx**
  - Open: `http://your_domain_or_ip` (without :5000)
  - Page should load

- [ ] **Optional: Enable HTTPS**
  ```bash
  sudo apt install certbot python3-certbot-nginx -y
  sudo certbot --nginx -d your_domain.com
  ```

---

## 🔒 Security Hardening

- [ ] **Verify .env permissions**
  ```bash
  ls -la .env
  # Must be: -rw------- (600)
  ```

- [ ] **Check file ownership**
  ```bash
  ls -la ~/hr-assistant
  # All files should be owned by your user
  ```

- [ ] **Verify service runs as non-root**
  ```bash
  ps aux | grep run_production.py
  # Should show your username, not root
  ```

- [ ] **Configure SSH key-based authentication** (recommended)
  - Disable password authentication
  - Use SSH keys only

- [ ] **Set up fail2ban** (optional)
  ```bash
  sudo apt install fail2ban -y
  ```

- [ ] **Disable root SSH login** (optional but recommended)
  ```bash
  sudo nano /etc/ssh/sshd_config
  # Set: PermitRootLogin no
  sudo systemctl restart sshd
  ```

---

## 💾 Backup Configuration

- [ ] **Test backup script**
  ```bash
  ~/backup-hr-assistant.sh
  ls -la ~/backups/
  ```

- [ ] **Schedule automated daily backups**
  ```bash
  crontab -e
  ```
  
  Add this line:
  ```
  0 2 * * * /home/username/backup-hr-assistant.sh >> /home/username/backup.log 2>&1
  ```
  
  Replace `username` with your actual username

- [ ] **Verify cron job is scheduled**
  ```bash
  crontab -l
  ```

---

## 📊 Monitoring Setup

- [ ] **Test monitoring script**
  ```bash
  ~/monitor-hr-assistant.sh
  ```

- [ ] **Create desktop shortcut for monitoring** (optional)

- [ ] **Document monitoring schedule**
  - Who will monitor: ________________
  - How often: ________________
  - What to check: Status, logs, disk space, memory

---

## 📝 Documentation

- [ ] **Document server details**
  - Server IP: ________________
  - Domain (if any): ________________
  - SSH Port: ________________
  - Application Port: ________________

- [ ] **Save important passwords securely**
  - Server SSH password (use password manager)
  - API keys (keep backup in secure location)

- [ ] **Create runbook for common tasks**
  - How to restart service
  - How to view logs
  - How to update application
  - Emergency contacts

- [ ] **Share access with team members**
  - Who needs server access: ________________
  - Who needs application admin: ________________

---

## ✅ Post-Deployment Validation

- [ ] **Application accessible from internet**
  - URL: ________________
  - Response time: < 3 seconds

- [ ] **All features working**
  - [ ] HR Policy chat
  - [ ] Resume evaluation
  - [ ] File uploads
  - [ ] PDF generation
  - [ ] History viewing

- [ ] **Performance check**
  - [ ] CPU usage normal (< 50% idle)
  - [ ] Memory usage acceptable
  - [ ] Disk space sufficient (> 20% free)

- [ ] **Log rotation working**
  ```bash
  ls -lh hr_assistant.log
  ```

- [ ] **Service survives reboot**
  ```bash
  sudo reboot
  # Wait 2 minutes, then SSH back in
  sudo systemctl status hr-assistant
  # Should be active
  ```

---

## 🐛 Troubleshooting Tests

- [ ] **Service restart test**
  ```bash
  sudo systemctl restart hr-assistant
  sudo systemctl status hr-assistant
  ```

- [ ] **Log viewing test**
  ```bash
  sudo journalctl -u hr-assistant -f
  # Press Ctrl+C to exit
  ```

- [ ] **Resource usage test**
  ```bash
  htop
  # Check CPU, memory usage
  ```

- [ ] **Disk space test**
  ```bash
  df -h
  # Should have > 20% free
  ```

- [ ] **Port listening test**
  ```bash
  sudo netstat -tlnp | grep :5000
  # Should show python listening
  ```

---

## 📞 Emergency Contacts

- **Server Provider**: ________________
- **Developer Contact**: ________________
- **System Admin**: ________________

---

## 🔄 Maintenance Schedule

Set reminders for:

- [ ] **Daily**: Check service status (automated monitoring)
- [ ] **Weekly**: Review logs for errors
- [ ] **Monthly**: 
  - Update system packages
  - Review disk space
  - Test backups
  - Update Python dependencies
- [ ] **Quarterly**:
  - Security audit
  - Performance review
  - Backup restoration test

---

## 📌 Important Commands Reference

```bash
# Service Management
sudo systemctl start hr-assistant
sudo systemctl stop hr-assistant
sudo systemctl restart hr-assistant
sudo systemctl status hr-assistant

# View Logs
sudo journalctl -u hr-assistant -f
sudo journalctl -u hr-assistant -n 100
tail -f hr_assistant.log

# System Monitoring
htop
df -h
free -h
uptime

# Application Update
bash deploy_scripts/update.sh

# Backup
~/backup-hr-assistant.sh

# Check Status
~/monitor-hr-assistant.sh
```

---

## ✨ Deployment Complete!

Once all items are checked:

- [ ] **Take screenshot of working application**
- [ ] **Document deployment date**: ________________
- [ ] **Save this checklist** for future reference
- [ ] **Inform stakeholders** that system is live

---

**Deployment Date**: ________________  
**Deployed By**: ________________  
**Server**: Gateway GR 360 F1  
**OS**: Ubuntu/Debian  
**Application URL**: ________________

---

## 📚 Additional Resources

- Full deployment guide: `LINUX_DEPLOYMENT_GUIDE.md`
- Deployment scripts: `deploy_scripts/README.md`
- Application documentation: `docs/` folder
- Quick start guide: `QUICK_START_GUIDE.md`

---

**Notes**:
_Use this space for deployment-specific notes or issues encountered_

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

_______________________________________________________________________________

