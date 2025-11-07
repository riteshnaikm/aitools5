# HR Assistant Suite - Quick Reference Card
*Keep this handy during deployment*

---

## 🚀 DEPLOYMENT (3 Steps)

### 1. Transfer Files
```powershell
# From Windows PowerShell
scp -r "C:\Users\Ritesh\Desktop\Cursor 1\*" user@ip:~/hr-assistant/
```

### 2. Install
```bash
ssh user@server_ip
cd hr-assistant
bash deploy_scripts/install.sh
```

### 3. Configure & Start
```bash
nano .env  # Add API keys
sudo systemctl start hr-assistant
```

**Access**: `http://server_ip:5000`

---

## 🔧 SERVICE MANAGEMENT

```bash
sudo systemctl start hr-assistant      # Start
sudo systemctl stop hr-assistant       # Stop
sudo systemctl restart hr-assistant    # Restart
sudo systemctl status hr-assistant     # Status
```

---

## 📊 MONITORING

```bash
sudo journalctl -u hr-assistant -f     # Live logs
sudo journalctl -u hr-assistant -n 100 # Last 100 lines
~/monitor-hr-assistant.sh              # Quick health check
htop                                    # System resources
df -h                                   # Disk space
```

---

## 💾 BACKUP

```bash
~/backup-hr-assistant.sh               # Manual backup
ls -lh ~/backups/                      # View backups
```

**Schedule daily backups**:
```bash
crontab -e
# Add: 0 2 * * * /home/username/backup-hr-assistant.sh
```

---

## 🔄 UPDATE

```bash
cd ~/hr-assistant
bash deploy_scripts/update.sh
```

---

## ✅ VERIFY

```bash
bash deploy_scripts/verify-deployment.sh
```

---

## 🌐 SETUP NGINX (Optional)

```bash
bash deploy_scripts/nginx-setup.sh your_domain.com
```

**Enable HTTPS**:
```bash
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d your_domain.com
```

---

## 🐛 TROUBLESHOOTING

### Service won't start
```bash
sudo journalctl -u hr-assistant -n 50
sudo lsof -i :5000
```

### Can't access from browser
```bash
sudo systemctl status hr-assistant
sudo ufw status
curl http://localhost:5000
```

### Permission errors
```bash
sudo chown -R $USER:$USER ~/hr-assistant
chmod 755 ~/hr-assistant/uploads ~/hr-assistant/HR_docs
chmod 600 ~/hr-assistant/.env
```

### High memory
```bash
# Edit run_production.py: config.workers = 2
sudo systemctl restart hr-assistant
```

---

## 📝 IMPORTANT FILES

| File | Purpose |
|------|---------|
| `.env` | API keys (chmod 600) |
| `run_production.py` | Production server |
| `combined_db.db` | Database |
| `HR_docs/` | PDF documents |
| `uploads/` | Uploaded files |

---

## 🔒 SECURITY

```bash
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 5000/tcp  # App (or 80/443 for Nginx)
sudo ufw enable
chmod 600 .env
```

---

## 📞 NEED HELP?

1. Run: `bash deploy_scripts/verify-deployment.sh`
2. Check: `sudo journalctl -u hr-assistant -n 100`
3. Read: `LINUX_DEPLOYMENT_GUIDE.md`

---

## ⚙️ SERVER INFO

**Server IP**: _______________  
**SSH User**: _______________  
**Domain**: _______________  
**API Keys Location**: `.env`  

---

## ✅ DEPLOYMENT CHECKLIST

- [ ] Files transferred
- [ ] Install script completed
- [ ] .env configured with real API keys
- [ ] Service started
- [ ] Accessible from browser
- [ ] Firewall configured
- [ ] Backups scheduled
- [ ] Verification passed

---

**Quick Access**:
- Main Guide: `DEPLOYMENT_README.md`
- Checklist: `DEPLOYMENT_CHECKLIST.md`
- Scripts: `deploy_scripts/`

---

*Keep this card accessible during deployment and troubleshooting*

