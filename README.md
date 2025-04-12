## Pi-hole Monitoring Scripts

A lightweight monitoring and alerting setup for a self-hosted Pi-hole instance on Raspberry Pi.  
Includes system status summaries and real-time Telegram alerts for critical events.

## 🤔 What Problem Does This Solve?

Pi-hole is great when it “just works” — until it quietly doesn’t.

This project aims to fill the gap between a fire-and-forget Pi-hole setup and a more operationally aware, security-conscious environment.

Without alerts, a failed Pi-hole often goes unnoticed until DNS stops working or ad blocking vanishes — leaving users annoyed or admins unaware of silent failures. On the other side, blindly enabling full auto-updates can risk uptime.

This project strikes a healthy balance:
- 🛡️ Applies critical security updates automatically
- 🕵️ Monitors service uptime without excess noise
- 📬 Sends concise reports and failure alerts via Telegram

It helps keep your Pi-hole running *and* trusted — without turning you into a full-time sysadmin.

## 📦 Features

- ✅ **Quarterly status reports** via Telegram  
  Includes uptime, last reboot time, available updates, disk usage, and Pi-hole version info.

- 🚨 **Immediate alert if Pi-hole goes down**  
  A lightweight watchdog checks the `pihole-FTL` service and notifies you if it fails. Obviously, if the entire Rasbperry Pi goes down the alert will not trigger.

- 🔄 **Cron-based scheduling**  
  No dependencies beyond Bash and curl. Easy to customize frequency.

- 🔐 **Centralized .env configuration**  
  All secrets and host details are stored in a single `.env` file for easy management.

## 📁 Project Structure
```
pihole-monitoring-scripts/
├── bin/
│   ├── quarterly-report.sh       # Sends quarterly system summary via Telegram
│   ├── monitor-pihole.sh         # Alerts if Pi-hole goes offline
├── .env                          # Your local secrets (not committed)
├── .env.example                  # Template config file for safe sharing
├── install.sh                    # Installs cron jobs and verifies setup
```

## 📌 Prerequisites and Setup

# ✅ Required before using these scripts:

# - Pi-hole must already be installed and running on your Raspberry Pi
# - raspiBackup should be installed, configured, tested, and...backed up!
# - A backup device (e.g. USB SD card) must be mounted
# - You must have a Telegram bot and a chat ID set up

# --------------------------------------
# ⚙️  Setup Instructions
# --------------------------------------

# 1. Clone or copy the project folder to your Pi
```bash
git clone https://github.com/alexi215/pihole-monitoring-scripts.git ~/pihole-monitoring-scripts
cd ~/pihole-monitoring-scripts
```
# 2. Create and configure your .env file
```bash
cp  ~/pihole-monitoring-scripts/.env.example .env
nano ~/pihole-monitoring-scripts/.env
```

# Fill in the following inside .env
## TELEGRAM_BOT_TOKEN="your_bot_token"
## TELEGRAM_CHAT_ID="your_chat_id"
## PIHOLE_HOSTNAME="your_pihole_name"

# 3. Run the installer
```bash
chmod +x install.sh
./install.sh
```

This will:
- Make all scripts executable
- Check that the backup disk is mounted
- Install cron jobs for:
  - Pi-hole watchdog (every 2 minutes)
  - Quarterly status report (Jan, Apr, Jul, Oct at 8 AM)
