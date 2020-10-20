class CreateCongressMember < ActiveRecord::Migration[5.2]
  def change
    create_table do |t|
      t.string :name
      t.string :party
    end
  end
end
