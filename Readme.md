# Example model deployment

## Model Deploy local

Test endpoint model in local:
```bash
poetry run python serve_model.py
```


```bash
curl -X POST "http://127.0.0.1:8000/predict" \
     -H "Content-Type: application/json"   \
     -d '{"input": [5.1, 3.5, 1.4, 0.2]}'
```

## Model Deploy Docker Image

Build, execute and test docker image:

```bash
docker build -t iris_model_image .
docker run -d -p 8000:8000 iris_model_image
```
```bash
curl -X POST "http://localhost:8000/predict" \
     -H "Content-Type: application/json"   \
     -d '{"input": [5.1, 3.5, 1.4, 0.2]}'
```

## Push the Docker image to Azure Container Registry

Create azure container registry and login
```bash
az acr create \
    --resource-group rg-leo-eastUS-general \
    --name mlexample \
    --sku Basic

az acr login --name mlexample
```

Push image and view credentials
```bash
docker tag iris_model_image mlexample.azurecr.io/iris_model_image:v1
docker push mlexample.azurecr.io/iris_model_image:v1
az acr update -n mlexample --admin-enabled true
az acr credential show --name mlexample
```

Create container instance
```bash
az container create \
  --resource-group rg-leo-eastUS-general \
  --name iris-model-container \
  --image mlexample.azurecr.io/iris_model_image:v1 \
  --dns-name-label irismodel \
  --ports 8000 \
  --os-type Linux \
  --cpu 1 \
  --memory 2 \
  --registry-login-server mlexample.azurecr.io \
  --registry-username mlexample \
  --registry-password <pass-of-yout-acr-image>
```

Test Endpoint Azure
```bash
curl -X POST \
  "http://iris-model-container.b0ahaxhzenawg6ca.eastus.azurecontainer.io:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{"input": [5.1, 3.5, 1.4, 0.2]}'
```

url public container instances:
http://iris-model-container.b0ahaxhzenawg6ca.eastus.azurecontainer.io:8000/predict