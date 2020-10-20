class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :congress_member_id
      t.integer :bill_id
      t.boolean :vote
    end
  end
end
