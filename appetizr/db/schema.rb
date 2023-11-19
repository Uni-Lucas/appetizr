# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_11_18_191544) do
  create_schema "tiger"
  create_schema "tiger_data"
  create_schema "topology"

  # These are extensions that must be enabled in order to support this database
  enable_extension "adminpack"
  enable_extension "autoinc"
  enable_extension "btree_gin"
  enable_extension "btree_gist"
  enable_extension "citext"
  enable_extension "cube"
  enable_extension "dblink"
  enable_extension "dict_int"
  enable_extension "dict_xsyn"
  enable_extension "earthdistance"
  enable_extension "file_fdw"
  enable_extension "fuzzystrmatch"
  enable_extension "hstore"
  enable_extension "insert_username"
  enable_extension "intagg"
  enable_extension "intarray"
  enable_extension "isn"
  enable_extension "lo"
  enable_extension "ltree"
  enable_extension "moddatetime"
  enable_extension "pageinspect"
  enable_extension "pg_buffercache"
  enable_extension "pg_freespacemap"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "pgrowlocks"
  enable_extension "pgstattuple"
  enable_extension "plls"
  enable_extension "plpgsql"
  enable_extension "plv8"
  enable_extension "postgis"
  enable_extension "postgis_raster"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "postgis_topology"
  enable_extension "refint"
  enable_extension "seg"
  enable_extension "sslinfo"
  enable_extension "tablefunc"
  enable_extension "tcn"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"
  enable_extension "xml2"

  create_table "appetizr_db_models", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", id: false, force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ruta_img"
    t.index ["nombre"], name: "index_categories_on_nombre", unique: true
  end

  create_table "dishes", force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "nombre"
    t.string "ruta_img_plato"
    t.text "descripcion"
    t.float "precio"
    t.index ["restaurant_id"], name: "index_dishes_on_restaurant_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "categoria"
    t.string "autor"
    t.text "contenido"
    t.string "ruta_img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "restaurant_id"
  end

  create_table "ranks", id: false, force: :cascade do |t|
    t.string "who"
    t.bigint "what"
    t.integer "valoracion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reactions", force: :cascade do |t|
    t.string "who"
    t.string "reactionable_type"
    t.bigint "reactionable_id"
    t.string "reaccion"
    t.index ["reactionable_type", "reactionable_id"], name: "index_reactions_on_reactionable"
    t.index ["who", "reactionable_id", "reactionable_type"], name: "idx_on_who_reactionable_id_reactionable_type_f0ee917128", unique: true
  end

  create_table "responses", force: :cascade do |t|
    t.string "autor"
    t.string "respondable_type"
    t.bigint "respondable_id"
    t.text "contenido"
    t.string "ruta_img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["respondable_type", "respondable_id"], name: "index_responses_on_respondable"
  end

  create_table "restaurants", force: :cascade do |t|
    t.string "categoria"
    t.string "nombre"
    t.string "ruta_img_perfil"
    t.string "ruta_img_fondo"
    t.string "direccion"
    t.string "telefono"
    t.string "horario"
    t.integer "imported_id"
  end

  create_table "restaurants_users", id: false, force: :cascade do |t|
    t.bigint "restaurant_id"
    t.string "user_id"
    t.index ["restaurant_id"], name: "index_restaurants_users_on_restaurant_id"
    t.index ["user_id"], name: "index_restaurants_users_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "autor"
    t.string "reviewable_type"
    t.bigint "reviewable_id"
    t.text "contenido"
    t.string "ruta_img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable"
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, default: nil, force: :cascade do |t|
    t.string "auth_name", limit: 256
    t.integer "auth_srid"
    t.string "srtext", limit: 2048
    t.string "proj4text", limit: 2048
    t.check_constraint "srid > 0 AND srid <= 998999", name: "spatial_ref_sys_srid_check"
  end

  create_table "users", primary_key: "nombre", id: :string, force: :cascade do |t|
    t.string "ruta_img_perfil"
    t.boolean "esAdmin"
    t.string "password_digest"
    t.index ["nombre"], name: "index_users_on_nombre", unique: true
  end

  add_foreign_key "dishes", "restaurants"
  add_foreign_key "posts", "categories", column: "categoria", primary_key: "nombre"
  add_foreign_key "posts", "users", column: "autor", primary_key: "nombre"
  add_foreign_key "ranks", "restaurants", column: "what"
  add_foreign_key "ranks", "users", column: "who", primary_key: "nombre"
  add_foreign_key "reactions", "users", column: "who", primary_key: "nombre"
  add_foreign_key "responses", "users", column: "autor", primary_key: "nombre"
  add_foreign_key "restaurants", "categories", column: "categoria", primary_key: "nombre"
  add_foreign_key "restaurants_users", "users", primary_key: "nombre"
  add_foreign_key "reviews", "users", column: "autor", primary_key: "nombre"
end
