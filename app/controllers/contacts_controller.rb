class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    if verify_recaptcha(model: @contact)
      @contact = Contact.new(params[:contact])
      @contact.request = request
      if @contact.deliver
        flash.now[:notice] = 'Thanks for your message! We will contact you soon.'
      else
        flash.now[:error] = 'Cannot send message. Please try again.'
        render :new
      end
    end
  end

end
