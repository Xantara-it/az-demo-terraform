.PHONY: init migrate plan apply destroy clean

CERT = /etc/easy-rsa/pki/ca.crt
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
	terraform plan -out .plan
apply: .plan
	terraform apply .plan
destroy:
	terraform destroy

clean:
	rm -f .plan
