class AddEmailToOffices < ActiveRecord::Migration[5.2]
  def change
    add_column :offices, :email, :string, null: false, default: true
  end
end
