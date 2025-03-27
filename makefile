.PHONY: verify
verify:
	go version
	docker --version
	kind --version
	kubectl version --client
	helm version
	docker pull quay.io/kubermatic-labs/training-application:2.0.0
	docker pull quay.io/kubermatic-labs/training-application:2.0.0-A
	docker pull quay.io/kubermatic-labs/training-application:2.0.0-B
	docker pull quay.io/kubermatic-labs/training-application:2.0.0-distroless
	test -n "$(INGRESS_IP)"
	test -n "$(INGRESS_URL)"
	echo "Training Environment successfully verified"

.PHONY: verify-cluster
verify-cluster: 
	./pre-checks.sh
