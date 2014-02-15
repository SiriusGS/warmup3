class UsersController < ApplicationController

  skip_before_filter :verify_authenticity_token

  SUCCESS               =   1
  ERR_BAD_CREDENTIALS   =  -1
  ERR_USER_EXISTS       =  -2
  ERR_BAD_USERNAME      =  -3
  ERR_BAD_PASSWORD      =  -4

  MAX_USERNAME_LENGTH = 128
  MAX_PASSWORD_LENGTH = 128

  def index
  end


  def add
    if !request.headers["Content-Type"] == "application/json"
      render :json => {}, :status => 400
    else 
      code = User.add(params[:user], params[:password])
      if code >= 1
        render :json => {:errCode => SUCCESS, :count => code}
      else
        render :json => {:errCode => code}
      end
    end
  end


  def login
    if !request.headers["Content-Type"] == "application/json"
      render :json => {}, :status => 400
    else 
      code = User.login(params[:user], params[:password])
      if code >= 1
        render :json => {:errCode => SUCCESS, :count => code}
      else
        render :json => {:errCode => code}
      end
    end
  end

  def resetFixture
    if !request.headers["Content-Type"] == "application/json"
      render :json => {}, :status => 400
    else
      code = User.TESTAPI_resetFixture()
      render :json => {:errCode => code}
    end
  end


  def unitTests
    if !request.headers["Content-Type"] == "application/json"
      render :json => {}, :status => 400
    else
      if Rails.env == "production"
        output = `RAILS_ENV=development ruby -Itest test/models/user_test.rb`
      else
        output = `ruby -Itest test/models/user_test.rb`
      end
      logger.debug output
      testInfo = output.split(/\n/)
      testInfo = testInfo[-1].split(", ")
      render(:json=>{"nrFailed" => testInfo[2].split()[0].to_i, "output" => output,
        "totalTests" => testInfo[0].split()[0].to_i}, status:200)
    end

  end

  private

    def user_params
      params.require(:user).permit(:username, :count, :password)
    end


end