class PagesController < ApplicationController
  def home
    @chapters = Rails.cache.fetch('chapters') do
      ChapterBuilder.new.build_chapters
    end
  end
end
