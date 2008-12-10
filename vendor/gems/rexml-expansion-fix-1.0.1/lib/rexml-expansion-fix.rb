# Copyright (c) 2008 Michael Koziarski <michael@koziarski.com>
# 
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

require 'rexml/document'
require 'rexml/entity'

module REXML
  class Entity < Child
    def unnormalized
      # Due to an optimisation in REXML, the default entities aren't
      # associated with a document.  As these enties are defined and
      # not recursive, we know that expanding them won't cause any
      # issues.  Other entities in the document will still have
      # the association to the document preventing this from opening
      # a new attack vector.
      document.record_entity_expansion! if document
      v = value()
      return nil if v.nil?
      @unnormalized = Text::unnormalize(v, parent)
      @unnormalized
    end
  end
  class Document < Element
    @@entity_expansion_limit = 10_000
    def self.entity_expansion_limit= val
      @@entity_expansion_limit = val
    end
    
    def record_entity_expansion!
      @number_of_expansions ||= 0
      @number_of_expansions += 1
      if @number_of_expansions > @@entity_expansion_limit
        raise "Number of entity expansions exceeded, processing aborted."
      end
    end
  end
end

