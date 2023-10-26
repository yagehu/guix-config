.PHONY: reconfigure-home
reconfigure-home: home-configuration.scm
	GUIX_PACKAGE_PATH="modules:$$GUIX_PACKAGE_PATH" \
		guix home reconfigure home-configuration.scm

.PHONY: home-extension-graph
home-extension-graph:
	GUIX_PACKAGE_PATH="modules:$$GUIX_PACKAGE_PATH" \
		guix home extension-graph home-configuration.scm | xdot -
