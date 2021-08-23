class CreateActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.text :content
      t.string :image
      t.boolean :is_deleted, default: false
      t.timestamps
    end
  end
end
