# Just incase this will have any adverse effects on other platforms...
if RUBY_PLATFORM =~ /mswin32/
  require 'tempfile'
  class Tempfile
    def size
      if @tmpfile
        @tmpfile.fsync # added this line
        @tmpfile.flush
        @tmpfile.stat.size
      else
        0
      end
    end
  end
  
  require 'technoweenie/attachment_fu/backends/s3_backend'
  module Technoweenie
    module AttachmentFu
      module Backends
        module S3Backend
          protected
          def save_to_storage
            if save_attachment?
              S3Object.store(
                             full_filename,
               (temp_path ? File.open(temp_path, "rb") : temp_data), # added , "rb"
              bucket_name,
              :content_type => content_type,
              :access => attachment_options[:s3_access]
              )
            end
            
            @old_filename = nil
            true
          end
        end
      end
    end
  end
end #if RUBY_PLATFORM =~ /mswin32/