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

all: init plan apply
