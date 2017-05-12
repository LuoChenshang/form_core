class CreateDictionaries < ActiveRecord::Migration[5.1]
  def change
    create_table :dictionaries do |t|
      t.string :value
      t.string :type, null: false
      t.index :type

      t.timestamps
    end
  end
end
