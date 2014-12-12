# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141127012634) do

  create_table "games", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["name"], name: "index_games_on_name", unique: true

  create_table "moves", force: true do |t|
    t.integer  "round_id",   null: false
    t.integer  "player_id",  null: false
    t.integer  "to_node_id", null: false
    t.string   "ticket",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moves", ["round_id", "player_id"], name: "index_moves_on_round_id_and_player_id", unique: true
  add_index "moves", ["ticket"], name: "index_moves_on_ticket"

  create_table "nodes", force: true do |t|
    t.boolean  "origin",     default: false, null: false
    t.float    "x"
    t.float    "y"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["origin"], name: "index_nodes_on_origin"

  create_table "players", force: true do |t|
    t.integer  "game_id",        null: false
    t.string   "name",           null: false
    t.string   "type",           null: false
    t.integer  "origin_node_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["game_id", "name"], name: "index_players_on_game_id_and_name", unique: true
  add_index "players", ["type"], name: "index_players_on_type"

  create_table "rounds", force: true do |t|
    t.integer  "game_id",    null: false
    t.integer  "number",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rounds", ["game_id", "number"], name: "index_rounds_on_game_id_and_number", unique: true

  create_table "routes", force: true do |t|
    t.integer  "from_node_id",   null: false
    t.integer  "to_node_id",     null: false
    t.string   "transport_mode", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "routes", ["from_node_id", "to_node_id", "transport_mode"], name: "index_routes_on_from_node_id_and_to_node_id_and_transport_mode", unique: true
  add_index "routes", ["from_node_id"], name: "index_routes_on_from_node_id"
  add_index "routes", ["to_node_id"], name: "index_routes_on_to_node_id"

end
