class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :number, null: false
      t.string :type, null: false
      t.string :name, null: false

      t.index :name, unique: true

      t.timestamps
    end
  end
end

