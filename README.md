# docker

You want to execute this command to create a service principal - this will create a string you need to store as the "creds" secret for Actions:

az ad sp create-for-rbac -n "{ADD YOUR NAME HERE}" --role Contributor --scopes /subscriptions/{subscriptionId} --sdk-auth 

