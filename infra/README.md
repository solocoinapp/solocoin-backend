# SoloCoin  Backend Infrastructure

This folder contains configuration managament code for the application

## Usage

In order to provision these resources you need to have AWS access keys for a user with permission to create the resources.

```
# export the following environment variables before running terraform
AWS_DEFAULT_REGION=ap-south-1
AWS_SECRET_ACCESS_KEY=xxxxx
AWS_ACCESS_KEY_ID=xxxxx
```

### Complete Resource Creation
```
make tf.init
make tf.plan
# STOP! make sure you want to create these resources
# The next step runs terraform apply -auto-approve which doesn't ask for confirmation

# Once confirmed, run
make tf.apply
```

### Single Resource Creation
```
cd infra/tf/redis

#initialize and init terraform
make tf.init

#plan changes
make tf.plan

#apply changes
make tf.apply
```

## Resources
The following resources are managed by this configuration:
- Autoscaling Group
- VPC
- Redis Instance

## TODO
- [ ] run terraform through CI
