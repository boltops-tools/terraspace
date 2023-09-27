## Examples

    terraspace untaint ec2 aws_instance.my_instance

Example with output:

	$ terraspace taint ec2 aws_instance.my_instance
	Building .terraspace-cache/us-east-1/dev/stacks/ec2
	Hook: Running terraspace before build hook.
	Current directory: .terraspace-cache/us-east-1/dev/stacks/ec2
	 => terraform untaint aws_instance.my_instance
	Resource instance aws_instance.my_instance has been successfully untainted.
	Releasing state lock. This may take a few moments...
