class EntryRepository
  # 便利組み込みモジュール
  include Enumerable

  def initialize(db)
    @db = db
  end

  # 保存するところ
  def save(entry)
    columns = Entry::COLUMNS.reject { |key| key == :id }
    values = columns.map { |key| entry.instance_variable_get("@#{key}") }

    # 時間を入れる
    values[2] = Time.now

    query = "INSERT INTO `entries` (#{columns.join(", ")}) VALUES (#{columns.map { '?' }.join(', ')})"
    stmt = @db.prepare(query)
    stmt.execute(*values)

    entry.id = @db.last_id
    return entry.id
  end

  # 読み取るところ
  def fetch(id)
    query = "SELECT * FROM `entries` WHERE `id` = ?"
    stmt = @db.prepare(query)
    res = stmt.execute(id)

    data = res.first
    unless data
      return false
    end
    entry = Entry.new(data)


    return entry
  end

  # 記事を消すところ
  def delete(type, action)
    if type == "id"
      query = "DELETE FROM `entries` WHERE `id` = ?"
    elsif type == "title"
      query = "DELETE FROM `entries` WHERE `title` = ?"
    end

    stmt = @db.prepare(query)
    res = stmt.execute(action)
    return "/"
  end


  # 最新記事を取得するところ
  def recent(limit = 5, id = 0)
    query = "SELECT * FROM `entries` ORDER BY `id` DESC LIMIT ?, ?"
    stmt = @db.prepare(query)
    res = stmt.execute(id, limit)

    res.map do |row|
      Entry.new(row)
    end
  end

  # 全記事を取得するところ
  def each(&block)
    entries = []
    query = "SELECT * FROM `entries`"
    res = @db.query(query)

    res.each do |row|
      entry = Entry.new(row)
      entries.push(entry)
    end

    entries.each(&block)
  end
end
