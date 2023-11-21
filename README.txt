--------- DEPENDENCIES (for Ubuntu) ---------
Postgres client

sudo apt install postgresql-client

--------- INSTALL --------


bundle install

for the API REST

cd api
source bin/activate{.<your_shell>}
pip install -r requirements.txt

--------- RUN SERVER -----
Declarar variables de entorno de la BD

source export_vars.sh
bin/rails server

---------- RUN WITH DOCKER ----------

docker build \
  --build-arg DB_HOST=$POSTGRESQL_ADDON_HOST \
  --build-arg DB_USER=$POSTGRESQL_ADDON_USER \
  --build-arg DB_NAME=$POSTGRESQL_ADDON_DB \
  --build-arg DB_PASSWORD=$POSTGRESQL_ADDON_PASSWORD \
  --build-arg DB_PORT=$POSTGRESQL_ADDON_PORT \
  -t appetizr .

docker run --network host -d --name appetizr appetizr
