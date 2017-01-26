class Tag
  def initialize(db)
    @db = db
  end

  def fetch(tag_name)
    entries = []
    query = 'SELECT * FROM `entries` WHERE `tags` REGEXP ?'
    stmt = @db.prepare(query)
    res = stmt.execute(tag_name)

    res.each do |row|
      entry = Entry.new(row)
      entries.push(entry)
    end
    return entries
  end
end
