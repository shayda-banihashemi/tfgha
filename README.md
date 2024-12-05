# HOW TO

This is the simplest possible workflow to deploy to aws using terraform and gha.

Before you can use this workflow, you need to set up these GitHub Secrets:

	▪	AWS_ACCESS_KEY_ID
	▪	AWS_SECRET_ACCESS_KEY
To use this example:
Get an instance id:
```aiignore
aws ec2 describe-images \
    --owners amazon \
    --filters "Name=name,Values=al2023-ami-*" "Name=architecture,Values=x86_64" \
    --query "sort_by(Images, &CreationDate)[-1].ImageId" \
    --output text
```
	1.	Create a new GitHub repository
	1.	Add the files as shown above
    1.  Add this to gha yml files:
                ```
                - name: Terraform Plan
                run: terraform plan
                working-directory: terraform
                ```
	1.	Add your AWS credentials as GitHub Secrets
    1. run `aws sts get-caller-identity`
	1.	Push the code to the main branch
The workflow will:

	1.	Trigger when you push to the main branch
	2.	Initialize Terraform
	3.	Check the formatting
	4.	Create a plan
	5.	Apply the infrastructure changes

# IMPORTANT
To destroy the infrastructure when deploying manually (not via action), run terraform destroy locally.

Steps to be defined later in a video. now works remote and autodeletes

CARE WHERE YOU PUT SECRETS - MUST BE IN GitHub REPO settings (not env)

eg: https://github.com/proquickly/<your-repo-name>/settings/secrets/actions

get your aws keys from your account:
https://us-east-1.console.aws.amazon.com/iam/home?region=<your-region>#/users/details/<your-user-name>?section=permissions

this now runs locally - updated aws config


Add your PUBLIC ssh key ONLY to the terraform directory and the main.tf will use it to login to the EC2 instance interactively from local laptop. ss ubuntu@ipaddress
as usual.

Now that poetry is used for python this will deploy any python project that
is setup correctly with poetry.

TODO: install the project as a module with poetry build and pip or poetry install from the dist dir whl file.

Also note that the dealy in deployment during the time the EC2 instance is up is caused by the time it takes to clone the github repo.
