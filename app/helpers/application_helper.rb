module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end

  # def cp_menu paths
  #   paths.each do |path|
  #     if request.url.include?(path)
  #       return "active"
  #     end
  #   end
  # end

  def cp_menu path
    "active" if request.url.include?(path)
  end

end

