#!/bin/bash

# Set Docker registry and image names
REGISTRY=anmolsainihpe

# Build and push first-service
cd first_application
docker build -t $REGISTRY/first-service:latest -f Dockerfile .
docker tag first-service $REGISTRY/first-service:latest
docker push $REGISTRY/first-service:latest

# Navigate to second_application, build, and push Docker image
cd ../second_application
docker build -t $REGISTRY/second-service:latest -f Dockerfile .
docker tag second-service $REGISTRY/second-service:latest
docker push $REGISTRY/second-service:latest

# Navigate back to the root directory
cd ..

# Apply Kubernetes manifests for both applications
kubectl apply -f first-service-deployment.yaml
kubectl apply -f second-service-deployment.yaml

# Get pod names for logging output
FIRST_POD=$(kubectl get pod -l app=first-service -o jsonpath='{.items[0].metadata.name}')
SECOND_POD=$(kubectl get pod -l app=second-service -o jsonpath='{.items[0].metadata.name}')

# Wait for services to become available
sleep 30

# Print responses from both services ( This is not working as curl is not installed in the container)
# echo "First service response:"
# kubectl exec -it $FIRST_POD -- curl http://localhost:5000/api/message


# echo "Second service response:"
# kubectl exec -it $SECOND_POD -- curl http://localhost:5000/api/reverse

#Run below command and hit the browser for both services
#Service 1 : http://localhost:5000/api/message
#Service 2 : http://localhost:5001/api/reverse

# kubectl port-forward svc/first-service 5000:5000
# kubectl port-forward svc/second-service 5001:5000