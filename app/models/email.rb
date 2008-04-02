class Email < ActiveRecord::Base
  validates_presence_of :subject
  validates_presence_of :body
  
end
