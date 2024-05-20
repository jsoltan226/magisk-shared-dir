#!/system/bin/sh

i=0
while [ "$i" -lt 25 ]; do
    cmd vibrator vibrate 100 >>/cache/uwu.log 2>&1
    sleep 1
    i=$((i + 1))
done
echo uwu >> /cache/uwu.log
