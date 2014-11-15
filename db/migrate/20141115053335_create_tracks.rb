class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :path
      t.integer :track_num
      t.integer :disc_num
      t.references :album, index: true

      t.timestamps
    end
  end
end
