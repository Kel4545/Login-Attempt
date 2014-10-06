class User < ActiveRecord::Base
  validates_presence_of :email, :password
  validates_uniqueness_of :email


  def login_attempt_counter
      self.increment_counter(:logins, 0)
    end

    def check_user_logins
      if self.logins >= 4
        self.wait_1_minute
      else
        self.login_attempt_counter
      end
    end

    def erase_logins
      self.update(logins: 0)
    end

    def wait_1_minute
      if (DateTime.now.to_i - self.updated_at.to_i) < 60   
       self.update(login_attempt_counter)

      else
        erase_logins
        login_attempt_counter
      end
    end


  end
