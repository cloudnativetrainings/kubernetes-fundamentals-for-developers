.PHONY: verify
verify:
	test -f /root/.trainingrc
	grep "source /root/.trainingrc" /root/.bashrc
	go version
	docker --version
	kind --version
	kubectl version --client
	kubectx
	kubens
	helm version
	docker pull quay.io/kubermatic-labs/training-application:2.0.0
	docker pull quay.io/kubermatic-labs/training-application:2.0.0-A
	docker pull quay.io/kubermatic-labs/training-application:2.0.0-B
	docker pull quay.io/kubermatic-labs/training-application:2.0.0-distroless
	test -n "$(INGRESS_IP)"
	test -n "$(INGRESS_URL)"
	./pre-checks.sh
	echo "Training Environment successfully verified"
