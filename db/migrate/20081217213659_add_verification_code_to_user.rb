class AddVerificationCodeToUser < ActiveRecord::Migration
	def self.up
		add_column(:users, :verification_code, :string)
	end

	def self.down
		remove_column(:users, :verification_code)
	end
end
