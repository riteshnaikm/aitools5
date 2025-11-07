# 🚀 HR Assistant Suite - Linux Deployment Package

Complete deployment package for hosting your HR Assistant Suite on Gateway GR 360 F1 (Ubuntu/Debian Linux).

---

## 📚 Documentation Overview

This deployment package contains everything you need to successfully deploy your application from Windows to Linux.

### 📖 Main Documentation Files

| File | Purpose | When to Read |
|------|---------|--------------|
| **DEPLOYMENT_README.md** | **This file** - Start here! | First |
| [LINUX_DEPLOYMENT_SUMMARY.md](LINUX_DEPLOYMENT_SUMMARY.md) | Quick overview & key concepts | First |
| [WINDOWS_TO_LINUX_GUIDE.md](WINDOWS_TO_LINUX_GUIDE.md) | How to transfer files from Windows | Before deploying |
| [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) | Step-by-step checklist | During deployment |
| [LINUX_DEPLOYMENT_GUIDE.md](LINUX_DEPLOYMENT_GUIDE.md) | Complete technical reference | As needed |
| [deploy_scripts/README.md](deploy_scripts/README.md) | Script documentation | Before running scripts |

---

## 🎯 Quick Start (3 Steps)

### Prerequisites Checklist

Before starting, ensure you have:

- [ ] Server IP address and SSH credentials
- [ ] Groq API Key
- [ ] Pinecone API Key  
- [ ] Google Gemini API Key
- [ ] HR PDF documents ready
- [ ] Backup of database and uploads

### Step 1: Transfer Files (Choose One Method)

**Option A: WinSCP (Easiest for beginners)**
1. Download WinSCP from https://winscp.net/
2. Connect to your server
3. Upload all files to `~/hr-assistant/`
4. ✅ See [WINDOWS_TO_LINUX_GUIDE.md](WINDOWS_TO_LINUX_GUIDE.md) for detailed instructions

**Option B: Command Line (Fastest)**
```powershell
# From Windows PowerShell
cd "C:\Users\Ritesh\Desktop\Cursor 1"
scp -r * username@server_ip:~/hr-assistant/
```

### Step 2: Run Automated Installation

```bash
# SSH into server
ssh username@server_ip

# Navigate to application
cd hr-assistant

# Run installation script
bash deploy_scripts/install.sh
```

Wait 5-10 minutes for installation to complete.

### Step 3: Configure and Start

```bash
# Edit .env file with your real API keys
nano .env

# Start the service
sudo systemctl start hr-assistant

# Check status
sudo systemctl status hr-assistant
```

**Done!** Access your app at: `http://your_server_ip:5000`

---

## 📦 What's Included

### Automated Scripts

Located in `deploy_scripts/` folder:

| Script | Purpose | Usage |
|--------|---------|-------|
| `install.sh` | Complete automated installation | `bash deploy_scripts/install.sh` |
| `nginx-setup.sh` | Configure Nginx reverse proxy | `bash deploy_scripts/nginx-setup.sh domain.com` |
| `update.sh` | Update application | `bash deploy_scripts/update.sh` |
| `verify-deployment.sh` | Verify deployment success | `bash deploy_scripts/verify-deployment.sh` |

### Production Files

| File | Purpose |
|------|---------|
| `run_production.py` | Production-optimized server configuration |
| `.env` | Environment variables (API keys) |
| `requirements_for_server.txt` | Python dependencies for Linux |

### Helper Scripts (Created During Installation)

After running `install.sh`, you'll get:

- `~/backup-hr-assistant.sh` - Backup database and uploads
- `~/monitor-hr-assistant.sh` - Monitor application health

---

## 🗺️ Deployment Roadmap

Follow this path for a smooth deployment:

```
┌─────────────────────────────────────┐
│ 1. READ THIS FILE                   │
│    (DEPLOYMENT_README.md)           │
└──────────────┬───-──────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 2. READ QUICK OVERVIEW              │
│    (LINUX_DEPLOYMENT_SUMMARY.md)    │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 3. TRANSFER FILES                   │
│    (WINDOWS_TO_LINUX_GUIDE.md)      │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 4. RUN INSTALLATION                 │
│    bash deploy_scripts/install.sh   │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 5. CONFIGURE & START                │
│    (DEPLOYMENT_CHECKLIST.md)        │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 6. VERIFY DEPLOYMENT                │
│    bash deploy_scripts/verify.sh    │
└──────────────┬──────────────────────┘
               ↓
┌─────────────────────────────────────┐
│ 7. OPTIONAL: SETUP NGINX            │
│    bash deploy_scripts/nginx.sh     │
└──────────────┬──────────────────────┘
               ↓
         ✅ DONE!
```

---

## 🎓 Documentation for Different Scenarios

### Scenario 1: First-Time Deployment

**Read these in order:**

1. ✅ This file (DEPLOYMENT_README.md)
2. ✅ [LINUX_DEPLOYMENT_SUMMARY.md](LINUX_DEPLOYMENT_SUMMARY.md) - Overview
3. ✅ [WINDOWS_TO_LINUX_GUIDE.md](WINDOWS_TO_LINUX_GUIDE.md) - File transfer
4. ✅ [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Step by step
5. 📚 [LINUX_DEPLOYMENT_GUIDE.md](LINUX_DEPLOYMENT_GUIDE.md) - If you need details

### Scenario 2: Experienced with Linux

**Quick path:**

1. ✅ [LINUX_DEPLOYMENT_SUMMARY.md](LINUX_DEPLOYMENT_SUMMARY.md)
2. ✅ Transfer files
3. ✅ Run `bash deploy_scripts/install.sh`
4. ✅ Configure `.env`
5. ✅ Start service

### Scenario 3: Troubleshooting

**If something goes wrong:**

1. 🔍 Run verification: `bash deploy_scripts/verify-deployment.sh`
2. 📖 Check [LINUX_DEPLOYMENT_GUIDE.md](LINUX_DEPLOYMENT_GUIDE.md) - Troubleshooting section
3. 📋 Review [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
4. 📊 Check logs: `sudo journalctl -u hr-assistant -n 100`

### Scenario 4: Updating Application

**When you make changes:**

1. Transfer updated files (see [WINDOWS_TO_LINUX_GUIDE.md](WINDOWS_TO_LINUX_GUIDE.md))
2. Run: `bash deploy_scripts/update.sh`
3. Verify: `sudo systemctl status hr-assistant`

---

## 🔧 Common Tasks

### Service Management

```bash
# Start service
sudo systemctl start hr-assistant

# Stop service
sudo systemctl stop hr-assistant

# Restart service
sudo systemctl restart hr-assistant

# Check status
sudo systemctl status hr-assistant

# View logs (real-time)
sudo journalctl -u hr-assistant -f

# View last 100 log lines
sudo journalctl -u hr-assistant -n 100
```

### Monitoring

```bash
# Quick health check
~/monitor-hr-assistant.sh

# Check system resources
htop

# Check disk space
df -h

# Check memory
free -h
```

### Backup

```bash
# Manual backup
~/backup-hr-assistant.sh

# View backups
ls -lh ~/backups/

# Schedule daily backups
crontab -e
# Add: 0 2 * * * /home/username/backup-hr-assistant.sh
```

### Updating

```bash
# Update application
cd ~/hr-assistant
bash deploy_scripts/update.sh

# Update system packages
sudo apt update && sudo apt upgrade -y
```

---

## 🌐 Access Your Application

After successful deployment:

### Without Nginx
```
http://your_server_ip:5000
```

### With Nginx
```
http://your_domain.com
```

### With HTTPS (After SSL setup)
```
https://your_domain.com
```

---

## ✅ Verification

After deployment, run the verification script:

```bash
cd ~/hr-assistant
bash deploy_scripts/verify-deployment.sh
```

This checks:
- ✅ System requirements
- ✅ Required files
- ✅ Environment configuration
- ✅ Service status
- ✅ Network connectivity
- ✅ Dependencies
- ✅ And more...

---

## 📊 System Requirements

### Minimum Requirements

- **OS**: Ubuntu 20.04+ or Debian 11+
- **RAM**: 2 GB minimum (4 GB recommended)
- **CPU**: 2 cores minimum
- **Disk**: 10 GB free space
- **Network**: Static IP or domain name

### Software Requirements (Auto-installed)

- Python 3.10
- pip
- Virtual environment
- System dependencies (build tools, SSL, etc.)

---

## 🔒 Security Features

✅ Service runs as non-root user  
✅ Firewall configuration (UFW)  
✅ Environment variables secured (600 permissions)  
✅ Nginx reverse proxy ready  
✅ SSL/HTTPS support ready  
✅ Automatic service restart on failure  
✅ Log management with journald  

---

## 💾 Backup Strategy

### What Gets Backed Up

- Database (`combined_db.db`)
- Uploaded files (`uploads/` folder)
- Last 7 backups retained automatically

### Backup Schedule

**Recommended**:
- Daily automated backups at 2 AM
- Weekly manual verification
- Monthly off-site backup

**Setup**:
```bash
crontab -e
# Add this line:
0 2 * * * /home/username/backup-hr-assistant.sh >> /home/username/backup.log 2>&1
```

---

## 🐛 Troubleshooting Quick Reference

### Service Won't Start
```bash
# Check logs
sudo journalctl -u hr-assistant -n 50

# Check if port is in use
sudo lsof -i :5000

# Verify files
ls -la ~/hr-assistant/
```

### Can't Access from Browser
```bash
# Check if service is running
sudo systemctl status hr-assistant

# Check firewall
sudo ufw status

# Test locally
curl http://localhost:5000
```

### High Memory Usage
```bash
# Check resources
htop

# Reduce workers in run_production.py
nano ~/hr-assistant/run_production.py
# Change: config.workers = 4 to config.workers = 2

# Restart
sudo systemctl restart hr-assistant
```

### Permission Errors
```bash
# Fix ownership
sudo chown -R $USER:$USER ~/hr-assistant

# Fix permissions
chmod -R 755 ~/hr-assistant
chmod 755 ~/hr-assistant/uploads ~/hr-assistant/HR_docs
chmod 600 ~/hr-assistant/.env
```

---

## 📞 Getting Help

### Self-Help Resources

1. **Verification Script**: `bash deploy_scripts/verify-deployment.sh`
2. **Check Logs**: `sudo journalctl -u hr-assistant -n 100`
3. **Full Guide**: [LINUX_DEPLOYMENT_GUIDE.md](LINUX_DEPLOYMENT_GUIDE.md)
4. **Checklist**: [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

### Diagnostic Commands

```bash
# Application status
sudo systemctl status hr-assistant

# Recent logs
sudo journalctl -u hr-assistant -n 50

# System resources
htop

# Disk space
df -h

# Network
sudo netstat -tlnp | grep :5000

# Process info
ps aux | grep python
```

---

## 🎯 Success Criteria

Your deployment is successful when:

- ✅ Service starts without errors
- ✅ Application accessible from browser
- ✅ All features working (chat, upload, evaluation)
- ✅ Service survives server reboot
- ✅ Logs show no critical errors
- ✅ Backups working correctly
- ✅ Verification script passes all checks

---

## 🔄 Maintenance Checklist

### Daily
- [ ] Check service status: `sudo systemctl status hr-assistant`
- [ ] Monitor disk space: `df -h`

### Weekly
- [ ] Review logs for errors: `sudo journalctl -u hr-assistant -n 100`
- [ ] Check system resources: `htop`
- [ ] Verify backups exist: `ls -lh ~/backups/`

### Monthly
- [ ] Update system: `sudo apt update && sudo apt upgrade`
- [ ] Update dependencies: `bash deploy_scripts/update.sh`
- [ ] Test backup restoration
- [ ] Review performance metrics
- [ ] Check disk space trends

### Quarterly
- [ ] Security audit
- [ ] Review and optimize performance
- [ ] Update API keys if needed
- [ ] Review and update documentation

---

## 📈 Performance Expectations

On Gateway GR 360 F1:

| Metric | Expected Value |
|--------|---------------|
| Startup Time | 10-20 seconds |
| Response Time | < 2 seconds |
| Memory Usage | 1-2 GB |
| CPU Usage | 10-30% (normal load) |
| Disk Space | ~2-5 GB (with dependencies) |

---

## 🚀 Advanced: Production Optimization

### Enable Nginx (Recommended)
```bash
bash deploy_scripts/nginx-setup.sh your_domain.com
```

### Enable HTTPS
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your_domain.com
```

### Optimize Performance
- Adjust workers in `run_production.py` based on CPU cores
- Enable caching (Redis) for high traffic
- Use CDN for static files
- Implement rate limiting

### High Availability
- Set up load balancer for multiple instances
- Use dedicated database server
- Implement health checks
- Configure automated failover

---

## 📝 Additional Resources

### Documentation Files

- Technical details: [LINUX_DEPLOYMENT_GUIDE.md](LINUX_DEPLOYMENT_GUIDE.md)
- Script documentation: [deploy_scripts/README.md](deploy_scripts/README.md)
- Application docs: `docs/HLD.md` and `docs/LLD.md`

### Configuration Files

- Production server: `run_production.py`
- Development server: `run.py`
- Dependencies: `requirements_for_server.txt`
- Environment: `.env`

---

## 🎉 You're Ready!

This deployment package contains everything you need for a successful deployment.

**Estimated time**: 30-60 minutes (first deployment)

**Next steps**:
1. Read [LINUX_DEPLOYMENT_SUMMARY.md](LINUX_DEPLOYMENT_SUMMARY.md)
2. Follow [WINDOWS_TO_LINUX_GUIDE.md](WINDOWS_TO_LINUX_GUIDE.md) to transfer files
3. Use [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) during deployment

**Good luck with your deployment! 🚀**

---

## 📌 Quick Links

- 🎯 [Quick Start](#quick-start-3-steps)
- 📚 [Documentation Overview](#documentation-overview)
- 🔧 [Common Tasks](#common-tasks)
- 🐛 [Troubleshooting](#troubleshooting-quick-reference)
- ✅ [Verification](#verification)
- 💾 [Backup Strategy](#backup-strategy)

---

**Package Created**: October 27, 2025  
**Target Server**: Gateway GR 360 F1 (Ubuntu/Debian)  
**Application**: HR Assistant Suite  
**Version**: 1.0

---

## 📧 Documentation Feedback

If you find any issues with this documentation or have suggestions:
- Note them in the deployment notes
- Update this file for future reference
- Share learnings with your team

---

**Remember**: Take your time, follow the checklist, and don't hesitate to review the documentation!

