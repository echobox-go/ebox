SCRIPTS = bin/ebox enrol.sh

.PHONY: test shellcheck package
test: shellcheck
	bash -n bin/ebox
	EBOX_CONF=etc/ebox.conf.example EBOX_STATE_DIR=$$(mktemp -d) bin/ebox status >/dev/null

shellcheck:
	shellcheck -x $(SCRIPTS)

package:
	cd packaging && makepkg -sf
