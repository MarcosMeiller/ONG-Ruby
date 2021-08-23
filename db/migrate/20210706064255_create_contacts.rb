class CreateContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.string :phone, null: true
      t.string :email, null: true
      t.string :message, null: true
      t.references :user, null: false, foreign_key: true
      t.boolean :is_deleted, null: false ,default: false
      t.timestamps
    end
  end
end
