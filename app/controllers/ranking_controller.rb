class RankingController < ApplicationController
  layout 'review_site'
  before_action :ranking
  def ranking
    # orde('count_column ASC/DESC')とはculumnの要素数でソートするという意味
    # countメソッドは要素数を返すメソッド
    # keysメソッドはハッシュの値を取り出すメソッド
    product_ids = Review.group(:product_id).order('count_product_id DESC').limit(5).count(:product_id).keys


    @ranking = product_ids.map{|id| Product.find(id)}
  end
end
