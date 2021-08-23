class AddSocialnetworkToOrganizations < ActiveRecord::Migration[6.1]
  def change
    add_column :organizations, :social_network, :json, default: {facebook: nil, linkedin: nil, instegram: nil}
  end
end
