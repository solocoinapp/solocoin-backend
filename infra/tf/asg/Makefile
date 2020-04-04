.PHONY: tf.init tf.plan tf.apply

RESOURCE="Auto Scaling Group"

tf.init:
	@echo "Initializing ${RESOURCE} configuration"
	terraform init

tf.plan:
	@echo "Plan ${RESOURCE} configuration"
	terraform plan

tf.apply:
	echo "Applying ${RESOURCE} configuration"
	terraform apply -auto-approve
