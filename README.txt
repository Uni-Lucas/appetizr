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
