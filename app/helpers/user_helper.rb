module UserHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, size: Settings.DEFAULT_SIZE_GRAVATAR
    gravatar_id  = Digest::MD5.hexdigest user.email.downcase
    gravatar_url = Settings.gravatar_url << "#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
