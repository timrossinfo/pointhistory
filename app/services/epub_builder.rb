class EpubBuilder
  include ActionView::Helpers::AssetTagHelper

  attr_reader :book

  def build
    create_book
    add_images
    add_css
    add_content
    generate_epub
  end

  private

  def create_book
    @book = GEPUB::Book.new
    book.primary_identifier 'pointhistory.org', 'BookID', 'URL'
    book.add_title 'Pleasant Point: A History', title_type: GEPUB::TITLE_TYPE::MAIN
    book.add_creator 'O.P. Oliver'
  end

  def add_cover_image
    File.open(images_path.join('book-cover.jpg')) do |file|
      book.add_item('images/cover.jpg', content: file).cover_image
    end
  end

  def add_images
    add_cover_image
    Dir.glob([images_path.join('ch*.jpg'), images_path.join('1990-logo.jpg')]) do |path|
      file_name = File.basename(path)
      File.open(path) do |file|
        book.add_item("images/#{file_name}", content: file)
      end
    end
  end

  def images_path
    Rails.root.join('app', 'assets', 'images')
  end

  def pages_path
    Rails.root.join('app', 'views', 'pages')
  end

  def add_css
    css_path = Rails.root.join('app', 'assets', 'stylesheets', 'epub.css')
    File.open(css_path) do |file|
      book.add_item('style/default.css', content: file)
    end
  end

  def add_content
    book.ordered do
      add_intro
      chapters = ChapterBuilder.new.build_chapters
      chapters.each_with_index do |chapter, index|
        add_chapter(chapter, index)
      end
    end
  end

  def add_intro
    filename = '_quote.html.erb'
    content = content_for_erb(pages_path.join(filename))
    doc = build_document(nil, content)
    item = book.add_item('text/intro.xhtml')
    item.add_raw_content(doc)
  end

  def add_chapter(chapter, index)
    content = content_for_chapter_at_index(index)
    replace_html!(content)
    doc = build_document(chapter.name, content)
    item = book.add_item("text/chap#{index}.xhtml")
    item.add_raw_content(doc)
    item.toc_text(chapter.name)
  end

  def generate_epub
    epubname = Rails.root.join('tmp', 'pointhistory.epub')
    book.generate_epub(epubname)
  end

  def content_for_chapter_at_index(index)
    filename = "_ch_#{format('%02d', index)}.html.erb"
    content_for_erb(pages_path.join(filename))
  end

  def content_for_erb(path)
    html = File.open(path).read
    template = ERB.new(html)
    template.result(binding)
  end

  def replace_html!(content)
    content.gsub!('src="/images', 'src="../images')
    content.gsub!('&ndash;', '–')
    content.gsub!('&mdash;', '—')
  end

  def build_document(title, content)
    <<-HTML
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>#{title}</title>
        <link rel="stylesheet" type="text/css" href="../style/default.css"></link>
      </head>
      <body>
        <p>#{content}</p>
      </body>
    </html>
    HTML
  end
end
