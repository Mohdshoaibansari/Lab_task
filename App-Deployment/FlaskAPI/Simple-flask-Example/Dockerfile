FROM python:alpine3.7 
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt 
# EXPOSE 5000
# ENTRYPOINT [ "python" ] 
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0"]


#aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 070814490905.dkr.ecr.eu-central-1.amazonaws.com
#docker tag flask-app:v1.0.0 070814490905.dkr.ecr.eu-central-1.amazonaws.com/eks-repo:flask.1.0.0
#docker push 070814490905.dkr.ecr.eu-central-1.amazonaws.com/eks-repo:flask.1.0.0