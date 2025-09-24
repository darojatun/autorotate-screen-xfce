#!/bin/bash

# Auto-Rotate Screen & Touchscreen for Xfce
# Device: Touchscreen detected as ID 9 (SYTS7817:00 06CB:1A24)
# Requires: iio-sensor-proxy, xrandr, xinput, inotify-tools

export DISPLAY=:0

# Logging (untuk debugging)
LOGFILE="/tmp/auto-rotate.log"
exec > "$LOGFILE" 2>&1

echo "[$(date)] Auto-rotate script started"

# Tunggu X dan sensor siap
sleep 5

# === Dapatkan output layar utama ===
get_output() {
    xrandr --query | grep " connected" | head -1 | awk '{print $1}'
}

# === Dapatkan ID touchscreen (spesifik untuk perangkatmu) ===
get_touchscreen() {
    echo "9"  # ID dari 'SYTS7817:00 06CB:1A24' — stabil di sistem kamu
}

# === Terapkan rotasi layar & touchscreen ===
apply_rotation() {
    local orient=$1
    local output=$(get_output)
    local touchid=$(get_touchscreen)

    echo "Applying rotation: $orient (Output: $output, Touch ID: $touchid)"

    case "$orient" in
        "normal"|"bottom-down")
            xrandr --output "$output" --rotation normal
            if [ -n "$touchid" ]; then
                xinput set-prop "$touchid" "Coordinate Transformation Matrix" 1 0 0 0 1 0 0 0 1
                echo "Touch: Normal (1,0,0,0,1,0,0,0,1)"
            fi
            ;;
        "bottom-up")
            xrandr --output "$output" --rotation inverted
            if [ -n "$touchid" ]; then
                xinput set-prop "$touchid" "Coordinate Transformation Matrix" -1 0 1 0 -1 1 0 0 1
                echo "Touch: Inverted (-1,0,1,0,-1,1,0,0,1)"
            fi
            ;;
        "right-up")
            xrandr --output "$output" --rotation right
            if [ -n "$touchid" ]; then
                xinput set-prop "$touchid" "Coordinate Transformation Matrix" 0 1 0 -1 0 1 0 0 1
                echo "Touch: Right (0,1,0,-1,0,1,0,0,1)"
            fi
            ;;
        "left-up")
            xrandr --output "$output" --rotation left
            if [ -n "$touchid" ]; then
                xinput set-prop "$touchid" "Coordinate Transformation Matrix" 0 -1 1 1 0 0 0 0 1
                echo "Touch: Left (0,-1,1,1,0,0,0,0,1)"
            fi
            ;;
        *)
            echo "Unknown orientation: $orient"
            ;;
    esac
}

# === Cek orientasi awal ===
detect_initial() {
    monitor-sensor -i 1 2>/dev/null | head -n 20 | grep "Accelerometer orientation changed" | tail -1 | sed 's/.*changed: //'
}

# Ambil orientasi awal
initial_orient=$(detect_initial)
if [ -n "$initial_orient" ]; then
    echo "Initial orientation: $initial_orient"
    apply_rotation "$initial_orient"
else
    echo "No initial orientation detected, using 'normal'"
    apply_rotation "normal"
fi

# === Loop utama: pantau perubahan orientasi ===
while true; do
    monitor-sensor | grep --line-buffered "Accelerometer orientation changed" | \
    while IFS= read -r line; do
        orientation=$(echo "$line" | sed 's/.*changed: //')
        echo "Detected: $orientation"
        apply_rotation "$orientation"
    done

    # Restart jika monitor-sensor keluar
    echo "monitor-sensor exited. Restarting in 3s..."
    sleep 3
done   
