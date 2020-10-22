class ChangingDatatypeOfVotePosition < ActiveRecord::Migration[5.2]
  def change
    add_column :votes, :position, :string
    remove_column :votes, :vote, :boolean
  end
end
