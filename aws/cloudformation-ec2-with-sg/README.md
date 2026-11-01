# CloudFormation: EC2 with Security Group

Deploys an EC2 instance together with its own security group.

## What this template shows
- **Parameters:** the key pair name is asked when the stack is created
- **Two resources:** a security group (SSH 22, HTTP 80) and an EC2 instance
- **!GetAtt:** the instance uses the ID of the security group created in the same template
- **Outputs:** the instance ID is shown after deployment

## Note
SSH is open to `0.0.0.0/0` for lab purposes only.
In production, SSH should be restricted to known IP ranges or replaced by SSM Session Manager.