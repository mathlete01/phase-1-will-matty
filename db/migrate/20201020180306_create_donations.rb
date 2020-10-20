class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.integer :amount
      t.integer :congress_member_id
      t.integer :issue_id
    end
  end
end
