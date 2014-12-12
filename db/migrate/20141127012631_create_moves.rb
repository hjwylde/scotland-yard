class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer :round_id, null: false
      t.integer :player_id, null: false

      t.integer :to_node_id, null: false
      t.string :ticket, null: false

      t.index [:round_id, :player_id], unique: true
      t.index :ticket

      t.timestamps
    end
  end
end

