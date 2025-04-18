# Pi-hole Monitoring Scripts

A lightweight monitoring and alerting setup for a self-hosted Pi-hole instance on Raspberry Pi.  
Includes system status summaries and real-time Telegram alerts for critical events.

## 🤔 What Problem Does This Solve?

Pi-hole is great when it “just works” — until it quietly doesn’t.

This project fills the gap between a fire-and-forget Pi-hole setup and a more operationally aware, security-conscious environment.

Without alerts, a failed Pi-hole often goes unnoticed until DNS stops working or ad blocking vanishes — leaving users annoyed or admins unaware of silent failures.

**This project strives to strike a healthy balance**:

- 🛡  **Confidently deploy unattended security updates** for Debian, Raspian, etc. using raspiBackup
- 🕵️  **Monitors service uptime** without excess noise.
- 📬 **Sends concise reports and failure alerts via Telegram**. Also reminds users to update and upgrade their RPi operating system.

It helps keep your Pi-hole running *and* trusted — without turning you into a full-time sysadmin.

---

## 📦 Features

- 📊 **Quarterly status reports** via Telegram  
  Includes uptime, last reboot time, available updates, disk usage, and Pi-hole version info.

- 📯 **Immediate alert if Pi-hole goes down**  
  A lightweight watchdog checks the `pihole-FTL` service and notifies you if it fails.  
  *Note: This logic runs on the Pi itself — if the entire Raspberry Pi goes down, no alert will trigger.*

- 🔄 **Cron-based scheduling**  
  No dependencies beyond Bash and `curl`. Easy to customize frequency.

- 🔐 **Centralized `.env` configuration**  
  All secrets and host details are stored in a single `.env` file for easy management.


---

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

---

## 📌 Prerequisites

- Pi-hole must be installed and running
- `raspiBackup` must be installed and fully configured, including a working backup destination.
- A backup destination (e.g. USB or SD card) must be mounted
- A Telegram bot and chat ID must be created and configured

---

## ⚙️  Setup Instructions

### 1. Clone or copy the project folder to your Pi

```bash
git clone https://github.com/alexi215/pihole-monitoring-scripts.git ~/pihole-monitoring-scripts
cd ~/pihole-monitoring-scripts
```

### 2. Create and configure your `.env` file

```bash
cp .env.example .env
nano .env
```

Fill in the following:

```env
TELEGRAM_TOKEN="your_bot_token"
TELEGRAM_CHAT_ID="your_chat_id"
PIHOLE_HOSTNAME="your_pihole_name"
```

### 3. Add permissions and run the installer

```bash
chmod +x install.sh
./install.sh
```

This will:

- Make all scripts executable
- Check that the backup disk is mounted
- Install cron jobs for:
  - Pi-hole watchdog (every 2 minutes)
  - Quarterly report (Jan, Apr, Jul, Oct at 8 AM)

---

## ✅ To-Do

### Features & Logic
- [ ] Optionally generate alerts for **successful** backups
- [ ] Replace device variable with more extensible path variable
- [ ] Create test message scripts for:
  - Down alerts
  - Quarterly reports

### Documentation & Examples
- [ ] Provide example output of a quarterly report
- [ ] Provide example down alert message
- [ ] Add setup instructions for creating a Telegram bot and retrieving your chat ID
- [ ] Document current alert behavior in the README
