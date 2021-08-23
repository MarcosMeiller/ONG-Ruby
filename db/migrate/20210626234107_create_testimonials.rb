class CreateTestimonials < ActiveRecord::Migration[6.1]
  def change
    create_table :testimonials do |t|
      t.string :name, null: false
      t.string :content, null: true
      t.boolean :is_deleted

      t.timestamps
    end
  end
end
