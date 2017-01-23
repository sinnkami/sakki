class EntryRepository
  # 便利組み込みモジュール
  include Enumerable

  def initialize(db)
    @db = db
  end

  # 保存するところ
  def save(entry)
    columns = ['title', 'body']
    query = "INSERT INTO `entries` (#{columns.join(", ")}) VALUES (?, ?)"
    stmt = @db.prepare(query)
    stmt.execute(entry.title, entry.body)

    return @db.last_id
  end

  # 読み取るところ
  def fetch(id)
    query = "SELECT * FROM `entries` WHERE `id` = ?"
    stmt = @db.prepare(query)
    res = stmt.execute(id)

    data = res.first
    entry = Entry.new
    entry.title = data["title"]
    entry.body = data["body"]

    return entry
  end

  # eachで追加できる
  def each(&block)
    entries = []
    query = "SELECT * FROM `entries`"
    res = @db.query(query)

    res.each do |row|
      entry = Entry.new
      entry.title = row["title"]
      entry.body = row["body"]
      entries.push(entry)
    end
    
    entries.each(&block)
  end
end
