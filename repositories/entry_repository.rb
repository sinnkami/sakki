class EntryRepository
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
end
