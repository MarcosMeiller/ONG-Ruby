class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :firstName, null: false
      t.string :lastName, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :photo, null: true
      t.boolean :is_deleted, default: false
      t.timestamps
    end
  end
end
