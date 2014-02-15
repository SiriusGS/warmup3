class User < ActiveRecord::Base
	# attr_accessible :username, :password, :count

	SUCCESS = 1
	ERR_BAD_CREDENTIALS = -1
	ERR_USER_EXISTS = -2
	ERR_BAD_USERNAME = -3
	ERR_BAD_PASSWORD = -4

	MAX_USERNAME_LENGTH = 128
	MAX_PASSWORD_LENGTH = 128

	def self.login(username, password)
		user = User.find_by(username: username)
		if user and user.password == password
			user.count +=1
			user.save
			return user.count
		else
			return ERR_BAD_CREDENTIALS
		end
	end

	def self.add(username, password)
		logger.debug "fgggo9gr----------n\n\n\\n\n\n\n\n\n\n\n"
		logger.debug User.find_by(username: username)
		logger.debug "wefwef\n\n\n\n\n\n"
		if User.find_by(username: username)
			return ERR_USER_EXISTS
		elsif !username or username == "" or username.length() > MAX_USERNAME_LENGTH
			return ERR_BAD_USERNAME
		elsif !password or password.length() > MAX_PASSWORD_LENGTH
			return ERR_BAD_PASSWORD
		else
			user = User.new(username: username, 
				count: 1, password: password)
			user.save
			return SUCCESS
		end
	end


	def self.TESTAPI_resetFixture()
		User.delete_all
		return SUCCESS
	end

end