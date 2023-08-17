Rails.configuration.to_prepare do
  ActiveStorage::Blob.class_eval do
    before_create :generate_key_with_prefix

    def generate_key_with_prefix
      self.key = File.join "#{Rails.env}/", self.class.generate_unique_secure_token
    end
  end
end
