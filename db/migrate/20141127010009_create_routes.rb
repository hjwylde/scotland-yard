class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.integer :from_node_id, null: false
      t.integer :to_node_id, null: false
      t.string :transport_mode, null: false

      t.index :from_node_id
      t.index :to_node_id
      t.index [:from_node_id, :to_node_id, :transport_mode], unique: true

      t.timestamps
    end
  end
end

