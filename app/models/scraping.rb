class Scraping
  def self.movie_urls
    # puts 'get movies link URL'
    #映画.com 個別ページのリンク20件を読み込む
    #get_product(link)を呼ぶ
    #①linksという配列の空枠を作る
    links = []
    #②Mechanizeクラスのインスタンスを生成する
    agent = Mechanize.new

    #パスの部分を変数で定義する
    next_url= "/now/"
    # next_url = []

    while true do

      #③映画の全体ページのURLを取得
      current_page = agent.get("http://www.eiga.com/" + next_url)
      #④全体ページから映画20件の個別URLのタグを取得
      elements = current_page.search('.m_unit h3 a')
      #⑤個別URLのタグからhref要素を取り出し、links配列に格納する
      elements.each do |element|
        links << element[:href]
      end

      #「次へ」を表すタグを取得
      next_link = current_page.at('.next_page')

      # そのタグからhref属性の値を取得
      next_url = next_link[:href]

      #next_urlがなかったらwhileをぬける>わかんねー
      unless next_url
        break
      end

      # unlessは１行の時下のようにもかける
      # break unless next_url

    end

    #⑥get_productを実行する際にリンクを引数として渡す
    links.each do |link|
      get_product('http://www.eiga.com' + link)
    end
  end

  def self.get_product(link)
    # puts 'get movie information'
    #個別ページのリンクをもとに、作品名と画像urlを取得する

    #⑦Mechanizeクラスのインスタンスを生成する
    agent = Mechanize.new
    #⑧映画の個別ページのURLを取得
    current_page = agent.get(link)
    #⑨inner_textメソッドを利用し映画のタイトルを取得
    title = current_page.at('.moveInfoBox h1').inner_text
    #①⓪image_urlがあるsrc要素のみを取り出す
    #もし画像があれば、という条件をつけたしておく　エラー回避のため
    image_url = current_page.at('.pictBox img').get_attribute('src') if current_page.at('.pictBox img')
    # こういう書き方も可能
    # image_url = current_page.search('.pictBox img')[:src]

    #監督名、あらすじ、公開日を取得
    #ただし作品によって記載がない可能性があるため、それを考慮する
    director  = current_page.at('.f span').inner_text if current_page.at('.f span')
    detail    = current_page.at('.outline p').inner_text if current_page.at('.outline p')
    open_date = current_page.at('.opn_date strong').inner_text if current_page.at('.opn_date strong')


    #①①newメソッド、saveメソッドを使い、 スクレイピングした「映画タイトル」と「作品画像のURL」をproductsテーブルに保存
    # すでにテーブルに登録済みの映画情報を重複して登録しない
    product = Product.where(title: title, image_url: image_url).first_or_initialize

    # 失敗！　これだと重複データを保存してしまう
    # product = Product.where(title: title, image_url: image_url, director: director, detail: detail, open_date: open_date).first_or_initialize

    product.director  = director    #監督名
    product.detail    = detail      #あたすじ
    product.open_date = open_date   #公開日

    product.save
    # product = Product.new(title: title, image_url: image_url)
  end
end