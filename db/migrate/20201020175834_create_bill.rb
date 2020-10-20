class CreateBill < ActiveRecord::Migration[5.2]
  def change
    create_table do |t|
      t.string :name
      t.text :description
      t.integer :issue_id
    end
  end
end
