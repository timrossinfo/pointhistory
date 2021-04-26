class PagesController < ApplicationController
  before_action :load_chapters
  before_action :cache_headers

  def home; end

  def chapter
    @index = @chapters.find_index { |c| c.id == params[:id] }
    @chapter = @chapters[@index]
    @prev = @chapters[@index - 1] if @index > 0
    @next = @chapters[@index + 1] if @index < @chapters.length
  end

  private

  def load_chapters
    @chapters = Rails.cache.fetch('chapters') do
      ChapterBuilder.new.build_chapters
    end
  end

  def cache_headers
    expires_in 1.day, public: true
  end
end
