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