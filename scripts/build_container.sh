docker build -t sassy-backend .
docker tag sassy-backend localhost:5001/sassy-backend
docker push localhost:5001/sassy-backend

docker build -t sassy-backend-db-seed -f db-seed/Dockerfile db-seed/
docker tag sassy-backend-db-seed localhost:5001/sassy-backend-db-seed
docker push localhost:5001/sassy-backend-db-seed
