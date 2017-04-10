class ReviewsController < RankingController
  #Rubyでは引数の括弧()や{}は省略できます
  #before_actionメソッドは、呼び出される際第一引数にシンボル型でメソッド名、第二引数以降にハッシュ型でオプションを受け取るメソッドである
  before_action :authenticate_user!, only: :new

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
  end

  def create
    # Review.create(create_params)
    Review.create(create_params)
    # トップページにリダイレクトする
    redirect_to controller: :products, action: :index
  end

  private
  def create_params
    # form_for reviewに入力した値を取得する　product_idはパスから取得する
    params.require(:review).permit(:rate, :review).merge(product_id: params[:product_id], user_id: current_user.id)
  end
end
