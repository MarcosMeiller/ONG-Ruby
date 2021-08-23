class AddIsDeletedToSlides < ActiveRecord::Migration[6.1]
  def change
    add_column :slides, :is_deleted, :boolean, default: false
  end
end
