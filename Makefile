.PHONY: all init migrate plan apply destroy clean

RESG = xantara-it-rg
STOR = xantaraitsz5l0cpd

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

plan:
	terraform plan -out .tfplan

apply: .tfplan
	terraform apply .tfplan

destroy:
	terraform destroy

clean:
	rm -f .tfplan

id_rsa: .tfplan
	terraform output -raw tls_private_key > id_rsa
	chmod 600 id_rsa

all: init plan apply id_rsa
