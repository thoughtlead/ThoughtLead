require File.dirname(__FILE__) + '/../test_helper'

class CustomerTest < Test::Unit::TestCase

  def test_password_required
    customer = new_valid_customer(:login => 'my_login', :email => 'me@example.com')
    assert(customer.send(:password_required?))
    
    customer.password = "wow"
    customer.password_confirmation = "wow"
    assert(customer.save)
    
    customer = Customer.find(customer.id)
    assert(!customer.send(:password_required?))
    
    customer.password_required = true
    assert(customer.send(:password_required?))

    customer = Customer.find(customer.id)
    customer.password = "   "
    assert(!customer.send(:password_required?))
    customer.password_confirmation = "  "
    assert(!customer.send(:password_required?))
    
    customer.password = "Something"
    assert(customer.send(:password_required?))

    customer = Customer.find(customer.id)
    assert(!customer.send(:password_required?))

    customer.password_confirmation = "Something"
    assert(customer.send(:password_required?))
  end

  def test_should_create_customer
    assert_difference 'Customer.count' do
      customer = new_valid_customer
      assert customer.save
      assert !customer.new_record?, "#{customer.errors.full_messages.to_sentence}"
    end
  end

  def test_should_reset_password
    customers(:duff).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal customers(:duff), Customer.authenticate('duff', 'new password')
  end

  def test_should_not_rehash_password
    customers(:duff).update_attributes(:login => 'duff2')
    assert_equal customers(:duff), Customer.authenticate('duff2', 'test')
  end

  def test_should_authenticate_customer
    assert_equal customers(:duff), Customer.authenticate('duff', 'test')
  end

  def test_should_set_remember_token
    customers(:duff).remember_me
    assert_not_nil customers(:duff).remember_token
    assert_not_nil customers(:duff).remember_token_expires_at
  end

  def test_should_unset_remember_token
    customers(:duff).remember_me
    assert_not_nil customers(:duff).remember_token
    customers(:duff).forget_me
    assert_nil customers(:duff).remember_token
  end

  private
    def new_valid_customer(options = {})
      Customer.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end

end
