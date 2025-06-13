##@ Makefile management

.PHONY: update-makefiles
update-makefiles: do-update-makefiles ## Update Makefiles to MAKEFILES_VERSION

.PHONY: do-update-makefiles
do-update-makefiles: $(TMP_DIR) download-and-extract remove-old-files copy-new-files
	@echo Updating makefiles...

.PHONY: download-and-extract
download-and-extract:
	@curl -L --silent https://github.com/cloudogu/makefiles/archive/v$(MAKEFILES_VERSION).tar.gz > $(TMP_DIR)/makefiles-v$(MAKEFILES_VERSION).tar.gz
	@tar -xzf $(TMP_DIR)/makefiles-v$(MAKEFILES_VERSION).tar.gz -C $(TMP_DIR)

.PHONY: remove-old-files
remove-old-files:
	@echo "Deleting old files"
	rm -rf $(BUILD_DIR)/make

.PHONY: copy-new-files
copy-new-files:
	@cp -r $(TMP_DIR)/makefiles-$(MAKEFILES_VERSION)/build/make $(BUILD_DIR)

.PHONY: update-build-libs
update-build-libs:
	@echo "Check for newer Build-Lib versions"
	build/make/self-update.sh buildlibs

.PHONY: set-dogu-version
set-dogu-version:
	@echo "Set Version of Dogu without Release"
	build/make/self-update.sh versions