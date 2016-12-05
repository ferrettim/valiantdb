module ApplicationHelper

  def active_page(active_page)
    @active == active_page ? "active" : ""
  end

  def pluralize(number, text)
    return text.pluralize if number != 1
    text
  end

end
