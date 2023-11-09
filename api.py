import os

from flask import Flask, jsonify
import psycopg2

app = Flask(__name__)

# para obtener el valor de la variable de entorno POSTGRESQL_ADDON_HOST: 
# os.environ.get('POSTGRESQL_ADDON_HOST')


db_config = {
    'host': os.environ.get('POSTGRESQL_ADDON_HOST'),
    'database': os.environ.get('POSTGRESQL_ADDON_DB'),
    'user': os.environ.get('POSTGRESQL_ADDON_USER'),
    'password': os.environ.get('POSTGRESQL_ADDON_PASSWORD'),
    'port': os.environ.get('POSTGRESQL_ADDON_PORT'),
    'options': f'-c search_path=appetizr'  # Buscamos nuestro Schema.
}


def get_data(table):
    # Conexión a la base de datos
    conn = psycopg2.connect(**db_config)
    cursor = conn.cursor()

    # Obtengo el nombre de las columnas de la tabla que estoy consultando.
    cursor.execute(f"SELECT * FROM information_schema.columns WHERE table_name = '{table}';")
    column_names = [row[3] for row in cursor.fetchall()]

    columns_for_query = ', '.join(column_names)

    # Obtengo los datos de la tabla solicitada.
    cursor.execute(f"SELECT {columns_for_query} FROM {table};")
    data = cursor.fetchall()

    # Cerrar la conexión a la base de datos
    cursor.close()
    conn.close()

    # Genero un diccionario con los datos obtenidos.
    result = [ dict(zip(column_names, row)) for row in data ]

    return result

@app.route('/api/restaurants', methods=['GET'])
def get_data_restaurantes():
    return jsonify(get_data('restaurants'))

@app.route('/api/dishes', methods=['GET'])
def get_data_platos():
    return jsonify(get_data('dishes'))


if __name__ == '__main__':
    app.run(debug=True, port=5000)