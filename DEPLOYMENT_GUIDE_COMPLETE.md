# 🚀 Complete Deployment Guide for Any Linux Server

This guide covers deploying the HR Assistant Suite on any Linux server from scratch.

---

## 📋 **Prerequisites**

- Linux server (Ubuntu/Debian/CentOS/RHEL)
- SSH access with sudo privileges
- Internet connection
- Your API keys ready (Groq, Pinecone, Gemini)

---

## 🔧 **Step-by-Step Deployment**

### **Step 1: Prerequisites Check**

```bash
# Check Python 3.10 is installed
python3.10 --version

# If not installed (Ubuntu/Debian):
sudo apt update
sudo apt install python3.10 python3.10-venv python3.10-dev git -y

# For CentOS/RHEL:
# sudo yum install python3.10 python3.10-devel git -y

# Check Git is installed
git --version
```

---

### **Step 2: Clone Repository**

```bash
# Navigate to home directory
cd ~

# Clone your repository
git clone https://github.com/riteshnaikm/aitools3.git

# Enter project directory
cd aitools3

# Verify files
ls -la

# You should see:
# - app.py
# - run_production.py
# - requirements.txt
# - HR_docs/
# - templates/
# - static/
```

---

### **Step 3: Create Virtual Environment**

```bash
# Create virtual environment with Python 3.10
python3.10 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Your prompt should now show (venv)

# Verify Python version (should show 3.10.x)
python --version
```

---

### **Step 4: Install Dependencies**

```bash
# Upgrade pip
pip install --upgrade pip

# Install all requirements (takes 5-10 minutes)
pip install -r requirements.txt

# You'll see packages being installed:
# - torch (large, ~2GB)
# - transformers
# - langchain components
# - flask, hypercorn
# - sentence-transformers
# - pdfplumber
# - etc.

# Wait for completion...
```

**Expected output:**
```
Successfully installed langchain-x.x.x torch-x.x.x transformers-x.x.x ...
```

---

### **Step 5: Create .env File**

```bash
# Create .env file
nano .env
```

**Add these three lines (replace with your actual keys):**

```env
GROQ_API_KEY=your_groq_api_key_here
PINECONE_API_KEY=your_pinecone_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
```

**Save and exit:**
- Press `Ctrl+X`
- Press `Y` (yes)
- Press `Enter` (confirm)

**Verify .env was created:**
```bash
cat .env
# Should show your three API keys
```

---

### **Step 6: Verify HR_docs Folder**

```bash
# Check HR policy PDFs exist
ls HR_docs/ | wc -l
# Should show: 17

# List all PDF files
ls HR_docs/

# Expected files:
# - Leave Policy.pdf
# - Code of Conduct.pdf
# - POSH Policy.pdf
# - etc. (17 total)
```

---

### **Step 7: Create Uploads Folder**

```bash
# Create uploads directory
mkdir -p uploads

# Set permissions
chmod 755 uploads

# Verify
ls -ld uploads
```

---

### **Step 8: Test Run (Optional but Recommended)**

```bash
# Test if application runs manually
python run_production.py
```

**Expected output:**
```
🔧 Initializing Pinecone...
🔍 Building BM25 index...
📚 Found 17 PDF files in HR_docs folder:
   - Leave Policy.pdf
   - Code of Conduct.pdf
   ...
🤖 Setting up LLM and QA chain...
🚀 Starting HR Assistant Suite (Production Mode)...
Running on http://0.0.0.0:5000
```

**If you see this, it works!** Press `Ctrl+C` to stop.

**If you see errors:**
- Check .env file has correct API keys
- Check all dependencies installed
- Check HR_docs folder has PDFs

---

### **Step 9: Create Systemd Service**

**First, get your username:**
```bash
whoami
```

**Note this username** (e.g., "ubuntu", "people_logic", "ec2-user", etc.)

**Create service file:**
```bash
sudo nano /etc/systemd/system/hr-assistant.service
```

**Paste this configuration** (replace `YOUR_USERNAME` with your actual username):

```ini
[Unit]
Description=HR Assistant Suite
After=network.target

[Service]
Type=simple
User=YOUR_USERNAME
WorkingDirectory=/home/YOUR_USERNAME/aitools3
Environment="PATH=/home/YOUR_USERNAME/aitools3/venv/bin"
ExecStart=/home/YOUR_USERNAME/aitools3/venv/bin/python run_production.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Example with username "ubuntu":**
```ini
[Unit]
Description=HR Assistant Suite
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/aitools3
Environment="PATH=/home/ubuntu/aitools3/venv/bin"
ExecStart=/home/ubuntu/aitools3/venv/bin/python run_production.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

**Save and exit:**
- Press `Ctrl+X`
- Press `Y`
- Press `Enter`

**Verify service file:**
```bash
cat /etc/systemd/system/hr-assistant.service
```

---

### **Step 10: Start Service**

```bash
# Reload systemd to recognize new service
sudo systemctl daemon-reload

# Enable service to start on boot
sudo systemctl enable hr-assistant

# Start the service
sudo systemctl start hr-assistant

# Check status (should show "active (running)" in green)
sudo systemctl status hr-assistant
```

**Expected output:**
```
● hr-assistant.service - HR Assistant Suite
     Loaded: loaded (/etc/systemd/system/hr-assistant.service; enabled)
     Active: active (running) since Thu 2025-10-30 10:50:13 UTC; 5s ago
   Main PID: 12345 (python)
      Tasks: 24
     Memory: 1.2G
     CGroup: /system.slice/hr-assistant.service
             └─12345 /home/ubuntu/aitools3/venv/bin/python run_production.py
```

✅ **Look for "active (running)" in green text**

---

### **Step 11: View Logs**

```bash
# View live logs
sudo journalctl -u hr-assistant -f
```

**Expected output:**
```
Oct 30 10:50:13 server hr-assistant[12345]: 🔧 Initializing Pinecone...
Oct 30 10:50:15 server hr-assistant[12345]: 🔍 Building BM25 index...
Oct 30 10:50:17 server hr-assistant[12345]: 📚 Found 17 PDF files in HR_docs folder
Oct 30 10:50:20 server hr-assistant[12345]: 🤖 Setting up LLM and QA chain...
Oct 30 10:50:25 server hr-assistant[12345]: 🚀 Starting HR Assistant Suite (Production Mode)...
Oct 30 10:50:26 server hr-assistant[12345]: Running on http://0.0.0.0:5000
```

**Press `Ctrl+C` to exit log view**

---

### **Step 12: Get Server IP Address**

```bash
# Get server IP (method 1)
hostname -I | awk '{print $1}'

# Get server IP (method 2)
ip addr show | grep "inet " | grep -v 127.0.0.1

# Get public IP (if on cloud)
curl ifconfig.me
```

**Note this IP address** (e.g., 192.168.1.15 or 54.123.45.67)

---

### **Step 13: Check Port Status**

```bash
# Verify port 5000 is listening
sudo lsof -i :5000

# Or
sudo netstat -tulpn | grep 5000

# Should show python process
```

---

### **Step 14: Access Application**

**Open your browser and visit:**

```
http://YOUR_SERVER_IP:5000
```

**Examples:**
- Local network: `http://192.168.1.15:5000`
- Public cloud: `http://54.123.45.67:5000`
- With domain: `http://your-domain.com:5000`

**You should see:**
- ✅ Info Buddy (HR Assistant)
- ✅ Match Maker (Resume Evaluator)
- ✅ History page
- ❌ Dashboard and Feedback History (hidden from navigation)

**Test key features:**
1. Ask a question in HR Assistant
2. Upload a resume in Match Maker
3. Generate a Recruiter Handbook
4. Check History page

---

## 🔥 **Quick Copy-Paste Block** (All Commands)

```bash
# 1. Navigate and clone
cd ~
git clone https://github.com/riteshnaikm/aitools3.git
cd aitools3

# 2. Setup Python environment
python3.10 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# 3. Create .env (then add your API keys manually)
nano .env

# Add these lines:
# GROQ_API_KEY=your_key
# PINECONE_API_KEY=your_key
# GEMINI_API_KEY=your_key
# Save: Ctrl+X, Y, Enter

# 4. Verify folders
ls HR_docs/
mkdir -p uploads

# 5. Test run (optional)
python run_production.py
# Press Ctrl+C after verifying it works

# 6. Get your username for service file
whoami

# 7. Create systemd service
sudo nano /etc/systemd/system/hr-assistant.service
# Paste config from Step 9 (replace YOUR_USERNAME)
# Save: Ctrl+X, Y, Enter

# 8. Start service
sudo systemctl daemon-reload
sudo systemctl enable hr-assistant
sudo systemctl start hr-assistant
sudo systemctl status hr-assistant

# 9. View logs
sudo journalctl -u hr-assistant -f
# Press Ctrl+C to exit

# 10. Get server IP and access in browser
hostname -I | awk '{print $1}'
# Visit: http://YOUR_IP:5000
```

---

## 🛠️ **Service Management Commands**

### **Basic Commands**

```bash
# Start service
sudo systemctl start hr-assistant

# Stop service
sudo systemctl stop hr-assistant

# Restart service
sudo systemctl restart hr-assistant

# Check status
sudo systemctl status hr-assistant

# Enable auto-start on boot
sudo systemctl enable hr-assistant

# Disable auto-start on boot
sudo systemctl disable hr-assistant
```

### **Log Commands**

```bash
# View last 50 lines
sudo journalctl -u hr-assistant -n 50

# View last 100 lines
sudo journalctl -u hr-assistant -n 100

# View live logs (follow)
sudo journalctl -u hr-assistant -f

# View logs with timestamps
sudo journalctl -u hr-assistant -n 50 --no-pager

# View logs from today
sudo journalctl -u hr-assistant --since today

# View logs from specific time
sudo journalctl -u hr-assistant --since "2025-10-30 10:00:00"
```

### **Debugging Commands**

```bash
# Check if service is enabled
systemctl is-enabled hr-assistant

# Check if service is active
systemctl is-active hr-assistant

# View service configuration
systemctl cat hr-assistant

# Check for failed services
systemctl --failed
```

---

## 🌐 **Optional: Internet Access Configuration**

### **Option A: Using Nginx Reverse Proxy** (Recommended)

**Benefits:**
- Access without specifying port (:5000)
- Can add SSL/HTTPS easily
- Better security
- Can add custom domain

**Install Nginx:**
```bash
sudo apt update
sudo apt install nginx -y
```

**Create Nginx configuration:**
```bash
sudo nano /etc/nginx/sites-available/hr-assistant
```

**Paste this configuration:**
```nginx
server {
    listen 80;
    server_name your-domain.com;  # Replace with your domain or IP

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeouts for large file uploads
        proxy_connect_timeout 600;
        proxy_send_timeout 600;
        proxy_read_timeout 600;
        send_timeout 600;
        
        # File upload size
        client_max_body_size 10M;
    }
}
```

**Enable and start:**
```bash
# Enable site
sudo ln -s /etc/nginx/sites-available/hr-assistant /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# If test passes, restart Nginx
sudo systemctl restart nginx

# Check Nginx status
sudo systemctl status nginx
```

**Now access via:**
- `http://your-domain.com` (no port needed!)

---

### **Option B: Direct Port Access (Firewall Configuration)**

**Ubuntu/Debian (UFW):**
```bash
# Check firewall status
sudo ufw status

# Allow port 5000
sudo ufw allow 5000/tcp

# Verify
sudo ufw status
```

**CentOS/RHEL (firewalld):**
```bash
# Check firewall status
sudo firewall-cmd --state

# Allow port 5000
sudo firewall-cmd --permanent --add-port=5000/tcp

# Reload firewall
sudo firewall-cmd --reload

# Verify
sudo firewall-cmd --list-ports
```

**AWS EC2 / Cloud Provider:**
- Add inbound rule in Security Group
- Allow TCP port 5000 from 0.0.0.0/0 (or specific IPs)

---

### **Option C: SSL/HTTPS with Let's Encrypt** (Production Recommended)

**Prerequisites:**
- Domain name pointing to your server
- Nginx installed (Option A above)

**Install Certbot:**
```bash
# Ubuntu/Debian
sudo apt install certbot python3-certbot-nginx -y

# CentOS/RHEL
sudo yum install certbot python3-certbot-nginx -y
```

**Get SSL certificate:**
```bash
# Replace with your actual domain
sudo certbot --nginx -d your-domain.com
```

**Follow the prompts:**
- Enter email address
- Agree to terms
- Choose to redirect HTTP to HTTPS (recommended)

**Auto-renewal test:**
```bash
sudo certbot renew --dry-run
```

**Now access via:**
- `https://your-domain.com` (secure!)

---

## 🚨 **Troubleshooting Guide**

### **Issue 1: Service Won't Start**

**Check logs:**
```bash
sudo journalctl -u hr-assistant -n 50 --no-pager
```

**Common causes:**
- ❌ Wrong paths in service file
- ❌ Missing .env file
- ❌ Wrong API keys
- ❌ Python not in venv

**Solutions:**
```bash
# Verify service file paths
cat /etc/systemd/system/hr-assistant.service

# Check .env exists
ls -la ~/aitools3/.env
cat ~/aitools3/.env

# Check Python path
ls ~/aitools3/venv/bin/python

# Test manual run
cd ~/aitools3
source venv/bin/activate
python run_production.py
```

---

### **Issue 2: Port 5000 Already in Use**

**Find what's using port 5000:**
```bash
sudo lsof -i :5000
```

**Output will show:**
```
COMMAND   PID     USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
python  12345  ubuntu    3u  IPv4  54321      0t0  TCP *:5000 (LISTEN)
```

**Kill the process:**
```bash
# Replace 12345 with actual PID
sudo kill -9 12345

# Or stop the service
sudo systemctl stop hr-assistant
```

---

### **Issue 3: Permission Errors**

**Fix ownership:**
```bash
# Replace 'ubuntu' with your username
sudo chown -R ubuntu:ubuntu ~/aitools3

# Fix permissions
chmod -R 755 ~/aitools3
chmod 644 ~/aitools3/.env
```

---

### **Issue 4: Dependencies Installation Failed**

**Common issues:**
- Not enough disk space
- Missing system libraries
- Python version mismatch

**Solutions:**
```bash
# Check disk space
df -h

# Install system dependencies (Ubuntu/Debian)
sudo apt install build-essential python3.10-dev libssl-dev libffi-dev -y

# Retry installation
pip install -r requirements.txt --upgrade
```

---

### **Issue 5: Can't Access from Browser**

**Checklist:**
```bash
# 1. Is service running?
sudo systemctl status hr-assistant

# 2. Is port listening?
sudo lsof -i :5000

# 3. Is firewall blocking?
sudo ufw status
# or
sudo firewall-cmd --list-ports

# 4. Check server IP
hostname -I

# 5. Try from server itself
curl http://localhost:5000
```

---

### **Issue 6: Application Crashes/Restarts**

**View crash logs:**
```bash
sudo journalctl -u hr-assistant -n 200 --no-pager | grep -i error
```

**Common causes:**
- Out of memory
- Invalid API keys
- Missing HR_docs PDFs
- Database corruption

**Solutions:**
```bash
# Check memory usage
free -h

# Verify API keys work
cat .env

# Check HR docs
ls HR_docs/ | wc -l

# Delete and recreate database
rm combined_db.db
sudo systemctl restart hr-assistant
```

---

### **Issue 7: Pinecone/Groq API Errors**

**Check API keys:**
```bash
cat ~/aitools3/.env
```

**Test API keys:**
```bash
cd ~/aitools3
source venv/bin/activate
python -c "import os; from dotenv import load_dotenv; load_dotenv(); print('GROQ:', os.getenv('GROQ_API_KEY')[:20]); print('PINECONE:', os.getenv('PINECONE_API_KEY')[:20])"
```

**Should show first 20 chars of each key**

---

## 📊 **Performance Optimization**

### **Increase Workers (for high traffic)**

Edit service file:
```bash
sudo nano /etc/systemd/system/hr-assistant.service
```

Modify run command to:
```ini
ExecStart=/home/ubuntu/aitools3/venv/bin/python -c "import asyncio; from hypercorn.config import Config; from hypercorn.asyncio import serve; from app import asgi_app; config = Config(); config.bind = ['0.0.0.0:5000']; config.workers = 4; asyncio.run(serve(asgi_app, config))"
```

**Or create a custom production script:**
```bash
nano ~/aitools3/run_production_optimized.py
```

Paste:
```python
import asyncio
import logging
from hypercorn.config import Config
from hypercorn.asyncio import serve
from app import asgi_app, initialize_pinecone, build_bm25_index, setup_llm_chain
import os

logging.basicConfig(level=logging.INFO)

async def main():
    try:
        initialize_pinecone()
        build_bm25_index("HR_docs/")
        setup_llm_chain()
        
        config = Config()
        config.bind = ["0.0.0.0:5000"]
        config.workers = 4  # Adjust based on CPU cores
        config.use_reloader = False
        config.accesslog = '-'
        config.errorlog = '-'
        
        await serve(asgi_app, config)
    except Exception as e:
        logging.error(f"Startup error: {str(e)}")
        raise

if __name__ == "__main__":
    asyncio.run(main())
```

---

## 🔄 **Updating the Application**

### **Method 1: Git Pull (Recommended)**

```bash
# Stop service
sudo systemctl stop hr-assistant

# Navigate to project
cd ~/aitools3

# Activate venv
source venv/bin/activate

# Backup database (optional)
cp combined_db.db combined_db.db.backup

# Pull latest changes
git pull origin main

# Update dependencies (if requirements changed)
pip install -r requirements.txt --upgrade

# Restart service
sudo systemctl start hr-assistant

# Check status
sudo systemctl status hr-assistant
```

---

### **Method 2: Fresh Clone**

```bash
# Stop service
sudo systemctl stop hr-assistant

# Backup current version
mv ~/aitools3 ~/aitools3_backup_$(date +%Y%m%d)

# Clone fresh
cd ~
git clone https://github.com/riteshnaikm/aitools3.git
cd aitools3

# Setup venv
python3.10 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Copy .env from backup
cp ~/aitools3_backup_*/. env .

# Start service
sudo systemctl start hr-assistant
```

---

## 📝 **Backup and Restore**

### **Backup Script**

```bash
# Create backup script
nano ~/backup-hr-assistant.sh
```

Paste:
```bash
#!/bin/bash
BACKUP_DIR=~/hr-assistant-backups
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Backup database
cp ~/aitools3/combined_db.db $BACKUP_DIR/db_$DATE.db

# Backup .env
cp ~/aitools3/.env $BACKUP_DIR/env_$DATE

# Backup uploads
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz -C ~/aitools3 uploads/

echo "Backup completed: $DATE"
ls -lh $BACKUP_DIR/
```

Make executable:
```bash
chmod +x ~/backup-hr-assistant.sh
```

Run backup:
```bash
~/backup-hr-assistant.sh
```

### **Schedule Automatic Backups**

```bash
# Edit crontab
crontab -e

# Add line for daily backup at 2 AM
0 2 * * * /home/ubuntu/backup-hr-assistant.sh
```

---

## ✅ **Deployment Checklist**

Use this checklist to verify your deployment:

- [ ] Python 3.10 installed and verified
- [ ] Repository cloned successfully
- [ ] Virtual environment created
- [ ] All dependencies installed without errors
- [ ] .env file created with all 3 API keys
- [ ] HR_docs folder contains 17 PDFs
- [ ] uploads folder created with correct permissions
- [ ] Manual test run successful (python run_production.py)
- [ ] Systemd service file created with correct username
- [ ] Service started and showing "active (running)"
- [ ] No errors in logs (journalctl)
- [ ] Port 5000 is listening
- [ ] Application accessible in browser
- [ ] HR Assistant feature working
- [ ] Resume Evaluator feature working
- [ ] Recruiter Handbook feature working
- [ ] History page accessible
- [ ] Feedback system functional
- [ ] Service enabled for auto-start on boot
- [ ] Firewall configured (if needed)
- [ ] Nginx configured (if using reverse proxy)
- [ ] SSL certificate installed (if using HTTPS)
- [ ] Backup script created

---

## 📞 **Support & Additional Resources**

### **Documentation Files:**
- `READY_TO_DEPLOY.md` - Quick deployment overview
- `DEPLOYMENT_CHECKLIST_360F1.md` - Detailed checklist
- `SERVER_DEPLOYMENT_SUMMARY.md` - Summary guide
- `verify_before_deploy.py` - Pre-deployment verification script

### **Useful Links:**
- Python 3.10: https://www.python.org/downloads/
- Systemd docs: https://systemd.io/
- Nginx docs: https://nginx.org/en/docs/
- Let's Encrypt: https://letsencrypt.org/

### **Common Commands Quick Reference:**

| Task | Command |
|------|---------|
| Start service | `sudo systemctl start hr-assistant` |
| Stop service | `sudo systemctl stop hr-assistant` |
| Restart service | `sudo systemctl restart hr-assistant` |
| Check status | `sudo systemctl status hr-assistant` |
| View logs | `sudo journalctl -u hr-assistant -f` |
| Check port | `sudo lsof -i :5000` |
| Get server IP | `hostname -I` |
| Test API | `curl http://localhost:5000` |

---

## 🎉 **Deployment Complete!**

Your HR Assistant Suite should now be:
- ✅ Running on your server
- ✅ Accessible via browser
- ✅ Auto-starting on boot
- ✅ Logging to systemd journal
- ✅ Ready for production use

**Access your application at:** `http://YOUR_SERVER_IP:5000`

**Questions or issues?** Check the Troubleshooting section above or review the logs:
```bash
sudo journalctl -u hr-assistant -n 100
```

---

**Last Updated:** October 30, 2025  
**Version:** 2.0 (Enhanced Feedback System)  
**Tested On:** Ubuntu 20.04/22.04, Debian 11/12, CentOS 8, RHEL 8

