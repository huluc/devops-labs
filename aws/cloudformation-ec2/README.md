# CloudFormation: EC2 Server

Launches an EC2 instance from a CloudFormation template, updates its root
volume size and deletes everything with the stack.

## What I did
1. Wrote a template for an EC2 instance (Amazon Linux 2023, t2.micro, 25 GiB root volume)
2. Created the stack `EC2ServerStack-hilal` in us-east-1
3. Changed `VolumeSize` from 25 to 15 GiB and updated the stack with a change set
4. Deleted the stack, which terminated the instance

## Changes compared to the lab template
- Used a current **Amazon Linux 2023** AMI (Amazon Linux 2 reached end of support in June 2026)
- Removed `KeyName`, no SSH access was needed
- Added a `Name` tag to find the instance in a shared account
- Used a **change set** instead of a direct update to preview the change first

## Key learning: replacement
EBS volumes cannot be shrunk. The change set showed
`Replacement: Conditional` for `BlockDeviceMappings`. During the update,
CloudFormation created a new instance and then deleted the old one:

| | Before | After |
|---|---|---|
| Logical ID | `EC2Server` | `EC2Server` |
| Instance ID | changed | new ID |
| Public IP | changed | new IP |
| Root volume | 25 GiB | 15 GiB (new volume) |

Data on the old instance would have been lost. Change sets make this visible before it happens.

## Screenshots

### Stack created
![Stack created](screenshots/01-stack-create-complete.png)

### Instance running with 25 GiB volume
![EC2 running](screenshots/02-ec2-running-25gb.png)

### Update: new instance after replacement
![Replacement](screenshots/03-update-replacement.png)

### Stack deleted
![Stack deleted](screenshots/04-stack-deleted.png)