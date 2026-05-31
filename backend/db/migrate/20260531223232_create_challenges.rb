class CreateChallenges < ActiveRecord::Migration[8.1]
  def change
    create_table :challenges do |t|
      t.string :title
      t.text :description
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
