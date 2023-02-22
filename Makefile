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

plan-cmk:
	terraform plan -out .tfplan \
	  -var linux_vm_image_id=/subscriptions/e66b35da-90dd-4119-847f-645ae35f58ce/resourceGroups/XANTARA-IT-RG/providers/Microsoft.Compute/images/xan-cmk-demo

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
