class AddCategorytoNews < ActiveRecord::Migration[6.1]
  def change
    add_reference :news, :category
  end
end
