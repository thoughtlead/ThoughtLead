Sham.define do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  company_name { Faker::Company.name }
  domain_name { Faker::Internet.domain_name }
  first_name { Faker::Name.first_name }
  last_name { Faker::Name.last_name }
  password { (1..10).map { ('a'..'z').to_a.rand }.join }
  sentence { Faker::Lorem.sentence }
  city { Faker::Address.city }
  word { Faker::Lorem.words(1) }
end

Community.blueprint do
  name { Sham.company_name }
  host { Sham.domain_name }
  owner { User.make(:community => object) }
  active true
end

User.blueprint do
  first_name { Sham.first_name }
  last_name { Sham.last_name }
  display_name { "#{first_name} #{last_name}" }
  login { Faker::Internet.user_name(display_name) }
  password { Sham.password }
  password_confirmation { password }
  email { Sham.email }
  community { Community.make }
  about { Sham.sentence }
  interests { Sham.sentence }
  website_1 { Sham.domain_name }
  location { Sham.city }
end

AccessClass.blueprint do
  name { Sham.word }
end
