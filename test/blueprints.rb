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
  word { Faker::Lorem.words(1).first }
  price { rand * 100 }
  period { 1 + rand(6) }
  units { SubscriptionPlan.units.rand }
  paragraphs { Faker::Lorem.paragraphs }
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
  community { Community.make }
end

SubscriptionPlan.blueprint do
  name { Sham.word }
  amount { Sham.price }
  renewal_period { Sham.period }
  renewal_units { Sham.units }
  trial_period { Sham.period }
  trial_units { Sham.units }
  access_class { AccessClass.make }
end

Subscription.blueprint do
  subscription_plan { SubscriptionPlan.make }
  access_class { subscription_plan.access_class }
  user { User.make(:community => access_class.community, :access_class => access_class) }
  amount { subscription_plan.amount }
  renewal_period { subscription_plan.renewal_period }
  renewal_units { subscription_plan.renewal_units }
  state "active"
  next_renewal_at { Date.today.advance({renewal_units => renewal_period}.symbolize_keys) }
  card_number "XXXX-XXXX-XXXX-0027"
  card_expiration "12-2009"
  billing_id "12345"
end

Course.blueprint do
  title { Sham.sentence }
  description { Sham.sentence }
  community { Community.make }
  user { User.make(:community => community) }
  draft false
end

Chapter.blueprint do
  name { Sham.sentence }
  course { Course.make }
  draft false
end

Lesson.blueprint do
  chapter { Chapter.make }
  content { Content.make(:user => chapter.course.user) }
end

Content.blueprint do
  title { Sham.sentence }
  body { Sham.paragraphs }
  teaser { Sham.sentence }
  user { User.make }
  draft false
  registered false
end