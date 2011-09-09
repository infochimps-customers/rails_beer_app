module ApplicationHelper

  def link_to_twitter_profile screen_name_or_user_id
    return unless screen_name_or_user_id.present?
    if screen_name_or_user_id.is_a?(Fixnum)
      base_url = "http://twitter.com/account/redirect_by_id?id="
      text     = screen_name_or_user_id.to_s
    else
      base_url = "http://twitter.com/"
      text     = "@" + screen_name_or_user_id.to_s
    end
    link_to(text, base_url + screen_name_or_user_id.to_s, :target => :_blank)
  end

  def highlight_demo_params text
    %w[trstrank city strong_links].each do |param|
      text.gsub!(Regexp.new('"' + param + '"'), "<span class='demo_param'>#{param}</span>")
    end
    text.html_safe
  end
  
end
