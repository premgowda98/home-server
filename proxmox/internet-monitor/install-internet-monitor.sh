#!/bin/bash

# Installation script for Internet Monitor Service on Proxmox
# Run this script as root on your Proxmox server

set -e

echo "Installing Internet Monitor Service for Proxmox..."

# Create the directory for the monitor
INSTALL_DIR="/root/internet-monitor"
mkdir -p "$INSTALL_DIR"

# Copy the monitoring script
echo "Installing monitoring script..."
cat > "$INSTALL_DIR/internet-monitor.sh" << 'EOF'
#!/bin/bash

# Internet Monitor Script for Proxmox
# Checks internet connectivity every 2 minutes and restarts system if no connection

# Configuration
LOG_DIR="/root/internet-monitor"
LOG_FILE="$LOG_DIR/internet-monitor.log"
PING_TARGET="8.8.8.8"  # Google DNS
PING_COUNT=3
PING_TIMEOUT=10
CHECK_INTERVAL=120  # 2 minutes in seconds

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# Function to check internet connectivity
check_internet() {
    # Try to ping Google DNS
    if ping -c $PING_COUNT -W $PING_TIMEOUT $PING_TARGET > /dev/null 2>&1; then
        return 0  # Internet is available
    else
        # Try alternative DNS servers
        if ping -c $PING_COUNT -W $PING_TIMEOUT 1.1.1.1 > /dev/null 2>&1; then
            return 0  # Internet is available
        elif ping -c $PING_COUNT -W $PING_TIMEOUT 208.67.222.222 > /dev/null 2>&1; then
            return 0  # Internet is available
        else
            return 1  # No internet connection
        fi
    fi
}

# Function to restart the system
restart_system() {
    log_message "CRITICAL: No internet access detected. System will restart in 30 seconds."
    log_message "INFO: Initiating system restart due to internet connectivity failure."
    
    # Give a brief delay to allow log writing
    sleep 5
    
    # Sync filesystem to ensure logs are written
    sync
    
    # Restart the system
    /sbin/reboot
}

# Function to run the monitoring loop
monitor_internet() {
    log_message "INFO: Internet monitoring service started. Checking every ${CHECK_INTERVAL} seconds."
    
    while true; do
        if check_internet; then
            log_message "INFO: Internet connectivity confirmed."
        else
            log_message "WARNING: Internet connection test failed."
            
            # Wait 30 seconds and try again before restarting
            sleep 30
            
            if check_internet; then
                log_message "INFO: Internet connectivity restored after retry."
            else
                # Still no internet, restart the system
                restart_system
            fi
        fi
        
        # Wait for the next check interval
        sleep $CHECK_INTERVAL
    done
}

# Main execution
case "$1" in
    start)
        log_message "INFO: Starting internet monitoring daemon..."
        monitor_internet
        ;;
    test)
        echo "Testing internet connectivity..."
        if check_internet; then
            echo "Internet connection: OK"
            exit 0
        else
            echo "Internet connection: FAILED"
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 {start|test}"
        echo "  start - Start the internet monitoring daemon"
        echo "  test  - Test internet connectivity once"
        exit 1
        ;;
esac
EOF

# Make the script executable
chmod +x "$INSTALL_DIR/internet-monitor.sh"

# Create the systemd service file
echo "Creating systemd service..."
cat > /etc/systemd/system/internet-monitor.service << 'EOF'
[Unit]
Description=Internet Connectivity Monitor
Documentation=man:ping(8)
After=network-online.target
Wants=network-online.target
StartLimitInterval=0

[Service]
Type=simple
User=root
Group=root
ExecStart=/bin/bash /root/internet-monitor/internet-monitor.sh start
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
KillMode=mixed
TimeoutStopSec=30
WorkingDirectory=/root/internet-monitor

# Minimal security settings for system monitoring script
NoNewPrivileges=no
PrivateTmp=no
ProtectHome=no

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
echo "Enabling and starting the service..."
systemctl daemon-reload
systemctl enable internet-monitor.service

# Test the script first
echo "Testing internet connectivity..."
if "$INSTALL_DIR/internet-monitor.sh" test; then
    echo "Internet connectivity test passed."
    
    # Start the service
    systemctl start internet-monitor.service
    
    echo ""
    echo "Internet Monitor Service has been installed and started successfully!"
    echo ""
    echo "Service commands:"
    echo "  systemctl status internet-monitor    - Check service status"
    echo "  systemctl stop internet-monitor      - Stop the service"
    echo "  systemctl start internet-monitor     - Start the service"
    echo "  systemctl restart internet-monitor   - Restart the service"
    echo "  systemctl disable internet-monitor   - Disable auto-start"
    echo ""
    echo "Log file location: /root/internet-monitor/internet-monitor.log"
    echo "Script location: /root/internet-monitor/internet-monitor.sh"
    echo ""
    echo "To view logs in real-time:"
    echo "  tail -f /root/internet-monitor/internet-monitor.log"
    echo "  journalctl -u internet-monitor -f"
else
    echo "WARNING: Internet connectivity test failed!"
    echo "You may want to check your network configuration before starting the service."
    echo "The service has been installed but not started."
    echo ""
    echo "To start manually when ready:"
    echo "  systemctl start internet-monitor"
fi

echo ""
echo "Installation complete!"
