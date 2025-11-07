# Linux Deployment Guide for HR Assistant Suite
## Gateway GR 360 F1 (Ubuntu/Debian)

This guide will help you deploy the HR Assistant Suite on your Linux server.

---

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [System Setup](#system-setup)
3. [Application Installation](#application-installation)
4. [Configuration](#configuration)
5. [Running the Application](#running-the-application)
6. [Production Deployment with Systemd](#production-deployment-with-systemd)
7. [Optional: Nginx Reverse Proxy](#optional-nginx-reverse-proxy)
8. [Troubleshooting](#troubleshooting)

---

## 🔧 Prerequisites

- Gateway GR 360 F1 server with Ubuntu/Debian
- Root or sudo access
- Internet connection for downloading packages
- Domain name or server IP address
- API Keys for:
  - Groq API
  - Pinecone API
  - Google Gemini API

---

## 🖥️ System Setup

### 1. Update System Packages

```bash
sudo apt update
sudo apt upgrade -y
```

### 2. Install Python 3.10 and Dependencies

```bash
# Install Python 3.10
sudo apt install python3.10 python3.10-venv python3.10-dev -y

# Install pip
sudo apt install python3-pip -y

# Install system dependencies
sudo apt install build-essential libssl-dev libffi-dev -y

# Install git (if needed for version control)
sudo apt install git -y
```

### 3. Install Additional System Libraries

```bash
# For PDF processing
sudo apt install poppler-utils -y

# For better system monitoring
sudo apt install htop -y
```

---

## 📦 Application Installation

### 1. Transfer Application Files to Server

Option A: Using SCP (from your local machine)
```bash
scp -r "C:\Users\Ritesh\Desktop\Cursor 1" username@server_ip:/home/username/hr-assistant
```

Option B: Using Git (if you have a repository)
```bash
cd /home/username
git clone <your-repository-url> hr-assistant
```

Option C: Manual upload via SFTP client (FileZilla, WinSCP, etc.)

### 2. Navigate to Application Directory

```bash
cd /home/username/hr-assistant
# Or wherever you uploaded the files
```

### 3. Create Virtual Environment

```bash
python3.10 -m venv venv
```

### 4. Activate Virtual Environment

```bash
source venv/bin/activate
```

### 5. Install Python Dependencies

```bash
pip install --upgrade pip
pip install -r requirements_for_server.txt
```

### 6. Download NLTK Data

```bash
python3 -c "import nltk; nltk.download('punkt'); nltk.download('stopwords')"
```

---

## ⚙️ Configuration

### 1. Set Up Environment Variables

Create a `.env` file in the application root directory:

```bash
nano .env
```

Add the following content (replace with your actual API keys):

```env
GROQ_API_KEY=your_groq_api_key_here
PINECONE_API_KEY=your_pinecone_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
```

Save and exit (Ctrl+X, then Y, then Enter in nano).

### 2. Set Proper Permissions

```bash
# Make sure uploads directory exists and is writable
mkdir -p uploads
chmod 755 uploads

# Make sure HR_docs directory exists
mkdir -p HR_docs
chmod 755 HR_docs

# Set permissions for database
touch combined_db.db
chmod 644 combined_db.db
```

### 3. Update Server Binding in run.py

You need to modify `run.py` to bind to all network interfaces (0.0.0.0) instead of just localhost:

```bash
nano run.py
```

Change line 47 from:
```python
config.bind = ["localhost:5000"]
```

To:
```python
config.bind = ["0.0.0.0:5000"]
```

Also, for production, set use_reloader to False:
```python
config.use_reloader = False
```

Save and exit.

---

## 🚀 Running the Application

### Test Run (Foreground)

```bash
source venv/bin/activate
python3 run.py
```

You should see output indicating the server is starting. Access it via:
- `http://your_server_ip:5000`

Press `Ctrl+C` to stop.

---

## 🔄 Production Deployment with Systemd

For production, you want the app to run as a background service that starts automatically.

### 1. Create Systemd Service File

```bash
sudo nano /etc/systemd/system/hr-assistant.service
```

Add the following content (adjust paths as needed):

```ini
[Unit]
Description=HR Assistant Suite
After=network.target

[Service]
Type=simple
User=username
WorkingDirectory=/home/username/hr-assistant
Environment="PATH=/home/username/hr-assistant/venv/bin"
ExecStart=/home/username/hr-assistant/venv/bin/python3 /home/username/hr-assistant/run.py
Restart=always
RestartSec=10

# Logging
StandardOutput=journal
StandardError=journal
SyslogIdentifier=hr-assistant

[Install]
WantedBy=multi-user.target
```

**Important**: Replace `username` with your actual Linux username!

Save and exit.

### 2. Enable and Start the Service

```bash
# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable hr-assistant

# Start the service
sudo systemctl start hr-assistant

# Check status
sudo systemctl status hr-assistant
```

### 3. Service Management Commands

```bash
# Start the service
sudo systemctl start hr-assistant

# Stop the service
sudo systemctl stop hr-assistant

# Restart the service
sudo systemctl restart hr-assistant

# Check status
sudo systemctl status hr-assistant

# View logs
sudo journalctl -u hr-assistant -f

# View last 100 lines of logs
sudo journalctl -u hr-assistant -n 100
```

---

## 🌐 Optional: Nginx Reverse Proxy

For production, it's recommended to use Nginx as a reverse proxy for better security and performance.

### 1. Install Nginx

```bash
sudo apt install nginx -y
```

### 2. Create Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/hr-assistant
```

Add the following configuration:

```nginx
server {
    listen 80;
    server_name your_domain.com;  # Replace with your domain or server IP

    # Increase timeouts for long-running requests
    proxy_connect_timeout 300s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;
    
    client_max_body_size 50M;  # Allow large file uploads

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket support (if needed)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }

    # Serve static files directly
    location /static/ {
        alias /home/username/hr-assistant/static/;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }
}
```

Replace `your_domain.com` and `username` with your actual values.

### 3. Enable the Site

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/hr-assistant /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx

# Enable Nginx to start on boot
sudo systemctl enable nginx
```

### 4. Update run.py for Nginx

When using Nginx, you can bind to localhost only in `run.py`:

```python
config.bind = ["127.0.0.1:5000"]
```

Then restart the service:
```bash
sudo systemctl restart hr-assistant
```

### 5. Optional: Enable HTTPS with Let's Encrypt

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d your_domain.com

# Certificate will auto-renew
```

---

## 🔒 Security Considerations

### 1. Configure Firewall

```bash
# Install UFW if not installed
sudo apt install ufw -y

# Allow SSH (important!)
sudo ufw allow 22/tcp

# Allow HTTP and HTTPS (if using Nginx)
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Or allow port 5000 directly (if not using Nginx)
sudo ufw allow 5000/tcp

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status
```

### 2. Secure the .env File

```bash
chmod 600 .env
```

### 3. Regular Updates

```bash
# Create a script for regular updates
cat > ~/update-hr-assistant.sh << 'EOF'
#!/bin/bash
cd /home/username/hr-assistant
source venv/bin/activate
pip install --upgrade -r requirements_for_server.txt
sudo systemctl restart hr-assistant
EOF

chmod +x ~/update-hr-assistant.sh
```

---

## 🐛 Troubleshooting

### Check Service Status

```bash
sudo systemctl status hr-assistant
```

### View Logs

```bash
# Real-time logs
sudo journalctl -u hr-assistant -f

# Last 100 lines
sudo journalctl -u hr-assistant -n 100

# Logs since specific time
sudo journalctl -u hr-assistant --since "1 hour ago"
```

### Common Issues

#### 1. Port Already in Use
```bash
# Check what's using port 5000
sudo lsof -i :5000

# Kill the process if needed
sudo kill -9 <PID>
```

#### 2. Permission Denied Errors
```bash
# Fix ownership
sudo chown -R username:username /home/username/hr-assistant

# Fix permissions
chmod -R 755 /home/username/hr-assistant
chmod 755 uploads HR_docs
```

#### 3. Module Not Found Errors
```bash
# Reinstall dependencies
source venv/bin/activate
pip install --upgrade -r requirements_for_server.txt
```

#### 4. Database Locked
```bash
# Check database permissions
chmod 644 combined_db.db
```

#### 5. Out of Memory
```bash
# Check memory usage
free -h

# Check process memory
ps aux --sort=-%mem | head
```

### Testing the Application

```bash
# Test if the service is responding
curl http://localhost:5000

# Or from another machine
curl http://your_server_ip:5000
```

---

## 📊 Monitoring

### 1. Check System Resources

```bash
# CPU and memory
htop

# Disk usage
df -h

# Application logs
sudo journalctl -u hr-assistant -f
```

### 2. Create a Monitoring Script

```bash
cat > ~/monitor-hr-assistant.sh << 'EOF'
#!/bin/bash
echo "=== HR Assistant Status ==="
sudo systemctl status hr-assistant --no-pager
echo ""
echo "=== Memory Usage ==="
ps aux | grep "python.*run.py" | grep -v grep
echo ""
echo "=== Recent Logs ==="
sudo journalctl -u hr-assistant -n 20 --no-pager
EOF

chmod +x ~/monitor-hr-assistant.sh
```

Run with: `./monitor-hr-assistant.sh`

---

## 🔄 Backup Strategy

### Create Backup Script

```bash
cat > ~/backup-hr-assistant.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/username/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup database
cp /home/username/hr-assistant/combined_db.db $BACKUP_DIR/combined_db_$DATE.db

# Backup uploads
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz -C /home/username/hr-assistant uploads/

# Keep only last 7 backups
cd $BACKUP_DIR
ls -t | tail -n +15 | xargs rm -f

echo "Backup completed: $DATE"
EOF

chmod +x ~/backup-hr-assistant.sh
```

### Schedule Daily Backups

```bash
# Edit crontab
crontab -e

# Add this line for daily backup at 2 AM
0 2 * * * /home/username/backup-hr-assistant.sh >> /home/username/backup.log 2>&1
```

---

## 📝 Quick Reference Commands

```bash
# Start/Stop/Restart
sudo systemctl start hr-assistant
sudo systemctl stop hr-assistant
sudo systemctl restart hr-assistant

# View logs
sudo journalctl -u hr-assistant -f

# Check status
sudo systemctl status hr-assistant

# Test connectivity
curl http://localhost:5000

# Update application
cd /home/username/hr-assistant
source venv/bin/activate
git pull  # if using git
pip install -r requirements_for_server.txt
sudo systemctl restart hr-assistant
```

---

## 🎯 Post-Deployment Checklist

- [ ] Application files transferred to server
- [ ] Python 3.10 and venv installed
- [ ] Dependencies installed from requirements_for_server.txt
- [ ] `.env` file created with API keys
- [ ] `run.py` updated to bind to 0.0.0.0
- [ ] Systemd service created and enabled
- [ ] Firewall configured (UFW)
- [ ] Nginx configured (optional)
- [ ] SSL certificate installed (optional)
- [ ] Application accessible via browser
- [ ] Backup script created and scheduled
- [ ] Monitoring script created

---

## 📞 Support

If you encounter any issues:
1. Check the logs: `sudo journalctl -u hr-assistant -n 100`
2. Verify the service status: `sudo systemctl status hr-assistant`
3. Test connectivity: `curl http://localhost:5000`
4. Check system resources: `htop` and `df -h`

---

**Deployment Date**: October 27, 2025  
**Application**: HR Assistant Suite  
**Server**: Gateway GR 360 F1 (Ubuntu/Debian)

