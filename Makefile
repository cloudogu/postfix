MAKEFILES_VERSION=10.7.0

.DEFAULT_GOAL:=dogu-release

include build/make/variables.mk
include build/make/self-update.mk
include build/make/release.mk
include build/make/k8s-dogu.mk
include build/make/prerelease.mk

K8S_COMPONENT_SOURCE_VALUES = ${HELM_SOURCE_DIR}/values.yaml
K8S_COMPONENT_TARGET_VALUES = ${HELM_TARGET_DIR}/values.yaml
HELM_PRE_GENERATE_TARGETS = helm-values-update-image-version $(HELM_DOGU_SPEC)
HELM_POST_GENERATE_TARGETS = helm-values-replace-image-repo template-log-level template-image-pull-policy
CHECK_VAR_TARGETS=check-all-vars
IMAGE_IMPORT_TARGET=image-import

HELM_DOGU_SPEC=$(HELM_SOURCE_DIR)/dogu.json

include build/make/k8s-component.mk

.PHONY copy-dogu-spec:
copy-dogu-spec: $(HELM_DOGU_SPEC)

$(HELM_DOGU_SPEC): dogu.json
	@cp dogu.json k8s/helm

.PHONY: helm-values-update-image-version
helm-values-update-image-version: $(BINARY_YQ)
	@echo "Updating the image version in source values.yaml to ${VERSION}..."
	@$(BINARY_YQ) -i e ".containers.postfix.image.tag = \"${VERSION}\"" ${K8S_COMPONENT_SOURCE_VALUES}

.PHONY: helm-values-replace-image-repo
helm-values-replace-image-repo: $(BINARY_YQ)
	@if [[ ${STAGE} == "development" ]]; then \
      		echo "Setting dev image repo in target values.yaml!" ;\
    		$(BINARY_YQ) -i e ".containers.postfix.image.registry=\"$(shell echo '${IMAGE_DEV}' | sed 's/\([^\/]*\)\/\(.*\)/\1/')\"" ${K8S_COMPONENT_TARGET_VALUES} ;\
    		$(BINARY_YQ) -i e ".containers.postfix.image.repository=\"$(shell echo '${IMAGE_DEV}' | sed 's/\([^\/]*\)\/\(.*\)/\2/')\"" ${K8S_COMPONENT_TARGET_VALUES} ;\
    	fi

.PHONY: template-log-level
template-log-level: ${BINARY_YQ}
	@if [[ "${STAGE}" == "development" ]]; then \
      echo "Setting LOG_LEVEL env in deployment to ${LOG_LEVEL}!" ; \
      $(BINARY_YQ) -i e ".configuration.normal.logging.root=\"${LOG_LEVEL}\"" "${K8S_COMPONENT_TARGET_VALUES}" ; \
    fi

.PHONY: template-image-pull-policy
template-image-pull-policy: $(BINARY_YQ)
	@if [[ "${STAGE}" == "development" ]]; then \
          echo "Setting pull policy to always!" ; \
          $(BINARY_YQ) -i e ".containers.postfix.imagePullPolicy=\"Always\"" "${K8S_COMPONENT_TARGET_VALUES}" ; \
    fi
