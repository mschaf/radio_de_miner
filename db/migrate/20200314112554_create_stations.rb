class CreateStations < ActiveRecord::Migration[6.0]
  def change
    create_table :stations do |t|
      t.string :continent
      t.string :country
      t.string :city
      t.string :name
      t.jsonb :genres
      t.string :logo_url
      t.integer :radio_de_id

      t.index :radio_de_id, unique: true
      t.index :continent
      t.index :country
      t.index :city
      t.index :name
      t.index :genres
    end
  end
end
