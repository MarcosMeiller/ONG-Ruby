class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :description, null: true
      t.boolean :is_deleted, null: false ,default: false
      
      t.timestamps
    end
  end
end
