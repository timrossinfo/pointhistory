class ChapterBuilder
  def build_chapters
    chapters = []
    chapter_files = Dir.glob('app/views/pages/_ch*').sort
    chapter_files.each do |path|
      doc = File.open(path) { |f| Nokogiri::HTML(f) }
      chapter = find_chapter doc
      chapter.sections.replace find_sections(doc)
      chapters << chapter
    end
    chapters
  end

  def find_chapter(doc)
    heading = doc.at_css '.page-header h1'
    Chapter.new(heading['id'], heading.text)
  end

  def find_sections(doc)
    sections = []
    doc.css('h2').each do |heading|
      sections << Section.new(heading['id'], heading.text)
    end
    sections
  end
end
