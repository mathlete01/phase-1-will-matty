class CreateCongressMember < ActiveRecord::Migration[5.2]
  def change
    t.string :name
    t.string :party
  end
end
