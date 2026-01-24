SIM_NAME ?= iPhone 16 Plus
ENV_FILE ?= assets/.env
ENV_PROD ?= assets/.env.production

.PHONY: run

run:
	open -a Simulator
	@xcrun simctl boot "$(SIM_NAME)" || true
	@booted_id=$$(xcrun simctl list devices | grep Booted | awk -F '[()]' '{print $$2}' | head -n1); \
	if [ -z "$$booted_id" ]; then \
		echo "No booted simulator found for $(SIM_NAME)."; \
		exit 1; \
	fi; \
	flutter run -d "$$booted_id"

.PHONY: ios-prod-upload

ios-prod-upload:
	@bash -lc 'set -euo pipefail; \
	if [ ! -f "$(ENV_PROD)" ]; then \
		echo "Missing $(ENV_PROD)."; \
		exit 1; \
	fi; \
	if command -v mktemp >/dev/null 2>&1; then backup="$$(mktemp)"; else backup="/tmp/env.backup.$$"; fi; \
	if [ -f "$(ENV_FILE)" ]; then cp "$(ENV_FILE)" "$$backup"; else backup=""; fi; \
	cp "$(ENV_PROD)" "$(ENV_FILE)"; \
	flutter build ipa; \
	ipa_path="$$(ls -t build/ios/ipa/*.ipa | head -n1)"; \
	if [ -z "$$ipa_path" ]; then echo "No IPA found under build/ios/ipa"; exit 1; fi; \
	( cd ios && bundle exec fastlane ios upload ipa_path:"$$ipa_path" ); \
	if [ -n "$$backup" ] && [ -f "$$backup" ]; then mv "$$backup" "$(ENV_FILE)"; else rm -f "$(ENV_FILE)"; fi'
