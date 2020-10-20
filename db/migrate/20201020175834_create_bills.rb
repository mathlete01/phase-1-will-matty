class CreateBills < ActiveRecord::Migration[5.2]
  def change
    create_table :bills do |t|
      t.string :name
      t.text :description
      t.integer :issue_id
    end
  end
end
