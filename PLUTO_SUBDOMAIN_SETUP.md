# 🚀 Pluto Subdomain Setup Guide
## pluto.peoplelogic.in with IP Whitelist & VPN Access

---

## Step 1: DNS Configuration

**In your domain registrar (where peoplelogic.in is managed):**

Add an **A Record**:
- **Type:** A
- **Name:** pluto
- **Value:** `<your-server-public-ip>` (get it with: `curl -s ifconfig.me`)
- **TTL:** 300 (or default)

**Verify DNS propagation** (wait 5-10 minutes, then test):
```bash
dig pluto.peoplelogic.in +short
# Should return your server IP
```

---

## Step 2: Get Your Company IPs / VPN IPs

**On your server, run these commands to identify allowed IPs:**

```bash
# Get your current public IP (if accessing from office)
curl -s ifconfig.me

# Get VPN IP range (if using common VPN services)
# Example: If VPN subnet is 10.0.0.0/8, you'd allow 10.0.0.0/8
# Ask your network admin for VPN subnet ranges
```

**Common VPN IP ranges:**
- Tailscale: `100.0.0.0/8`
- WireGuard: Usually `10.x.x.x/24` or custom
- OpenVPN: Usually `10.8.0.0/24` or custom
- Corporate VPN: Check with IT team

**Example IP whitelist:**
- Office IP: `123.45.67.89` (single IP)
- VPN Range: `10.0.0.0/8` (entire subnet)
- Multiple offices: `123.45.67.0/24` (subnet)

---

## Step 3: Configure Nginx with IP Whitelist

**On your server, create the Nginx config:**

```bash
sudo nano /etc/nginx/sites-available/pluto.peoplelogic.in
```

**Paste this configuration** (replace `YOUR_OFFICE_IP` and `YOUR_VPN_SUBNET`):

```nginx
# IP Whitelist: Define allowed IPs and subnets
geo $allowed_ip {
    default 0;
    # Add your office IPs (replace with actual IPs)
    YOUR_OFFICE_IP_1 1;
    YOUR_OFFICE_IP_2 1;
    # Add VPN subnet (replace with your VPN range)
    YOUR_VPN_SUBNET/24 1;
    # Example: 10.0.0.0/8 1;  # Allows entire 10.x.x.x range
    # Example: 100.64.0.0/10 1;  # Tailscale VPN range
}

# Allow localhost (for health checks)
geo $local {
    default 0;
    127.0.0.1 1;
    ::1 1;
}

server {
    listen 80;
    server_name pluto.peoplelogic.in;

    # Block all requests unless from whitelist
    if ($allowed_ip != 1) {
        return 403;
    }

    # Health check endpoint (allow localhost)
    location /health {
        access_log off;
        return 200 "OK\n";
        add_header Content-Type text/plain;
    }

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
        
        # Timeouts
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
```

**Save and exit** (Ctrl+X, Y, Enter)

**Enable the site:**
```bash
sudo ln -sf /etc/nginx/sites-available/pluto.peoplelogic.in /etc/nginx/sites-enabled/pluto.peoplelogic.in
sudo nginx -t
```

**If test passes, reload Nginx:**
```bash
sudo systemctl reload nginx
```

---

## Step 4: Setup SSL/HTTPS (Let's Encrypt)

**Install Certbot:**
```bash
sudo apt-get update
sudo apt-get install -y certbot python3-certbot-nginx
```

**Get SSL certificate:**
```bash
sudo certbot --nginx -d pluto.peoplelogic.in
```

**Follow prompts:**
- Enter email (for renewal notices)
- Agree to terms
- Choose whether to redirect HTTP to HTTPS (recommended: Yes)

**Certbot will automatically:**
1. Obtain SSL certificate
2. Update Nginx config to use HTTPS
3. Set up auto-renewal

**Verify auto-renewal:**
```bash
sudo certbot renew --dry-run
```

---

## Step 5: Firewall Configuration (Additional Security)

**If using UFW:**
```bash
# Allow HTTP (for Let's Encrypt verification)
sudo ufw allow 80/tcp

# Allow HTTPS
sudo ufw allow 443/tcp

# Optional: Block direct access to port 5000 from outside
# (Only allow localhost/Nginx)
sudo ufw deny 5000/tcp

# Reload firewall
sudo ufw reload
```

**If using iptables directly:**
```bash
# Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Block direct access to 5000 from outside
sudo iptables -A INPUT -p tcp --dport 5000 ! -s 127.0.0.1 -j DROP
```

---

## Step 6: Test Access

**1. Test from allowed IP (should work):**
```bash
curl -I https://pluto.peoplelogic.in
```

**2. Test from blocked IP (should return 403):**
```bash
# From a different machine/IP
curl -I https://pluto.peoplelogic.in
# Expected: 403 Forbidden
```

**3. Test in browser:**
- From office/VPN: `https://pluto.peoplelogic.in` should load
- From outside: Should show 403 Forbidden

---

## Step 7: Update IP Whitelist (When Needed)

**To add new IPs/subnets:**

1. Edit Nginx config:
```bash
sudo nano /etc/nginx/sites-available/pluto.peoplelogic.in
```

2. Add new IPs in the `geo $allowed_ip` block:
```nginx
geo $allowed_ip {
    default 0;
    YOUR_OFFICE_IP_1 1;
    YOUR_OFFICE_IP_2 1;
    NEW_OFFICE_IP 1;        # Add new IP
    YOUR_VPN_SUBNET/24 1;
}
```

3. Test and reload:
```bash
sudo nginx -t
sudo systemctl reload nginx
```

---

## Troubleshooting

### Issue: 403 Forbidden even from allowed IP

**Check Nginx logs:**
```bash
sudo tail -f /var/log/nginx/error.log
```

**Verify IP is correct:**
```bash
# Check what IP Nginx sees
curl -H "Host: pluto.peoplelogic.in" https://pluto.peoplelogic.in
# Check Nginx access logs
sudo tail -f /var/log/nginx/access.log
```

**Debug: Temporarily log all IPs:**
```nginx
# Add to server block for debugging
access_log /var/log/nginx/pluto_debug.log combined;
```

### Issue: SSL certificate failed

**Check DNS propagation:**
```bash
dig pluto.peoplelogic.in +short
```

**Manual certbot verification:**
```bash
sudo certbot certonly --standalone -d pluto.peoplelogic.in
```

### Issue: App not loading

**Check app is running:**
```bash
sudo systemctl status aitools4
curl http://127.0.0.1:5000
```

**Check Nginx proxy:**
```bash
sudo nginx -t
sudo systemctl status nginx
```

---

## Quick Reference Commands

```bash
# View Nginx config
sudo cat /etc/nginx/sites-available/pluto.peoplelogic.in

# Test Nginx config
sudo nginx -t

# Reload Nginx
sudo systemctl reload nginx

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Check app status
sudo systemctl status aitools4

# View app logs
journalctl -u aitools4 -f

# Renew SSL (auto-runs, but manual if needed)
sudo certbot renew

# Check firewall status
sudo ufw status
```

---

## Security Best Practices

1. **Keep IP whitelist minimal** - Only add necessary IPs/subnets
2. **Use VPN for remote access** - Don't expose office IPs directly
3. **Regular updates** - Keep Nginx and system updated
4. **Monitor logs** - Check for unauthorized access attempts
5. **SSL only** - Enforce HTTPS (certbot does this automatically)
6. **Backup configs** - Save Nginx config before major changes

---

## Final Checklist

- [ ] DNS A record added for `pluto.peoplelogic.in`
- [ ] DNS propagated (check with `dig`)
- [ ] Nginx config created with IP whitelist
- [ ] Nginx config tested (`nginx -t`)
- [ ] Nginx reloaded
- [ ] SSL certificate obtained (certbot)
- [ ] Firewall configured (ports 80, 443 open)
- [ ] Tested access from allowed IP (works)
- [ ] Tested access from blocked IP (403 Forbidden)
- [ ] App accessible at `https://pluto.peoplelogic.in`

---

**Your app will be accessible at:** `https://pluto.peoplelogic.in`

**Only users from whitelisted IPs or VPN will be able to access it.**

