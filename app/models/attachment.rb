class Attachment < ActiveRecord::Base
  belongs_to      :user
  belongs_to      :content
  has_attachment  :storage => :s3, :max_size => 150.megabytes, :s3_access => :authenticated_read, :content_type => [:image,"video/x-flv","video/mpg","video/mp4","video/quicktime","video/x-msvideo","audio/x-mp3"]
  validates_as_attachment
  
  after_attachment_saved do |record|
    process_video(record) if record.content_type.include?('video')
  end

  def community
    content.community if content
  end

  def attachment_attributes_valid?
    errors.add_to_base("Uploaded file #{filename} is too large (150MB max).") if attachment_options[:size] && !attachment_options[:size].include?(send(:size))
    unless self.filename.blank?
      set_type_for_embedded_media
      errors.add_to_base("Uploaded file #{filename} has invalid content.") if embedded? && attachment_options[:content_type] && !attachment_options[:content_type].include?(send(:content_type))
    end
  end

  def type
    return 'panda' if encoded_with_panda?
    return 'image' if content_type.include?('image')
    return 'audio' if content_type.include?('audio')
    return 'video' if content_type.include?('video')
  end
  
    def legacy_video?
      type == 'video'
    end
    
    def image?
      type == 'image'
    end
    
    def audio?
      type == 'audio'
    end
    
    def video?
      encoded_with_panda?
    end
    
  def css_class
    return 'video' if legacy_video? or video?
    return type
  end
  
  def update_panda_status(panda_video)
    # If the video has been encoded, save the url of the standard quality flash video which users will watch
    if encoding = panda_video.find_encoding(PANDA_ENCODING)
      if encoding.status == 'success'
        self.filename = encoding.filename
        self.save_without_validation
      end
    end
  end
  
  def update_status(job)
    if job.successful?
      self.filename = job.output_media_file.url
      self.save_without_validation
    end
  end
  
  def encoded_with_panda?
    !self.panda_id.blank? 
  end
  
  def panda_embed_html
    %(<embed src="http://#{VIDEOS_DOMAIN}/player.swf" width="510" height="402" 
    allowfullscreen="true" allowscriptaccess="always" 
    flashvars="&displayheight=402&file=#{self.url}&image=#{self.screenshot_url}&width=510&height=402" />)
  end
  
  def panda_embed_js
  	%(<div id="flash_container_#{self.id}"><a href="http://www.macromedia.com/go/getflashplayer">Get the latest Flash Player</a> to watch this video.</div>
  	<script type="text/javascript">
    	var so = new SWFObject("http://#{VIDEOS_DOMAIN}/player.swf", 'mpl', '510', '402', '9.0.115', "http://#{VIDEOS_DOMAIN}/expressInstall.swf");
    	so.addParam('allowfullscreen', 'true');
    	so.addParam('allowscriptaccess', 'true');
    	so.addVariable('width', '510');
    	so.addVariable('height', '382');
    	so.addVariable('file', '#{self.url}');
    	so.addVariable('image', "#{self.screenshot_url}");
    	so.addVariable('type', 'flv');
    	so.addVariable('autostart', 'false');
    	so.write("flash_container_#{self.id}");
      var flashvars = {};
   	</script>)
	end

  
  def url
    if type == 'panda'  
      "http://#{VIDEOS_DOMAIN}/#{self.filename}"
    else
      authenticated_s3_url(:expires_in => 2.hours)
    end
  end

  def screenshot_url
    "#{self.url}.jpg"
  end
  
  # returns string containing 'article' or 'lesson' depending on the content's container
  def for_article_or_lesson?
    return '' unless content
    return 'article' if content.article_content?
    return 'lesson' if content.lesson_content?
    return ''
  end
   
  protected
  
  def self.process_video(record)
    input_file = record.s3_url.gsub("http://s3.amazonaws.com/","s3://")
    output_file = input_file + ".mp4"
    notification_url = "http://#{record.community.host}/media/#{record.id}/update_status"
    
    # Make sure it works in staging
    if $host_suffix
      notification_url += ".#{$host_suffix}"
    end
    
    job = FlixCloud::Job.new(
      :api_key => FLIXCLOUD_API_KEY, 
      :recipe_id => FLIXCLOUD_RECIPE_ID,
      :input_url => input_file, 
      :output_url => output_file,
      :notification_url => notification_url
    )
    
    if job.save
      record.update_attribute(:panda_id, job.id)
    end
  end
  
  def destroy_file_with_panda
    # Do nothing (for the moment) if encoded with panda
    return true if encoded_with_panda?
    # Otherwise, do what we normally do...
    destroy_file_without_panda
  end
  alias_method_chain :destroy_file, :panda
    
  private

  def set_type_for_embedded_media
    parts = self.filename.split(".")
    if parts.length > 1
      if parts.last.downcase == "flv"
        self.content_type = "video/x-flv"
      elsif parts.last.downcase == "mp3"
        self.content_type = "audio/x-mp3"
      end
    end
  end
end
