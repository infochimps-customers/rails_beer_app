module ApplicationHelper

  def link_to_twitter_profile screen_name
    link_to("@" + screen_name, "http://twitter.com/" + screen_name, :target => :_blank)
  end


  def highlight_demo_params text
    %w[trstrank city strong_links].each do |param|
      text.gsub!(Regexp.new('"' + param + '"'), "<span class='demo_param'>#{param}</span>")
    end
    text.html_safe
  end
  
  
end
