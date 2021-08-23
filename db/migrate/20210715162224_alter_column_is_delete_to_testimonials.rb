class AlterColumnIsDeleteToTestimonials < ActiveRecord::Migration[6.1]
  def change
    change_column :testimonials, :is_deleted, :boolean, default: false
  end
end
