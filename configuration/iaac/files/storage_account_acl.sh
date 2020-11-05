#!/bin/bash
#https://github.com/Azure/azure-cli-extensions/blob/master/src/storage-preview/README.md

az config set extension.use_dynamic_install=yes_without_prompt
az extension add --upgrade -n storage-preview

az storage fs access set --permissions "rwxrw-rw-" -f $AZURE_STORAGE_CONTAINER -p $INPUTS_PATH  --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_KEY --auth-mode $AZURE_STORAGE_AUTH_MODE
az storage fs access set --permissions "rwxrw-rw-" -f $AZURE_STORAGE_CONTAINER -p $INPUTS_PATH/$INPUT_FILE --account-name $AZURE_STORAGE_ACCOUNT  --account-key $AZURE_STORAGE_KEY --auth-mode $AZURE_STORAGE_AUTH_MODE

az storage fs directory create --file-system $AZURE_STORAGE_CONTAINER --name $OUTPUTS_PATH --account-name $AZURE_STORAGE_ACCOUNT --permissions "rwxrw-rw-"  --account-key $AZURE_STORAGE_KEY --auth-mode $AZURE_STORAGE_AUTH_MODE
az storage fs directory create --file-system $AZURE_STORAGE_CONTAINER --name $OUTPUTS_PATH --account-name $AZURE_STORAGE_ACCOUNT --permissions "rwxrw-rw-"  --account-key $AZURE_STORAGE_KEY --auth-mode $AZURE_STORAGE_AUTH_MODE
