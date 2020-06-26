# 次の仕様を満たすSimpleBotクラスとDSLを作成してください
#
# # これは、作成するSimpleBotクラスの利用イメージです
# class Bot < SimpleBot
#   setting :name, 'bot'
#   respond 'keyword' do
#     "response #{settings.name}"
#   end
# end
#
# Bot.new.ask('keyword') #=> 'respond bot'
#
# 1. SimpleBotクラスを継承したクラスは、クラスメソッドrespond, setting, settingsを持ちます
#     1. settingsメソッドは、任意のオブジェクトを返します
#     2. settingsメソッドは、後述するクラスメソッドsettingによって渡された第一引数と同名のメソッド呼び出しに応答します
# 2. SimpleBotクラスのサブクラスのインスタンスは、インスタンスメソッドaskを持ちます
#     1. askは、一つの引数をとります
#     2. askに渡されたオブジェクトが、後述するrespondメソッドで設定したオブジェクトと一致する場合、インスタンスは任意の返り値を持ちます
#     3. 2のケースに当てはまらない場合、askメソッドの戻り値はnilです
# 3. クラスメソッドrespondは、keywordとブロックを引数に取ります
#     1. respondメソッドの第1引数keywordと同じ文字列が、インスタンス変数askに渡された時、第2引数に渡したブロックが実行され、その結果が返されます
# 4. クラスメソッドsettingは、引数を2つ取り、1つ目がキー名、2つ目が設定する値です
#     1. settingメソッドに渡された値は、クラスメソッド `settings` から返されるオブジェクトに、メソッド名としてアクセスすることで取り出すことができます
#     2. e.g. クラス内で `setting :name, 'bot'` と実行した場合は、respondメソッドに渡されるブロックのスコープ内で `settings.name` の戻り値は `bot` の文字列になります

class SimpleBot
  class << self
    def respond(keyword, &block)
      ask=keyword
      define_method :ask do |arg|
        arg==ask ? block.call : nil
      end
    end

    def setting(key,value)
      @hash=Hash.new
      @hash[key]=value
    end

    def settings
      obj=Object.new
      @hash.each_pair { |key,value| obj.define_singleton_method("#{key}") { value } } 
      obj
    end
  end
end

# ruby -Itest test/04_block/test_simple_bot.rb