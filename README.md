# HOW TO

This is the simplest possible workflow to deploy to aws using terraform and gha.

Before you can use this workflow, you need to set up these GitHub Secrets:

	▪	AWS_ACCESS_KEY_ID
	▪	AWS_SECRET_ACCESS_KEY
To use this example:

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

After deployment, you can access your Hello World server at:

http://<EC2_PUBLIC_IP>:8080

# IMPORTANT
To destroy the infrastructure, run terraform destroy locally.
