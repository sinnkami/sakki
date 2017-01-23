class EntryRepository
  # 便利組み込みモジュール
  include Enumerable

  def initialize
    @entries = []
  end

  # 保存するところ
  def save(entry)
    @entries.push(entry)
    return @entries.length - 1
  end

  # 読み取るところ
  def fetch(id)
    @entries[id]
  end

  # eachで追加できる
  def each(&block)
    @entries.each(&block)
  end
end
