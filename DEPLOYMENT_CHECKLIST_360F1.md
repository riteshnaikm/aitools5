# 🚀 Deployment Checklist for 360 F1 Server

## ✅ Pre-Deployment Checklist

### 1. **Files Ready for Deployment**
- [x] `.gitignore` created (excludes venv, __pycache__, .db, logs)
- [x] `requirements.txt` ready (copied from requirements_for_server.txt)
- [x] `run_production.py` configured for production (0.0.0.0:5000)
- [x] All navigation links properly configured in `base.html`
- [x] Database initialization in `app.py` (creates all tables on startup)
- [x] Enhanced feedback history page ready

### 2. **Environment Variables Required on Server**
Create a `.env` file on your server with:
```bash
GROQ_API_KEY=your_groq_api_key_here
PINECONE_API_KEY=your_pinecone_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
```

### 3. **Folder Structure to Clone**
```
├── app.py                      # Main application
├── run_production.py           # Production runner (USE THIS!)
├── requirements.txt            # Python dependencies
├── HR_docs/                    # HR policy PDFs (REQUIRED)
├── static/                     # CSS, JS, images
├── templates/                  # HTML templates
├── uploads/                    # Resume uploads (will be created)
└── .env                        # Create this on server
```

---

## 📋 Deployment Steps

### Step 1: Clone Repository on Server
```bash
cd /path/to/your/deployment/folder
git clone <your-repo-url> hr-assistant
cd hr-assistant
```

### Step 2: Set Up Python Virtual Environment
```bash
python3 -m venv venv
source venv/bin/activate  # On Linux
```

### Step 3: Install Dependencies
```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### Step 4: Create .env File
```bash
nano .env
# Add your API keys:
GROQ_API_KEY=your_key_here
PINECONE_API_KEY=your_key_here
GEMINI_API_KEY=your_key_here
```

### Step 5: Verify HR_docs Folder
```bash
ls HR_docs/  # Should show all your PDF files
```

### Step 6: Run Application
```bash
# For production deployment:
python run_production.py

# Or use systemd service (recommended):
sudo systemctl start hr-assistant
```

---

## ⚙️ Server Configuration

### Systemd Service File (Recommended)
Create `/etc/systemd/system/hr-assistant.service`:
```ini
[Unit]
Description=HR Assistant Suite
After=network.target

[Service]
Type=simple
User=your_username
WorkingDirectory=/path/to/hr-assistant
Environment="PATH=/path/to/hr-assistant/venv/bin"
ExecStart=/path/to/hr-assistant/venv/bin/python run_production.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable hr-assistant
sudo systemctl start hr-assistant
sudo systemctl status hr-assistant
```

### Nginx Configuration (If using reverse proxy)
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 🔍 Post-Deployment Verification

### 1. Check Application is Running
```bash
curl http://localhost:5000
# Should return HTML content
```

### 2. Test Key Features
- [ ] HR Assistant (Info Buddy) - Ask a question
- [ ] Resume Evaluator (Match Maker) - Upload and evaluate a resume
- [ ] Recruiter Handbook - Generate a handbook
- [ ] History page - View past evaluations
- [ ] Feedback History - Check feedback entries (access manually)

### 3. Check Logs
```bash
tail -f hr_assistant.log
# Or if using systemd:
sudo journalctl -u hr-assistant -f
```

### 4. Test Database
```bash
python -c "import sqlite3; conn = sqlite3.connect('combined_db.db'); cursor = conn.cursor(); cursor.execute('SELECT name FROM sqlite_master WHERE type=\"table\"'); print([row[0] for row in cursor.fetchall()]); conn.close()"
```

Should show: `['evaluations', 'qa_history', 'qa_feedback', 'feedback', 'handbook_feedback', 'interview_questions', 'recruiter_handbooks']`

---

## 🛡️ Security Notes

### What's Hidden from Regular Users:
- ❌ **Dashboard** link (hidden in navigation)
- ❌ **Feedback History** link (hidden in navigation)

### Manual Access Only (for admins):
- `http://your-server/dashboard`
- `http://your-server/feedback_history`

### API Keys:
- ✅ All API keys loaded from `.env` file
- ✅ Never committed to git
- ✅ Not exposed in logs

---

## 📝 Important Files Overview

| File | Purpose | Notes |
|------|---------|-------|
| `run_production.py` | Production server | ✅ Use this on server |
| `run.py` | Development server | ❌ Don't use on server |
| `app.py` | Main application | Contains all routes & logic |
| `requirements.txt` | Python packages | Install with pip |
| `.env` | API keys | **Create manually on server** |
| `combined_db.db` | SQLite database | Auto-created on first run |
| `HR_docs/` | HR policy PDFs | **Required** for HR Assistant |

---

## 🚨 Common Issues & Solutions

### Issue 1: "No module named 'app'"
**Solution:** Ensure you're in the correct directory and venv is activated

### Issue 2: "Pinecone initialization failed"
**Solution:** Check `.env` file has correct `PINECONE_API_KEY`

### Issue 3: "No PDF files found"
**Solution:** Ensure `HR_docs/` folder exists with PDF files

### Issue 4: Port 5000 already in use
**Solution:** 
```bash
sudo lsof -i :5000  # Find process
sudo kill -9 <PID>  # Kill it
```

### Issue 5: Permission denied on uploads/
**Solution:**
```bash
mkdir -p uploads
chmod 755 uploads
```

---

## 📞 Support Checklist

Before deployment, ensure:
- [x] All code tested locally
- [x] API keys available
- [x] HR_docs folder has all PDFs
- [x] Database tables auto-create on startup
- [x] All features working (HR Assistant, Resume Evaluator, Recruiter Handbook, Feedback)
- [x] Navigation properly configured
- [x] .gitignore excludes sensitive files

---

## 🎉 You're Ready to Deploy!

**Command to start on server:**
```bash
source venv/bin/activate
python run_production.py
```

**Access your application at:**
- `http://your-server-ip:5000`
- Or `http://your-domain.com` (if using Nginx)

---

**Last Updated:** October 30, 2025  
**Version:** 2.0 (Enhanced Feedback System)

