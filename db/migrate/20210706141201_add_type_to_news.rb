class AddTypeToNews < ActiveRecord::Migration[6.1]
  def change
    add_column :news, :type_news, :string
  end
end
