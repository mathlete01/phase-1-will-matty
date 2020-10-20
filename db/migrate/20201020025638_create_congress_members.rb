class CreateCongressMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :congress_members do |t|
      t.string :name
      t.string :party
    end
  end
end
