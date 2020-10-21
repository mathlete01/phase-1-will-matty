class CreateCongressMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :congress_members do |t|
      t.string :name
      t.string :party
      t.string :state
      t.string :title
      t.string :crp_id
    end
  end
end
