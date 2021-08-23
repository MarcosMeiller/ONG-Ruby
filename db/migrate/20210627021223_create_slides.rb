class CreateSlides < ActiveRecord::Migration[6.1]
  def change
    create_table :slides do |t|
      t.string :imageUrl
      t.text :text
      t.integer :order
      t.references :organization, null: false, foreign_key: false #cambiar a true, cuando este creada la tabla organizations

      t.timestamps
    end
  end
end
