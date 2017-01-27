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

  def all
    tags = []
    number = []
    query = "SELECT `tags` FROM `entries`"
    res = @db.query(query)

    res.each do |row|
      text = row["tags"].split(",")
      text.each do |e|
        tags.push(e)
      end
    end
    
    return tags.inject(Hash.new(0)){|hash, a| hash[a] += 1; hash}
  end
end
