class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.boolean :origin, null: false, default: false
      t.float :x, null: true
      t.float :y, null: true

      t.index :origin

      t.timestamps
    end
  end
end

