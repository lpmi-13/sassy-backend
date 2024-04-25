docker build -t sassy-backend .
docker tag sassy-backend localhost:5001/sassy-backend
docker push localhost:5001/sassy-backend
