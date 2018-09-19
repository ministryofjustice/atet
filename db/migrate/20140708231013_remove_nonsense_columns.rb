class RemoveNonsenseColumns < ActiveRecord::Migration[4.2]
  def change
    remove_column :claimants, :has_representative
    remove_column :claimants, :has_special_needs
    remove_column :respondents, :was_employed
  end
end
