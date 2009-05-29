task( :switch_domains  => :environment ) do
  c = Community.find :all, :conditions => "host LIKE '%thoughtlead.com'"
  puts "Found #{c.size} communities with thoughtlead.com host"
  puts "----"
  c.each do |h| 
    orig_host = h.host
    h.host = h.host.downcase.sub("thoughtlead.com","thoughtleadapp.com")
    puts "Converted #{orig_host} to #{h.host}..."
    h.save
  end
  puts "----"
  puts "Done!"
end