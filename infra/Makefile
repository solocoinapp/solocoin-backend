.PHONY: tf.init tf.plan tf.apply

RESOURCE="Solocoin App"

tf.init:
	@echo "Initializing ${RESOURCE} configuration"
	@cd tf/remotestate && $(MAKE) tf.init
	@cd tf/vpc && $(MAKE) tf.init
	@cd tf/asg && $(MAKE) tf.init
	@cd tf/redis && $(MAKE) tf.init

tf.plan:
	@echo "Plan ${RESOURCE} configuration"
	@cd tf/remotestate && $(MAKE) tf.plan
	@cd tf/vpc && $(MAKE) tf.plan
	@cd tf/asg && $(MAKE) tf.plan
	@cd tf/redis && $(MAKE) tf.plan

tf.apply:
	@echo "Applying ${RESOURCE} configuration"
	@cd tf/remotestate && $(MAKE) tf.apply
	@cd tf/vpc && $(MAKE) tf.apply
	@cd tf/asg && $(MAKE) tf.apply
	@cd tf/redis && $(MAKE) tf.apply
