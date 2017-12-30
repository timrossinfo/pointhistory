module ApplicationHelper
  def site_name
    'Pleasant Point - A History'
  end

  def full_title(page_title)
    base_title = site_name
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def meta_description(description)
    content_for :meta_description, description
  end
end
