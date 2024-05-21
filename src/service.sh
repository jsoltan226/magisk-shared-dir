#!/system/bin/sh
> /cache/uwu.log
i=0
wait_duration=1
while [ "$(getprop sys.user.0.ce_available)" != 'true' ]; do
    sleep "$wait_duration"
    i=$((i + 1))
    if [ "$i" -gt 100 ] && [ "$wait_duration" -eq 1 ]; then
        echo "data not decrypted after 100 seconds." >> /cache/uwu.log
        echo "entering long wait mode." >> /cache/uwu.log
        wait_duration=10
    fi
done

echo "CE data unlocked!" >> /cache/uwu.log

i=0
while [ "$i" -lt 25 ]; do
    cmd vibrator vibrate 100 >>/cache/uwu.log 2>&1
    sleep 1
    i=$((i + 1))
done
echo uwu >> /cache/uwu.log
