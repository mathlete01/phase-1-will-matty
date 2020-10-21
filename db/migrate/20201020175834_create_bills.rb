class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.string :name
      t.text :description
      t.integer :industry_id
      t.string :congress_bill_id
    end
  end
end
