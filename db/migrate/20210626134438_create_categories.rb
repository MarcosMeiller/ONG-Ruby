class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
