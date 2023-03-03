.PHONY: all init migrate plan apply destroy clean

RESG = xantara-it-rg
STOR = xantaraitsz5l0cpd
COUNT = 0

all: init plan apply id_rsa

init:
	terraform init \
	  -backend-config="resource_group_name=$(RESG)" \
	  -backend-config="storage_account_name=$(STOR)" \
	  -upgrade

migrate:
	terraform init \
	  -backend-config="resource_group_name=$(RESG)" \
	  -backend-config="storage_account_name=$(STOR)" \
	  -upgrade \
	  -migrate-state

plan: rhsm.tfvars
	terraform plan -var-file=rhsm.tfvars -var=linux_vm_count=$(COUNT) -out .tfplan

apply:
	terraform apply .tfplan

destroy:
	terraform destroy

clean:
	rm -f .tfplan

id_rsa: .tfplan
	terraform output -raw tls_private_key > id_rsa
	chmod 600 id_rsa

