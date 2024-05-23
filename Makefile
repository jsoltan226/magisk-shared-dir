SRCDIR=src
OUT_ZIP=test.zip

PLATFORM?=$(shell [ "$$(uname -o)" = 'Android' ] && echo "Android" && exit; [ "$$(uname -o)" = 'GNU/Linux' ] && echo "Linux" && exit; echo "N/A" )

SINKHOLE?=/dev/null
ifeq "$(PLATFORM)" "Linux"
ANDROID_TMPDIR?=/data/local/tmp
endif
ifeq "$(PLATFORM)" "Android"
TMPDIR?=/data/local/tmp
endif

RM?=rm -f
ZIP?=zip -r
CD?=cd
MV?=mv
SUDO?=sudo
MAGISK?=magisk64
ECHO?=echo
PRINTF?=printf
REBOOT?=sleep 1 && su -c reboot
ADB?=adb
ADB_SHELL?=adb shell

.NOTPARALLEL: all br
.PHONY: all build install clean reboot br

all: clean build install

build:
	@$(PRINTF) "%-14s %-10s %-20s\n" "ZIP" "$(SRCDIR)/$(OUT_ZIP)" "<= $(SRCDIR)"
	@$(CD) $(SRCDIR) && $(ZIP) $(OUT_ZIP) . >$(SINKHOLE) 
	@$(PRINTF) "%-14s %-10s %-20s\n" "MV" "$(SRCDIR)/$(OUT_ZIP)" "=> ./$(OUT_ZIP)"
	@$(MV) $(SRCDIR)/$(OUT_ZIP) .

clean:
	@$(PRINTF) "%-14s %-10s\n" "RM" "$(OUT_ZIP)"
	@$(RM) $(OUT_ZIP)

ifeq "$(PLATFORM)" "Android"
install:
	@$(PRINTF) "%-14s %-10s\n" "MAGISKINSTALL" "$(OUT_ZIP)"
	@$(SUDO) $(MAGISK) --install-module $(OUT_ZIP) >$(SINKHOLE) PATH=\"/debug_ramdisk:/sbin:$PATH\"

reboot:
	@$(ECHO) "REBOOT"
	@$(REBOOT)

endif
ifeq "$(PLATFORM)" "Linux"
install:
	@$(ADB) devices | grep -qw device || { \
		$(ECHO) "No adb devices found; cannot make INSTALL. Stop."; \
		exit 1; \
	}
	@$(PRINTF) "%-14s %-10s\n" "ADB INSTALL" "$(OUT_ZIP)"
	@$(ADB) push $(OUT_ZIP) $(ANDROID_TMPDIR) >$(SINKHOLE)
	@$(ADB_SHELL) su -c "PATH=\"/debug_ramdisk:/sbin:$PATH\" $(MAGISK) --install-module $(ANDROID_TMPDIR)/$(OUT_ZIP) >$(SINKHOLE)"
	@$(ADB_SHELL) rm "$(ANDROID_TMPDIR)/$(OUT_ZIP)" >$(SINKHOLE)

reboot:
	@$(ECHO) "ADB REBOOT"
	@$(ADB) reboot
endif
ifeq "$(PLATFORM)" "N/A"
install:
	@$(ECHO) "INSTALL target is not supported on unknown platform."

reboot:
	@$(ECHO) "REBOOT target is not supported on unknown platform."
endif


br: clean build install reboot
