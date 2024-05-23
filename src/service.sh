#!/system/bin/sh
LOGFILE=/cache/uwu.log
> $LOGFILE

log() {
    echo "$*" >>$LOGFILE
}

error() {
    code="$1"
    shift 1
    log "ERROR:" "$*"
    log "Stop."
    [ "$code" -ne 0 ] && exit "$code"
}

BINDFS=/system/bin/bindfs
[ -x "$BINDFS" ] || error 1 "Could not find bindfs binary"

# Wait for first unlock
FIRSTUNLOCK_PROP='sys.user.0.ce_available'
i=0
wait_duration=1
while [ "$(getprop "$FIRSTUNLOCK_PROP")" != 'true' ]; do
    sleep "$wait_duration"
    i=$((i + 1))
    if [ "$i" -gt 100 ] && [ "$wait_duration" -eq 1 ]; then
        log "data not decrypted after 100 seconds."
        log "entering long wait mode."
        wait_duration=10
    fi
done

log "CE data unlocked!"

user_list="$(pm list users)"
log "user_list: $user_list"

i=0
while [ "$i" -lt 5 ]; do
    cmd vibrator vibrate 100 >>$LOGFILE
    sleep 1
    i=$((i + 1))
done
log uwu
