class CreatePlayedSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :played_songs do |t|
      t.integer :song_id
      t.integer :station_id
      t.string :stream_title
      t.string :artist
      t.string :title
      t.string :album
      t.string :genre
      t.string :cover_image_url
      t.datetime :media_release_date

      t.timestamps

      t.index :song_id
      t.index :station_id
      t.index :stream_title
      t.index :artist
      t.index :title
      t.index :album
      t.index :genre
    end
  end
end
