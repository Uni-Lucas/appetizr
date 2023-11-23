from flask import Flask, jsonify
import psycopg2
import os

EINAEATS_API_GET_DISHES_FROM_RESTAURANT = 'http://einaeats.herokuapp.com/'





app = Flask(__name__)

def get_db_connection():
    return psycopg2.connect(
        user=os.environ.get('POSTGRESQL_ADDON_USER'),
        host=os.environ.get('POSTGRESQL_ADDON_HOST'),
        password=os.environ.get('POSTGRESQL_ADDON_PASSWORD'),
        port=os.environ.get('POSTGRESQL_ADDON_PORT'),
        database=os.environ.get('POSTGRESQL_ADDON_DB')
    )

#---------------------------------------------------------------------------
#                               RESTAURANTS
#---------------------------------------------------------------------------

# Dado un imported_id de un restaurante, devuelve la url de la página de ese restaurante
@app.route('/restaurants/<imported_id>', methods=['GET'])
def get_restaurant_url(imported_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute(f"SELECT * FROM restaurants \
                        WHERE ( \
                        imported_id='{imported_id}' \
                        )")
        restaurant = cursor.fetchone()
        if restaurant:
            cursor.close()
            connection.close()
            return jsonify({'url': f'http://appetizr.herokuapp.com/restaurants/{restaurant[0]}'})
        else:
            cursor.close()
            connection.close()
            return jsonify({'url': 'No existe el restaurante'}), 404
    except:
        return jsonify({'url': 'No existe el restaurante'}), 404
       




#---------------------------------------------------------------------------
#                               REVIEWS
#---------------------------------------------------------------------------

# Dado el imported_id de un restaurante, devuelve las reviews de ese restaurante
@app.route('/reviews/restaurants/<imported_id>', methods=['GET'])
def get_restaurant_reviews(imported_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        
        cursor.execute(f"SELECT * FROM reviews, restaurants \
                    WHERE ( \
                    reviewable_type='Restaurant' \
                    AND restaurants.id = reviewable_id \
                    AND imported_id='{imported_id}' \
                        )")
        reviews_ = cursor.fetchall()
        reviews = [{'autor': review[1], 'contenido': review[4], 'fecha': review[7]} for review in reviews_]

        cursor.close()
        connection.close()

        return jsonify({'reviews': reviews})
    except:
        return jsonify({'reviews': 'No existe el restaurante'}), 404
        

# Dado el imported_id de un plato, devuelve las reviews de los platos de ese restaurante
@app.route('/reviews/dishes/<imported_id>', methods=['GET'])
def get_dishes_reviews(imported_id):
    try:

        connection = get_db_connection()
        cursor = connection.cursor()

        
        cursor.execute(f"SELECT * FROM reviews, restaurants, dishes \
                    WHERE ( \
                    reviewable_type='Dish' \
                    AND dishes.id = reviewable_id \
                    AND dishes.imported_id='{imported_id}' \
                        )")
        reviews_ = cursor.fetchall()
        reviews = [{'autor': review[1], 'contenido': review[4], 'fecha': review[7]} for review in reviews_]

        cursor.close()
        connection.close()

        return jsonify({'reviews': reviews})
    except:
        return jsonify({'reviews': 'No existe el plato'}), 404




#---------------------------------------------------------------------------
#                          IMPORTAR/EDITAR
#---------------------------------------------------------------------------

# Un plato es el mismo si tienen el mismo nombre y pertenecen al mismo restaurante, independientemente de su imported_id
# Por lo tanto, si se inserta un plato con el mismo nombre y perteneciente al mismo restaurante que uno ya existente
# se actualizará el imported_id del plato existente con el nuevo imported_id vinculandolos
# Si EinaEats añade un plato con el mismo nombre y perteneciente al mismo restaurante que uno ya existente diremos que es el mismo
# y se actualizará su información
#
# Dado el imported_id un restaurante y el imported_id de un plato para referenciarlo.
# Si el plato está importado se edita el nombre, descripción y precio de ese plato al nuevo indicado
#  y si no lo está se busca si el restaurante con el imported_id tiene un plato con el mismo nombre
#   si lo hay se actualiza el imported_id y se actualiza el resto de datos del plato
#   si no hay se añade a la base de datos con toda la información proporcionada.
@app.route('/dishes/<imported_id_res>/<imported_id_dish>/<new_nombre_dish>/<new_descripcion>/<new_precio>', methods=['PUT'])
def edit_dish(imported_id_res, imported_id_dish, new_nombre_dish, new_descripcion, new_precio):
    try:
        # Transformamos el caracter '+' en espacios
        new_nombre_dish = new_nombre_dish.replace('+', ' ')
        new_descripcion = new_descripcion.replace('+', ' ')
        
        response = import_dish(imported_id_res, imported_id_dish, new_nombre_dish, new_descripcion, new_precio)
        
        if response.status_code == 200:
            return jsonify({'status': 'ok'}), 200
        else:
            return jsonify({'status': 'error'}), 500
    except:
        return jsonify({'status': 'error'}), 500


def import_dish(imported_id_res, imported_id_dish, new_nombre_dish, new_descripcion, new_precio):
    try:

        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute(f"SELECT * FROM dishes \
                    WHERE ( \
                    imported_id='{imported_id_dish}' \
                        )")
        dishImported = cursor.fetchone()
        
        if dishImported:
            # El plato ya estaba importado, se actualiza
            cursor.execute(f"UPDATE dishes SET \
                                nombre='{new_nombre_dish}', descripcion='{new_descripcion}', precio='{new_precio}' \
                            WHERE ( \
                            imported_id='{imported_id_dish}' \
                            )")
        else:
            # El plato no estaba importado, buscamos si hay un plato con el mismo nombre en el restaurante con el imported_id
            # si lo hay se actualiza el imported_id y se actualiza el resto de datos
            cursor.execute(f"SELECT * FROM dishes \
                            WHERE ( \
                            nombre='{new_nombre_dish}' \
                            AND restaurant_id=(SELECT id FROM restaurants WHERE imported_id='{imported_id_res}') \
                            )")
            dishSameName = cursor.fetchone()
            if dishSameName:
                cursor.execute(f"UPDATE dishes SET \
                                    descripcion='{new_descripcion}', precio='{new_precio}', imported_id='{imported_id_dish}' \
                                WHERE ( \
                                nombre='{new_nombre_dish}' \
                                AND restaurant_id=(SELECT id FROM restaurants WHERE imported_id='{imported_id_res}') \
                                )")
            else:
                # No hay ningun plato con el mismo nombre en el restaurante con el imported_id, se crea uno nuevo
                cursor.execute(f"INSERT INTO dishes (nombre, descripcion, precio, restaurant_id, imported_id) \
                                VALUES ('{new_nombre_dish}', '{new_descripcion}', '{new_precio}', (SELECT id FROM restaurants WHERE imported_id='{imported_id_res}'), '{imported_id_dish}')")

        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({'status': 'ok'})
    except:
        return jsonify({'status': 'error'}), 500



# Un restaurante es el mismo si tienen el mismo nombre y telefono, independientemente de su imported_id
# Por lo tanto, si se inserta un restaurante con el mismo nombre y telefono que uno ya existente
# se actualizará el imported_id del restaurante existente con el nuevo imported_id vinculandolos
# Si EinaEats añade un restaurante con el mismo nombre y telefono que uno ya existente diremos que es el mismo
# y se actualizará su información
#
# Dado el imported_id un restaurante para referenciarlo.
# Si el restaurante está importado se edita el nombre, telefono, categoria, dirección y horario de ese restaurante al nuevo indicado
#  y si no lo está se busca si un restaurante tiene el mismo nombre y numero de telefono (entendemos que es el mismo restaurante)
#   si lo hay se actualiza el imported_id y se actualiza el resto de datos
#   si no hay se añade a la base de datos con toda la información proporcionada.
@app.route('/restaurants/<imported_id>/<new_nombre>/<new_telefono>/<new_categoria>/<new_horario>/<new_direccion>', methods=['PUT'])
def import_restaurant(imported_id, new_nombre, new_telefono, new_categoria, new_horario, new_direccion):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        # Transformamos el caracter '+' en espacios
        new_nombre = new_nombre.replace('+', ' ')
        new_categoria = new_categoria.replace('+', ' ')
        new_horario = new_horario.replace('+', ' ')
        new_direccion = new_direccion.replace('+', ' ')


        cursor.execute(f"SELECT * FROM restaurants \
                    WHERE ( \
                    imported_id='{imported_id}' \
                        );")
        restaurantImported = cursor.fetchone()
        
        if restaurantImported:
            # El restaurante ya estaba importado, se actualiza
            cursor.execute(f"UPDATE restaurants SET \
                                nombre='{new_nombre}', telefono='{new_telefono}', categoria='{new_categoria}', horario='{new_horario}', direccion='{new_direccion}' \
                            WHERE ( \
                            imported_id='{imported_id}' \
                            );")
        else:
            # El restaurante no estaba importado, buscamos si hay un restaurante con el mismo nombre y telefono
            # si lo hay se actualiza el imported_id y se actualiza el resto de datos
            cursor.execute(f"SELECT * FROM restaurants \
                            WHERE ( \
                            nombre='{new_nombre}' \
                            AND telefono='{new_telefono}' \
                            )")
            restaurantSameNameAndTfno = cursor.fetchone()
            if restaurantSameNameAndTfno:
                cursor.execute(f"UPDATE restaurants SET \
                                    nombre='{new_nombre}', telefono='{new_telefono}', categoria='{new_categoria}', horario='{new_horario}', direccion='{new_direccion}', imported_id='{imported_id}' \
                                WHERE ( \
                                nombre='{new_nombre}' \
                                AND telefono='{new_telefono}' \
                                )")
            else:
                # No hay ningun restaurante con el mismo nombre y telefono, se crea uno nuevo
                cursor.execute(f"INSERT INTO restaurants (nombre, telefono, categoria, horario, direccion, imported_id) \
                                VALUES ('{new_nombre}', '{new_telefono}', '{new_categoria}', '{new_horario}', '{new_direccion}', '{imported_id}')")

            import_all_dishes_from_imported_restaurant(imported_id)


        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({'status': 'ok'})
    except:
        return jsonify({'status': 'error'}), 500


# Esta función será llamada cuando se importe un restaurante desde EinaEats
# y este no esté en la base de datos de Appetizr, se harán llamadas a la función de importar platos
#
# Dado el imported_id de un restaurante, importa todos los platos de ese restaurante
# realizando una llamada a la API de EinaEats que devuelve los platos de un restaurante
# y los añade a la base de datos
def import_all_dishes_from_imported_restaurant(imported_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute(f"SELECT id FROM restaurants \
                        WHERE ( \
                        imported_id='{imported_id}' \
                        )")
        restaurant = cursor.fetchone()
        if restaurant:
            dishes = requests.get(f"'{EINAEATS_API_GET_DISHES_FROM_RESTAURANT}'").json()['dishes']
            for dish in dishes:
                import_dish(imported_id, dish['id'], dish['nombre'], dish['nombre'], dish['descripcion'], dish['precio'])

        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({'status': 'ok'})
    except:
        return jsonify({'status': 'error'}), 500

    





#---------------------------------------------------------------------------
#                               UNLINK
#---------------------------------------------------------------------------

# Cuando EinaEats borre un restaurante se mantendrá en la base de datos
# pero se eliminará su imported_id. Si se vuelve a crear en EinaEats
# si tiene el mismo nombre y telefono se vinculará con el mismo restaurante
# al realizar la llamada a la api "/restaurants/<imported_id>/<new_nombre>/<new_telefono>/<new_categoria>/<new_horario>/<new_direccion>"
#
# Dado el imported_id de un restaurante, lo desenlaza de la base de datos
# el restaurante no se borra de la base de datos, solo se eliminará su imported_id
# y el de todos sus platos
@app.route('/restaurants/unlink/<imported_id>', methods=['PUT'])
def unlink_restaurant(imported_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute(f"UPDATE dishes SET \
                            imported_id=NULL \
                        WHERE ( \
                        restaurant_id=(SELECT id FROM restaurants WHERE imported_id='{imported_id}') \
                        )")
        cursor.execute(f"UPDATE restaurants SET \
                            imported_id=NULL \
                        WHERE ( \
                        imported_id='{imported_id}' \
                        )")
        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({'status': 'ok'})
    except:
        return jsonify({'status': 'error'}), 500



# Cuando EinaEats borre un plato se mantendrá en la base de datos
# pero se eliminará su imported_id. Si se vuelve a crear en EinaEats
# si tiene el mismo nombre y pertenece al mismo restaurante se vinculará con el mismo plato
# al realizar la llamada a la api "/dishes/<imported_id_res>/<imported_id_dish>/<nombre_dish>/<new_nombre_dish>/<new_descripcion>/<new_precio>"
#
# Dado el imported_id de un plato, lo desenlaza de la base de datos
# el plato no se borra de la base de datos, solo se eliminará su imported_id
@app.route('/dishes/unlink/<imported_id>', methods=['PUT'])
def unlink_dish(imported_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute(f"UPDATE dishes SET \
                            imported_id=NULL \
                        WHERE ( \
                        imported_id='{imported_id}' \
                        )")
        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({'status': 'ok'})
    except:
        return jsonify({'status': 'error'}), 500
    



#---------------------------------------------------------------------------
#                               PROPIETARIO
#---------------------------------------------------------------------------


# Utilizada para vincular un restaurante importado con un usuario
# Será llamada desde EinaEats cuando mandemos a un usuario a realizar el login
# en EinaEats para verificar que es propietario del restaurante, cuando finalice 
# se vinculará el restaurante
#
# Dado el id de un usuario y el imported_id de un restaurante
# se añade a la base de datos que el usuario es propietario del restaurante
@app.route('/propietario/<id_user>/<imported_id>', methods=['GET'])
def set_propietario(id_user, imported_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute(f"SELECT id FROM restaurants \
                            WHERE ( \
                            imported_id='{imported_id}' \
                            )")
        restaurant = cursor.fetchone()
        if restaurant:
            cursor.execute(f"INSERT INTO restaurants_users (user_id, restaurant_id) \
                            VALUES ('{id_user}', '{restaurant[0]}')")
            connection.commit()
            cursor.close()
            connection.close()
            return jsonify({'status': 'ok'})
        else:
            cursor.close()
            connection.close()
            return jsonify({'status': 'error'}), 500
    except:
        return jsonify({'status': 'error'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
