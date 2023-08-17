class User < ApplicationRecord
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         :validatable,
        :omniauthable,
        omniauth_providers: %i[google_oauth2 facebook],
        jwt_revocation_strategy: JwtDenylist
  # validates :first_name, :last_name, presence: true


  def self.signin_or_create_from_provider(provider_data)
    where(provider: provider_data[:provider], uid: provider_data[:uid]).first_or_create do |user|
      user.email = provider_data[:info][:email]
      full_name = provider_data[:info][:name].split(' ')
      user.first_name =  full_name[0]
      user.last_name = full_name[1]
      user.password = Devise.friendly_token[0, 20]
      user.password_confirmation = user.password
    end
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
