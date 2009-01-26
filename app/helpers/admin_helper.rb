module AdminHelper
  def current_class_for_action(link_action_name)
    return :current if link_action_name == action_name
  end
end
