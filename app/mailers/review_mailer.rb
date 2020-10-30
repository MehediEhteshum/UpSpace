class ReviewMailer < ApplicationMailer

  def send_review_notification(review)
    @review = review
    @guest = User.find(review.guest_id)
    @host = User.find(review.host_id)
    subject = review.type == 'GuestReview' ? 'New Review by Guest!' : 'New Review by Host!'
    mail(to: ENV['ADMIN_EMAIL'], subject: subject)
  end

end
