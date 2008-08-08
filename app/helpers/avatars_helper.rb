module AvatarsHelper
  def avatar_link_for(user, size = :medium) 
    link_to(avatar_for(user, size), user)
  end 

  def avatar_for(user, size = :medium) 
    image_tag(avatar_filename(user, size), :id => "profile_avatar", :size => IMAGE_DIMENSIONS[size])
  end
  
  def avatar_filename(user, size = :medium) 
    if user.avatar 
      user.avatar.public_filename(size)
    else 
      "default_avatar_#{size}.png"
    end 
  end
  
end