BUILD_DIR         := .build/arm64-apple-macosx/release
SAVER_SUPPORT     := Support/A2DClockSaver
APP_SUPPORT       := Support/A2DClock
DIST_DIR          := dist
SAVER_BUNDLE      := $(DIST_DIR)/A2DClock.saver
APP_BUNDLE        := $(DIST_DIR)/A2DClock.app
RELEASE_ZIP       := $(DIST_DIR)/A2DClock.zip
SCREEN_SAVERS_DIR := $(HOME)/Library/Screen\ Savers

.PHONY: all saver app release install uninstall clean

all: app

# ── Compile ──────────────────────────────────────────────────────────────────

$(BUILD_DIR)/.build-stamp: Package.swift $(shell find Sources -name '*.swift')
	swift build -c release
	@touch $(BUILD_DIR)/.build-stamp

# ── .saver bundle ────────────────────────────────────────────────────────────

saver: $(BUILD_DIR)/.build-stamp
	@rm -rf $(SAVER_BUNDLE)
	@mkdir -p $(SAVER_BUNDLE)/Contents/MacOS
	@cp $(SAVER_SUPPORT)/Info.plist $(SAVER_BUNDLE)/Contents/Info.plist
	@swiftc \
		-target arm64-apple-macosx13.0 \
		-Xlinker -bundle \
		$(BUILD_DIR)/A2DClockSaver.build/A2DClockSaverView.swift.o \
		$(BUILD_DIR)/libA2DClockCore.a \
		$(BUILD_DIR)/libA2DClockSurface.a \
		-framework ScreenSaver \
		-framework AppKit \
		-framework SwiftUI \
		-o $(SAVER_BUNDLE)/Contents/MacOS/A2DClockSaver
	@xattr -cr $(SAVER_BUNDLE)
	@codesign --force --sign - $(SAVER_BUNDLE)
	@echo "Built $(SAVER_BUNDLE)"

# ── .app bundle ───────────────────────────────────────────────────────────────

app: saver
	@rm -rf $(APP_BUNDLE)
	@mkdir -p $(APP_BUNDLE)/Contents/MacOS
	@mkdir -p $(APP_BUNDLE)/Contents/Resources
	@cp $(APP_SUPPORT)/Info.plist $(APP_BUNDLE)/Contents/Info.plist
	@cp $(BUILD_DIR)/A2DClock $(APP_BUNDLE)/Contents/MacOS/A2DClock
	@cp -R $(SAVER_BUNDLE) $(APP_BUNDLE)/Contents/Resources/A2DClock.saver
	@xattr -cr $(APP_BUNDLE)
	@codesign --force --sign - $(APP_BUNDLE)
	@echo "Built $(APP_BUNDLE)"

# ── Local install (for testing) ───────────────────────────────────────────────

install: saver
	@rm -rf $(SCREEN_SAVERS_DIR)/A2DClock.saver
	@cp -R $(SAVER_BUNDLE) $(SCREEN_SAVERS_DIR)/A2DClock.saver
	@echo "Installed to ~/Library/Screen Savers/A2DClock.saver"
	@echo "Open System Settings → Screen Saver to activate"

uninstall:
	@rm -rf $(SCREEN_SAVERS_DIR)/A2DClock.saver
	@echo "Removed ~/Library/Screen Savers/A2DClock.saver"

# ── Release zip ───────────────────────────────────────────────────────────────

release: app
	@rm -f $(RELEASE_ZIP)
	@ditto -c -k --keepParent $(APP_BUNDLE) $(RELEASE_ZIP)
	@echo "Release package: $(RELEASE_ZIP)"

# ── Clean ─────────────────────────────────────────────────────────────────────

clean:
	@swift package clean
	@rm -rf $(DIST_DIR)
	@echo "Cleaned"
