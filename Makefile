SIM_NAME ?= iPhone 16 Plus

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
