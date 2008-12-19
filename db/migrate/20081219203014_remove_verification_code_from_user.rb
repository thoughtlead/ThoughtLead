class RemoveVerificationCodeFromUser < ActiveRecord::Migration
	def self.up
		remove_column(:users, :verification_code)
	end

	def self.down
		add_column(:users, :verification_code, :string)
	end
end
