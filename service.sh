#!/system/bin/sh
> /cache/uwu.log
i=0
while [ -z "$(cmd -l | grep -w "vibrator")" ]; do
    sleep 1
    i=$((i + 1))
    if [ "$i" -gt 30 ]; then
        echo vibrator not found after 30 seconds. Stop > /cache/uwu.log
        exit 1
    fi
done

i=0
while [ "$i" -lt 25 ]; do
    cmd vibrator vibrate 100 >>/cache/uwu.log 2>&1
    sleep 1
    i=$((i + 1))
done
echo uwu >> /cache/uwu.log
