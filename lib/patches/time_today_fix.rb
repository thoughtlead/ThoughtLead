require 'time'
def Time.today
  t = Time.now
  t - (t.to_i % 86400)
end unless Time.respond_to? :today