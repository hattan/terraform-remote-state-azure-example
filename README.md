
## Set up



* Create a storage account to be your terraform state backend. ```az storage account create -n hattantfdemo -g tf_demo_store -l westus --sku Standard_LRS```

* Create a container to host the network state ```az storage container create --name tfdemonetwork --account-name hattantfdemo```

* Retrieve the storage account key:
```az storage account keys list --account-name hattantfdemo```

* Edit the file networking/config/backend-dev.config



