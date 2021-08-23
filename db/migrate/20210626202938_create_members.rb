class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :name, null: false
      t.string :facebookUrl, null: true
      t.string :instagramUrl, null: true
      t.string :linkedinUrl, null: true
      t.string :description, null: true
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
