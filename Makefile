SIM_NAME ?= iPhone 16 Plus
ENV_FILE ?= assets/.env
ENV_PROD ?= assets/.env.release

.PHONY: run

run:
	@sim_app=""; \
	for p in "$$(xcode-select -p)/Applications/Simulator.app" \
		/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app \
		/Applications/Xcode-beta.app/Contents/Developer/Applications/Simulator.app \
		/Applications/Simulator.app; do \
		if [ -d "$$p" ]; then sim_app="$$p"; break; fi; \
	done; \
	if [ -n "$$sim_app" ]; then \
		if ! open "$$sim_app"; then \
			echo "Warning: Failed to open Simulator.app (continuing)."; \
		fi; \
	else \
		if ! open -a Simulator; then \
			echo "Warning: Failed to open Simulator.app (continuing)."; \
		fi; \
	fi
	@sim_id=$$(xcrun simctl list devices | awk -v name="$(SIM_NAME)" -F '[()]' '$$0 ~ name {print $$2; exit}'); \
	if [ -z "$$sim_id" ]; then \
		echo "No simulator found for $(SIM_NAME)."; \
		exit 1; \
	fi; \
	xcrun simctl shutdown all >/dev/null 2>&1 || true; \
	xcrun simctl boot "$$sim_id" || true; \
	if ! xcrun simctl list devices | grep -q "$$sim_id.*Booted"; then \
		echo "Failed to boot simulator for $(SIM_NAME)."; \
		exit 1; \
	fi; \
	flutter run -d "$$sim_id"

.PHONY: ios-prod-upload upload-ios-testflight

ios-prod-upload: upload-ios-testflight

upload-ios-testflight:
	@bash -lc 'set -euo pipefail; \
	if [ ! -f "$(ENV_PROD)" ]; then \
		echo "Missing $(ENV_PROD)."; \
		exit 1; \
	fi; \
	bundle_bin="bundle"; \
	if [ -x "$$HOME/.gem/ruby/3.2.0/bin/bundle" ]; then bundle_bin="$$HOME/.gem/ruby/3.2.0/bin/bundle"; fi; \
	if command -v mktemp >/dev/null 2>&1; then backup="$$(mktemp)"; else backup="/tmp/env.backup.$$"; fi; \
	if [ -f "$(ENV_FILE)" ]; then cp "$(ENV_FILE)" "$$backup"; else backup=""; fi; \
	cp "$(ENV_PROD)" "$(ENV_FILE)"; \
	flutter build ipa; \
	ipa_rel="$$(ls -t build/ios/ipa/*.ipa | head -n1)"; \
	ipa_path="$$(pwd)/$$ipa_rel"; \
	if [ -z "$$ipa_path" ]; then echo "No IPA found under build/ios/ipa"; exit 1; fi; \
	set -a; . "$(ENV_PROD)"; set +a; \
	( cd ios && "$$bundle_bin" exec fastlane ios upload ipa_path:"$$ipa_path" ); \
	if [ -n "$$backup" ] && [ -f "$$backup" ]; then mv "$$backup" "$(ENV_FILE)"; else rm -f "$(ENV_FILE)"; fi'
