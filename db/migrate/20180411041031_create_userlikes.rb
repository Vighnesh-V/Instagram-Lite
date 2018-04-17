class CreateUserlikes < ActiveRecord::Migration[5.1]
  def change
    create_table :userlikes do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.string :state

      t.timestamps
    end
  end
end
