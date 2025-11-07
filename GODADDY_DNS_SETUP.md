# 🌐 GoDaddy DNS Setup for pluto.peoplelogic.in

## Step 1: Get Your Server IP Address

**On your server, run:**
```bash
curl -s ifconfig.me
```

**Note down this IP address** - you'll need it for the DNS record.

---

## Step 2: Login to GoDaddy

1. Go to **https://www.godaddy.com**
2. Click **"Sign In"** (top right)
3. Enter your credentials for the `peoplelogic.in` domain

---

## Step 3: Access DNS Management

1. After logging in, click **"My Products"** or **"Domains"**
2. Find **`peoplelogic.in`** in your domain list
3. Click the **"DNS"** button (or **"Manage DNS"**)

---

## Step 4: Add A Record for Subdomain

1. Scroll down to the **"Records"** section
2. Click **"+ Add"** button (or **"Add Record"**)
3. Fill in the form:

   **Type:** Select **"A"** from dropdown
   
   **Name:** Enter **`pluto`**
   - ⚠️ **Important:** Only enter `pluto`, NOT `pluto.peoplelogic.in`
   
   **Value:** Enter your server IP (from Step 1)
   - Example: `106.51.74.79` (your actual IP will be different)
   
   **TTL:** Select **"600 seconds"** (or keep default)
   
   **Priority:** Leave empty (only for MX records)

4. Click **"Save"** (or **"Add Record"**)

---

## Step 5: Verify DNS Record

After saving, you should see a new entry in your DNS records table:

```
Type | Name  | Value         | TTL
-----|-------|---------------|-----
A    | pluto | 106.51.74.79  | 600
```

---

## Step 6: Wait for DNS Propagation

DNS changes can take **5-60 minutes** to propagate worldwide.

**To check if DNS has propagated:**

**On Windows (PowerShell):**
```powershell
nslookup pluto.peoplelogic.in
```

**On Linux/Mac:**
```bash
dig pluto.peoplelogic.in +short
# or
nslookup pluto.peoplelogic.in
```

**Expected output:** Your server IP address (e.g., `106.51.74.79`)

**If it returns nothing or wrong IP:** Wait a few more minutes and try again.

---

## Step 7: Test DNS from Server

**On your server, run:**
```bash
dig pluto.peoplelogic.in +short
```

**Should return:** Your server IP address

---

## Visual Guide

```
GoDaddy Dashboard
└── My Products / Domains
    └── peoplelogic.in
        └── DNS / Manage DNS
            └── Records Section
                └── + Add Record
                    ├── Type: A
                    ├── Name: pluto
                    ├── Value: [YOUR_SERVER_IP]
                    └── Save
```

---

## Troubleshooting

### Issue: "DNS record not found" after waiting

**Solution:**
1. Double-check the **Name** field - it should be just `pluto`, not `pluto.peoplelogic.in`
2. Verify the IP address is correct
3. Try clearing DNS cache:
   - Windows: `ipconfig /flushdns`
   - Linux: `sudo systemd-resolve --flush-caches`

### Issue: DNS shows wrong IP

**Solution:**
1. Edit the A record in GoDaddy
2. Update the Value field with correct IP
3. Wait 5-10 minutes for propagation

### Issue: Can't find DNS Management

**Solution:**
- GoDaddy interface varies - look for:
  - "DNS" tab
  - "Manage DNS" link
  - "DNS Zone File" option
  - Or contact GoDaddy support

---

## After DNS is Configured

Once DNS propagation is complete, you can:

1. **Run the Nginx setup script** (if not already done):
   ```bash
   bash deploy_scripts/pluto-subdomain-setup.sh
   ```

2. **Access your app at:**
   - `https://pluto.peoplelogic.in` (after SSL setup)

---

## Quick Reference

**DNS Record Details:**
- **Type:** A
- **Name:** `pluto`
- **Value:** `[YOUR_SERVER_IP]` (get with: `curl -s ifconfig.me`)
- **TTL:** 600 seconds

**Full subdomain:** `pluto.peoplelogic.in`

---

**Need Help?**
If you're stuck, share:
1. Screenshot of GoDaddy DNS records page
2. Output of `dig pluto.peoplelogic.in +short` from server
3. Your server IP address

