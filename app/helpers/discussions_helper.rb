module DiscussionsHelper
  def current_class_all
    return :current unless @theme || @discussion || action_name == "uncategorized"
  end

  def current_class_uncategorized
    return :current if (@discussion && @discussion.uncategorized?) || action_name == "uncategorized"
  end

  def current_class_for_theme(theme)
    return :current if @theme == theme
  end

  def timeago(time, options = {})
    start_date = options.delete(:start_date) || Time.new
    date_format = options.delete(:date_format) || :default
    delta_minutes = (start_date.to_i - time.to_i).floor / 60
    if delta_minutes.abs <= (60*24*30) # eight weeks… I’m lazy to count days for longer than that
      distance = distance_of_time_in_words(delta_minutes);
      if delta_minutes < 0
        "#{distance} from now"
      else
        "#{distance} ago"
      end
    else
      return "on #{time.to_s(date_format)}"
    end
  end

 #  def distance_of_time_in_words(minutes)
 #    case
 #    when minutes < 1
 #      "less than a minute"
 #    when minutes < 50
 #      pluralize(minutes, "minute")
 #    when minutes < 90
 #      "about one hour"
 #    when minutes < 1080
 #      pluralize((minutes / 60).round, "hour")
 #    when minutes < 1440
 #      "one day"
 #    when minutes < 2880
 #      "about one day"
 #    else
 #      pluralize((minutes / 1440).round, "day")
 #    end
 #  end

  def render_body(item)
    textilize(sanitize(item.body))
  end
end
