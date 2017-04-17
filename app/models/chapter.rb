class Chapter
  attr_reader :id, :name, :sections

  def initialize(id, name)
    @id = id
    @name = name
    @sections = []
  end

  def path
    "/chapters/#{id}"
  end
end
