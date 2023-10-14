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

ActiveRecord::Schema[7.1].define(version: 2023_10_09_165708) do
  create_schema "postgis_topology"
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
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "refint"
  enable_extension "seg"
  enable_extension "sslinfo"
  enable_extension "tablefunc"
  enable_extension "tcn"
  enable_extension "timetravel"
  enable_extension "unaccent"
  enable_extension "uuid-ossp"
  enable_extension "xml2"

  create_table "appetizr_db_models", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categorias", primary_key: "nombre", id: { type: :string, limit: 20 }, force: :cascade do |t|
  end

  create_table "personas", primary_key: "idpersona", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 50, null: false
    t.string "contrasegna", limit: 50, null: false
    t.binary "imgperfil"
  end

  create_table "platos", primary_key: "idplato", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 50, null: false
    t.string "descripcion", limit: 50, null: false
    t.binary "imgplato"
    t.integer "restaurante", null: false
  end

  create_table "posts", primary_key: "idcom", id: :serial, force: :cascade do |t|
    t.string "contenido", limit: 400, null: false
    t.binary "imagen"
    t.timestamptz "fecha", null: false
    t.string "categoria", limit: 20, null: false
    t.integer "idautorrest"
    t.integer "idautorpers"
    t.check_constraint "idautorrest IS NOT NULL OR idautorpers IS NOT NULL", name: "posts_check"
  end

  create_table "reacciona", primary_key: "idreaccion", id: :serial, force: :cascade do |t|
    t.integer "idpost"
    t.integer "idreview"
    t.integer "idrespuesta"
    t.integer "idpers", null: false
    t.boolean "reaccion", null: false
    t.check_constraint "idpost IS NOT NULL AND idreview IS NULL AND idrespuesta IS NULL OR idpost IS NULL AND idreview IS NOT NULL AND idrespuesta IS NULL OR idpost IS NULL AND idreview IS NULL AND idrespuesta IS NOT NULL", name: "reacciona_check"
  end

  create_table "respuestas", primary_key: "idcom", id: :serial, force: :cascade do |t|
    t.string "contenido", limit: 400, null: false
    t.binary "imagen"
    t.timestamptz "fecha", null: false
    t.integer "idautorrest"
    t.integer "idautorpers"
    t.integer "idpost", null: false
    t.check_constraint "idautorrest IS NOT NULL OR idautorpers IS NOT NULL", name: "respuestas_check"
  end

  create_table "restaurantes", primary_key: "idrest", id: :serial, force: :cascade do |t|
    t.string "nombre", limit: 50, null: false
    t.string "contrasegna", limit: 50, null: false
    t.binary "imgperfil"
    t.string "direccion", limit: 50, null: false
    t.string "telefono", limit: 20, null: false
    t.string "horario", limit: 50, null: false
    t.string "categoria", limit: 20, null: false
  end

  create_table "reviews", primary_key: "idcom", id: :serial, force: :cascade do |t|
    t.string "contenido", limit: 400, null: false
    t.binary "imagen"
    t.timestamptz "fecha", null: false
    t.integer "idautorpers", null: false
    t.integer "idrest"
    t.integer "idplato"
    t.check_constraint "idrest IS NOT NULL OR idplato IS NOT NULL", name: "reviews_check"
  end

  create_table "spatial_ref_sys", primary_key: "srid", id: :integer, default: nil, force: :cascade do |t|
    t.string "auth_name", limit: 256
    t.integer "auth_srid"
    t.string "srtext", limit: 2048
    t.string "proj4text", limit: 2048
    t.check_constraint "srid > 0 AND srid <= 998999", name: "spatial_ref_sys_srid_check"
  end

  create_table "valora", primary_key: ["idrestaurante", "idpersona"], force: :cascade do |t|
    t.integer "idrestaurante", null: false
    t.integer "idpersona", null: false
    t.integer "valoracion", null: false
    t.check_constraint "valoracion >= 0 AND valoracion <= 5", name: "valora_valoracion_check"
  end

  add_foreign_key "platos", "restaurantes", column: "restaurante", primary_key: "idrest", name: "platos_restaurante_fkey"
  add_foreign_key "posts", "categorias", column: "categoria", primary_key: "nombre", name: "posts_categoria_fkey"
  add_foreign_key "posts", "personas", column: "idautorpers", primary_key: "idpersona", name: "posts_idautorpers_fkey"
  add_foreign_key "posts", "restaurantes", column: "idautorrest", primary_key: "idrest", name: "posts_idautorrest_fkey"
  add_foreign_key "reacciona", "personas", column: "idpers", primary_key: "idpersona", name: "reacciona_idpers_fkey"
  add_foreign_key "reacciona", "posts", column: "idpost", primary_key: "idcom", name: "reacciona_idpost_fkey"
  add_foreign_key "reacciona", "respuestas", column: "idrespuesta", primary_key: "idcom", name: "reacciona_idrespuesta_fkey"
  add_foreign_key "reacciona", "reviews", column: "idreview", primary_key: "idcom", name: "reacciona_idreview_fkey"
  add_foreign_key "respuestas", "personas", column: "idautorpers", primary_key: "idpersona", name: "respuestas_idautorpers_fkey"
  add_foreign_key "respuestas", "posts", column: "idpost", primary_key: "idcom", name: "respuestas_idpost_fkey"
  add_foreign_key "respuestas", "restaurantes", column: "idautorrest", primary_key: "idrest", name: "respuestas_idautorrest_fkey"
  add_foreign_key "restaurantes", "categorias", column: "categoria", primary_key: "nombre", name: "restaurantes_categoria_fkey"
  add_foreign_key "reviews", "personas", column: "idautorpers", primary_key: "idpersona", name: "reviews_idautorpers_fkey"
  add_foreign_key "reviews", "platos", column: "idplato", primary_key: "idplato", name: "reviews_idplato_fkey"
  add_foreign_key "reviews", "restaurantes", column: "idrest", primary_key: "idrest", name: "reviews_idrest_fkey"
  add_foreign_key "valora", "personas", column: "idpersona", primary_key: "idpersona", name: "valora_idpersona_fkey"
  add_foreign_key "valora", "restaurantes", column: "idrestaurante", primary_key: "idrest", name: "valora_idrestaurante_fkey"
end
