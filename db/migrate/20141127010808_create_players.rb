class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :game_id, null: false
      t.integer :user_id, null: false

      t.string :type, null: false
      t.integer :origin_node_id, null: false

      t.index [:game_id, :user_id], unique: true
      t.index :type

      t.timestamps
    end
  end
end

