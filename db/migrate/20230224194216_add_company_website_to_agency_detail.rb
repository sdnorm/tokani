class AddCompanyWebsiteToAgencyDetail < ActiveRecord::Migration[7.0]
  def change
    add_column :agency_details, :company_website, :string
  end
end
