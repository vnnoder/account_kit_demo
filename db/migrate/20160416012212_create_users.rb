class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :country_prefix
      t.string :national_number
    end
  end
end
