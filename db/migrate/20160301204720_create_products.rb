class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      #テーブル設計のときはt.型  :カラム名
      t.string       :title         #作品名
      t.text         :image_url     #作品画像のurl
      t.timestamps
    end
  end
end
