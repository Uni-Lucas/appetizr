from flask import Flask, jsonify
import psycopg2
import os


app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        user=os.environ.get('POSTGRESQL_ADDON_USER'),
        host=os.environ.get('POSTGRESQL_ADDON_HOST'),
        password=os.environ.get('POSTGRESQL_ADDON_PASSWORD'),
        port=os.environ.get('POSTGRESQL_ADDON_PORT'),
        database=os.environ.get('POSTGRESQL_ADDON_DB')
    )


@app.route('/reviews/restaurants/<nombre>/<telefono>', methods=['GET'])
def get_restaurant_reviews(nombre, telefono):
    connection = get_db_connection()
    cursor = connection.cursor()

    
    cursor.execute(f"SELECT * FROM reviews, restaurants \
                   WHERE ( \
                   reviewable_type='Restaurant' \
                   AND restaurants.id = reviewable_id \
                   AND nombre='{nombre}' \
                   AND telefono='{telefono}' \
                    )")
    reviews_ = cursor.fetchall()
    reviews = [{'autor': review[1], 'contenido': review[4], 'fecha': review[7]} for review in reviews_]

    cursor.close()
    connection.close()

    return jsonify({'reviews': reviews})
    


@app.route('/reviews/dishes/<nombre>/<telefono>/', methods=['GET'])
def get_dishes_reviews(nombre, telefono):
    connection = get_db_connection()
    cursor = connection.cursor()

    
    cursor.execute(f"SELECT * FROM reviews, restaurants, dishes \
                   WHERE ( \
                   reviewable_type='Dish' \
                   AND dishes.id = reviewable_id \
                   AND restaurants.id = dishes.restaurant_id \
                   AND dishes.nombre='{nombre}' \
                   AND restaurants.telefono='{telefono}' \
                    )")
    reviews_ = cursor.fetchall()
    reviews = [{'autor': review[1], 'contenido': review[4], 'fecha': review[7]} for review in reviews_]

    cursor.close()
    connection.close()

    return jsonify({'reviews': reviews})

if __name__ == '__main__':
    app.run(debug=True)