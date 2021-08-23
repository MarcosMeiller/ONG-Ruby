class CreateOrganizations < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :address
      t.integer :phone
      t.string :email
      t.text :welcomeText
      t.text :aboutUsText
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
