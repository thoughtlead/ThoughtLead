class Content < ActiveRecord::Base
  has_one :lesson
  has_one :article
  belongs_to :user
  has_many :attachments, :dependent => :destroy
  has_many :content_access_classes, :dependent => :destroy
  has_many :access_classes, :through => :content_access_classes

  attr_accessor :uploaded_attachment_data
  validates_presence_of :title, :body, :teaser

  alias_attribute :to_s, :title
  after_save :remove_old_embedded_media
  before_save :remove_bad_embedded_media

  # Adding an association with the user's community so that we can filter on community
  is_indexed :fields => ['title', 'body', 'teaser', 'draft'], :include => [{:association_name => 'user', :field => 'community_id'}]

  def community
    return article.community unless article.nil?
    return lesson.community unless lesson.nil?
    return nil
  end

  def content_attachments=(it)
    for attachment in it
      if(!attachment.blank?)
        the_attachment = Attachment.new
        the_attachment.uploaded_data = attachment
        self.attachments << the_attachment unless it.to_s.blank?
      end
    end
  end

  def embedded_media=(file)
    unless file.to_s.blank?
      @old_embedded_media = self.attachments.find_by_embedded(true) unless @old_embedded_media
      #not sure if bad is neccessary
      @bad_embedded_media = @new_embedded_media if @new_embedded_media
      @new_embedded_media = Attachment.new
      @new_embedded_media.uploaded_data = file
      @new_embedded_media.embedded = true
      self.attachments << @new_embedded_media
    end
  end

  def display_attachments
    extensions = {}
    attachments.to_a.each do |attachment|
      unless attachment.embedded?
        extension = attachment.filename.split(".").last
        if extensions[extension].blank?
          extensions[extension] = 1
        elsif
          extensions[extension] += 1
        end
      end
    end
    strings = []
    extensions.keys.each do |extension|
      num = extensions[extension]
      strings << ((num > 1) ? num.to_s + "-" : "") + extension
    end
    return strings * ", "
  end

  def teaser_text
    self.teaser + "<br/>" + self.body.slice(0,300) + "...";
  end

  private

  def remove_old_embedded_media
    @old_embedded_media.destroy if @old_embedded_media
  end

  def remove_bad_embedded_media
    #not sure if bad is neccessary
    @bad_embedded_media.destroy if @bad_embedded_media
  end
end