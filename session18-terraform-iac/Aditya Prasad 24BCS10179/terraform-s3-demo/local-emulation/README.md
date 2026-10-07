# Local AWS API emulation

No AWS resources. Moto's EC2/VPC/SG are mocked records, not real servers or networks.

Start Moto on 127.0.0.1:5000 with the pinned requirements. Use only this directory and `-var-file=local.tfvars.json`. All provider endpoints are localhost and credentials are dummy `testing` values. Terraform 1.16.5 and AWS provider version from `.terraform.lock.hcl` were used. For Session19, first register a mocked image in Moto matching the local tfvars AMI ID or update that variable to the generated mock image ID.

See `run-local.py` for the exact repeatable workflow including image setup, object round-trip verification, cleanup and API checks. It starts/stops its own Moto server. Do not run another server on port 5000. Install Terraform on PATH first.
