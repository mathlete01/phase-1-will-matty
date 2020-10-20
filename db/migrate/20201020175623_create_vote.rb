class CreateVote < ActiveRecord::Migration[5.2]
  def change
    create_table do |t|
      t.integer :congress_member_id
      t.integer :bill_id
      t.string :vote
    end
  end
end
