# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_14_162521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "played_songs", force: :cascade do |t|
    t.integer "song_id"
    t.integer "station_id"
    t.string "stream_title"
    t.string "artist"
    t.string "title"
    t.string "album"
    t.string "genre"
    t.string "cover_image_url"
    t.datetime "media_release_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["album"], name: "index_played_songs_on_album"
    t.index ["artist"], name: "index_played_songs_on_artist"
    t.index ["genre"], name: "index_played_songs_on_genre"
    t.index ["song_id"], name: "index_played_songs_on_song_id"
    t.index ["station_id"], name: "index_played_songs_on_station_id"
    t.index ["stream_title"], name: "index_played_songs_on_stream_title"
    t.index ["title"], name: "index_played_songs_on_title"
  end

  create_table "stations", force: :cascade do |t|
    t.string "continent"
    t.string "country"
    t.string "city"
    t.string "name"
    t.jsonb "genres"
    t.string "logo_url"
    t.integer "radio_de_id"
    t.index ["city"], name: "index_stations_on_city"
    t.index ["continent"], name: "index_stations_on_continent"
    t.index ["country"], name: "index_stations_on_country"
    t.index ["genres"], name: "index_stations_on_genres"
    t.index ["name"], name: "index_stations_on_name"
    t.index ["radio_de_id"], name: "index_stations_on_radio_de_id", unique: true
  end

end
