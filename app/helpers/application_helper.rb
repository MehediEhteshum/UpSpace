module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def resource_class
    User
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def avatar_url(user, size='thumb')
    if user.avatar
      user.avatar.image.url(size)
    elsif user.image
      if user.provider == "facebook"
        size = size == 'thumb' ? 'small' : 'large'
        "http://graph.facebook.com/#{user.uid}/picture?type=#{size}"
      else
        user.image
      end
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      size = size == 'thumb' ? '100' : '350'
      "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=mm&s=#{size}"
    end
  end

  def stripe_express_path
    "https://connect.stripe.com/oauth/authorize?response_type=code&client_id=#{ENV['STRIPE_CLIENT_ID']}&scope=read_write"
  end

  def stripe_express_login_path
    "https://connect.stripe.com/login?redirect=%2Foauth%2Fauthorize%3Fscope%3Dread_write%26response_type%3Dcode%26client_id%3D#{ENV['STRIPE_CLIENT_ID']}&force_login=true"
  end

  def binary_icon(fa_icon, is_amenity)
    color = is_amenity ? "icon-green" : "icon-grey"
    content_tag :i, nil, class: ["fas", fa_icon, "fa-2x", "inline", color]
  end

  def local_time_with_timezone(date, time_zone)
    date.in_time_zone(time_zone).localtime.strftime('%h %d, %G %-l:%M%P %Z')
  end

  def local_time_without_timezone(date, time_zone)
    date.in_time_zone(time_zone).localtime.strftime('%h %d, %G')
  end

end
