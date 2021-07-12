#!/bin/bash

random=$(openssl rand -base64 6)
currentlabel=$(cat prod-label.txt)

##Latest Version can be found at this file after the deployment.
# echo $random > version.txt
sed "s/{version}/$random/g" base/makefile > makefile

## Build the docker image with updated code, tag the image and push it to ECR.
make ver=$random docker-all


#Green Deployment will updated in base folder.

greendeployment() { 

sed "s/{version}/$random/g" base/deployment.yaml > green-deploy/deployment.yaml
sed "s/{version}/$random/g" base/service.yaml > green-deploy/service.yaml

cd green-deploy
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
} 

green-rollback(){
    kubectl delete -f green-deploy/service.yaml 
    kubectl delete -f green-deploy/deployment.yaml
}

green-prod-push() { 

## Backup of both Services Files
cp prod-deploy/service.yaml  prod-deploy/service.yaml_bkp
cp green-deploy/service.yaml green-deploy/service.yaml_bkp 

# Update Prod Service label to point to Green Deployment
sed -i '' "s/$currentlabel/app: app-$random/" prod-deploy/service.yaml
sed -i '' "s/app: app-$random/$currentlabel/" green-deploy/service.yaml

kubectl apply -f prod-deploy/service.yaml
kubectl apply -f green-deploy/service.yaml

} 

greenrolling() {
    kubectl delete -f green-deploy/service.yaml 
    kubectl delete -f prod-deploy/deployment.yaml
    sed -i '' "s/$currentlabel/app: app-$random/" prod-label.txt
    echo $random > version.txt
}

greenrollback(){
cp prod-deploy/service.yaml_bkp prod-deploy/service.yaml
cp green-deploy/service.yaml_bkp green-deploy/service.yaml

kubectl apply -f prod-deploy/service.yaml
kubectl apply -f green-deploy/service.yaml

#Destroy Green Deployment
kubectl delete -f green-deploy/service.yaml 
kubectl delete -f green-deploy/deployment.yaml

}

# var=randomkjfd
# sed  "s/app: app/app: app-$var/" prod-service.txt


echo "Type of Deployment: First or BlueGreen"
read deployment

### To Do first or Bluegreen Deployment

case $deployment in 
    "First")  
    echo "This is first Deployment" 
    cd prod-deploy/
    sed -i '' "s/{version}/$random/" deployment.yaml
    kubectl apply -f namespace.yaml
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml

    echo $random > ../version.txt
    ;; 
    "BlueGreen")
    echo "This is BlueGreen"
    greendeployment   ##Calling Function to perform Blue Green Deployment

    read -p "Test of Green Env is working: 0 or 1:  " result
    echo $result
    if [ $result -eq 0 ];then green-prod-push; else green-rollback; fi 
    # if [ $result -gt 0 ];then echo "Success"; else echo "Fail"; fi

    read -p "Testing result of prod/Blue Env: 0 or 1:  " prod_result
    if [ $prod_result -gt 0 ];then greenrolling; else greenrollback; fi
    ;;
    *)
    echo "Please enter one of two option:
        First
        BlueGreen"
    ;;
esac 
