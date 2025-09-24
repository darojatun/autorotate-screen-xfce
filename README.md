XFCE Auto Rotate Screen Script with Touchscreen Support
This repository contains a script to automatically rotate the screen and synchronize touchscreen input on XFCE desktop environments, ideal for 2-in-1 laptops and convertible devices.

Features
Automatic screen rotation based on accelerometer data using iio-sensor-proxy
Synchronizes touchscreen, touchpad, stylus, and other input devices with screen orientation
Works on X11 with XFCE and other desktop environments 
No root privileges required (depending on implementation)
Supports manual rotation via command-line arguments
Prerequisites
Install the required packages:

# On Debian/Ubuntu-based systems
sudo apt install xrandr xinput iio-sensor-proxy

# On Arch Linux
sudo pacman -S xrandr xinput iio-sensor-proxy

# On Alpine Linux
sudo apk add xrandr xinput

Ensure your system has an accelerometer and that iio-sensor-proxy is running. You can test it with:

monitor-sensor

This should display orientation changes as you rotate your device.

Installation
Option 1: Using autorotate (Recommended)
A dedicated utility called autorotate simplifies setup:

# Download and extract
wget https://github.com/undg/autorotate/releases/latest/download/autorotate.zip
unzip autorotate.zip
cd bin/
chmod +x autorotate

# Check your display name
./autorotate list

# Test rotation
./autorotate left --display eDP-1

To run in daemon mode (auto-detect orientation):

./autorotate --display eDP-1 --daemon

Add to XFCE autostart for persistent background operation.

Option 2: Custom Shell Script
Create a script using monitor-sensor and xrandr:

#!/bin/sh

killall monitor-sensor
monitor-sensor > /dev/shm/sensor.log 2>&1 &

while inotifywait -e modify /dev/shm/sensor.log; do
  ORIENTATION=$(tail /dev/shm/sensor.log | grep 'orientation' | tail -1 | grep -oE '[^ ]+$')

  case "$ORIENTATION" in
    normal)
      xrandr -o normal
      xinput set-prop "Your Touchscreen Name" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
      ;;
    left-up)
      xrandr -o left
      xinput set-prop "Your Touchscreen Name" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
      ;;
    bottom-up)
      xrandr -o inverted
      xinput set-prop "Your Touchscreen Name" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
      ;;
    right-up)
      xrandr -o right
      xinput set-prop "Your Touchscreen Name" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
      ;;
  esac
done

Replace "Your Touchscreen Name" with the actual device name from xinput --list.

Make the script executable:

chmod +x rotate.sh

Option 3: Python-Based Rotation
Use a Python script that interfaces with D-Bus and iio-sensor-proxy. An example implementation can be found at https://github.com/andrewrembrandt/surface-autorotate2.

Configuration
Find your touchscreen device name:
xinput --list

Find your display name:
xrandr

Adjust the script with your specific device names and test manually before enabling auto-start.
Auto-Start in XFCE
Open Settings > Session and Startup > Application Autostart
Click Add
Enter a name (e.g., "Auto Rotate")
In the command field, enter the full path to your script or autorotate --display eDP-1 --daemon
Save and reboot to test
Troubleshooting
If input devices don't rotate correctly, ensure the Coordinate Transformation Matrix is properly applied via xinput set-prop 
Some touchscreens may require specific calibration or naming
On GTK-based desktops like XFCE, using Qt-based tools like ScreenRotator may require additional Qt libraries 
If using ScreenRotator, note that compilation on 32-bit systems may require a patch 
Alternatives
ScreenRotator: Qt-based automatic rotation daemon supporting XFCE, KDE, and others 
Screen Orientation Manager: GUI tool for managing screen orientation with support for multiple DEs including XFCE 
Credits
Based on scripts from mildmojo 
Auto-rotation logic inspired by postmarketOS Wiki 
Utility design influenced by autorotate 
 and ScreenRotator 
