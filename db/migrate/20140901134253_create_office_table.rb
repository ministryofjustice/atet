class CreateOfficeTable < ActiveRecord::Migration[4.2]
  def change
    create_table :offices do |t|
      t.integer :code
      t.string :name
      t.string :address
      t.string :telephone

      t.timestamps
      t.references :claim
    end
  end
end
