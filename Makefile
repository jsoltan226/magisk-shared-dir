SRCDIR=src
OUT_ZIP=test.zip

SINKHOLE?=/dev/null

RM?=rm -f
ZIP?=zip -r
CD?=cd
MV?=mv
SUDO?=sudo
MAGISK?=magisk64
ECHO?=echo
PRINTF?=printf
REBOOT?=sleep 1 && su -c reboot

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

install:
	@$(PRINTF) "%-14s %-10s\n" "MAGISKINSTALL" "$(OUT_ZIP)"
	@$(SUDO) $(MAGISK) --install-module $(OUT_ZIP) >$(SINKHOLE)

reboot:
	@$(ECHO) "REBOOT"
	@$(REBOOT)

br: clean build install reboot
