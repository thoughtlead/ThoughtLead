class DropArticles < ActiveRecord::Migration
  def self.up
    drop_table :articles
  end

  def self.down
    create_table "articles" do |t|
      t.string   :title
      t.text     :body
      t.belongs_to  :user
      t.belongs_to  :course
      t.timestamps
    end
  end
end
