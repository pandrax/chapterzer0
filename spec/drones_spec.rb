require 'spec_helper'

=begin User specs as an example
describe User do
	before(:each) do
		@attr = { 
			:name => "Example User", 
			:email => "user@example.com",
			:password => "foobar",
			:password_confirmation => "foobar"
		}
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end
	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name =>  ""))
		no_name_user.should_not be_valid
	end
	it "should reject names that are too long" do
		long_name = "a"*51
		long_name_user = User.new(@attr.merge( :name => long_name ))
		long_name_user.should_not be_valid 
	end
	it "should accept valid email addresses" do
		addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
		addresses.each do |address|
			valid_email_user = User.new(@attr.merge(:email => address))
			valid_email_user.should be_valid 
		end
	end
	it "should reject invalid email addresses" do
		addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
		addresses.each do |address|
			invalid_email_user = User.new(@attr.merge(:email => address))
			invalid_email_user.should_not be_valid 
		end
	end
	it "should reject duplicate email addresses" do
		User.create!(@attr)
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid 
	end
	it "should reject email addresses identical up to case" do
		upcased_email = @attr[:email].upcase
		User.create!(@attr.merge(:email => upcased_email))
		user_with_duplicate_email = User.new(@attr)
		user_with_duplicate_email.should_not be_valid 
	end
	describe "password validations" do

		it "should require a password" do
			User.new(@attr.merge(:password => "", 
													 :password_confirmation => "")).should_not be_valid 
		end
		it "should require a matching password confirmation" do
			User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid 
		end
		it "should reject short passwords" do
			short_password = "a" * 5
			hash = @attr.merge(:password => short_password, 
												 :password_confirmation => short_password)
			User.new(hash).should_not be_valid 
		end
		it "should reject long passwords" do
			long_password = "a" * 51
			hash = @attr.merge(:password => long_password, 
												 :password_confirmation => long_password)
			User.new(hash).should_not be_valid 
		end
	end
	describe "password encryptions" do
		before(:each) do
			@user = User.create!(@attr)
		end
		it "should have an encrypted password attribute" do
			@user.should respond_to( :encrypted_password )
		end
		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end
		describe "has password? method" do
			it "should be true if the passwords match" do
				@user.has_password?(@attr[:password]).should be_true
			end
			it "should be false if the passwords don't match" do
				@user.has_password?("invalid").should be_false
			end
		end
		describe "authenticate method" do
			it "should return nil on email/password mismatch" do
				wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
				wrong_password_user.should be_nil
			end
			it "should return nil for an email address with no user" do
				nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
				nonexistent_user.should be_nil
			end
			it "should return the user on email/password match" do
				matching_user = User.authenticate(@attr[:email], @attr[:password])
				matching_user.should == @user
			end
		end
	end
	describe "admin attribute" do
		before(:each) do 
			@user = User.create!( @attr )
		end
		it "should respond to admin" do
			@user.should respond_to( :admin )
		end
		it "should not be an admin by default" do
			@user.should_not be_admin
		end
		it "should be convertible to an admin" do
			@user.toggle!(:admin)
			@user.should be_admin
		end
	end
end
=end

describe Textdrone do
	before(:each) do
		textdrone = Textdrone.new
		testdata1 = "/home/tom/code/chapterzer0/spec/testdir1/"
		testdata2 = "/home/tom/code/chapterzer0/spec/testdir2/"
	end

	describe "snitching" do
		describe "wordcount method" do
			it "should count the words in the testdata directory" do
				textdrone.wordcount( testdata ).should == 6
			end
		end
		describe "post_wordcount method" do
			it "should mention 'n words' in there somewhere" do
				post = textdrone.post_wordcount( testdata ) 
				post =~ /%d+ words/
				$1.should_be true
			end
		end
	end
end

# other drones