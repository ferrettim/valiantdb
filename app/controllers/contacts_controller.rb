class ContactsController < ApplicationController

  def new
    @pgtitle = "Contact Us"
    @contact = Contact.new
  end

  def create
    @pgtitle = "Contact Us"
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      redirect_to root_url
      flash.now[:notice] = 'Your message was sent! Expect a reply shortly.'
    else
      flash.now[:error] = 'Your message could not be sent.'
      render :new
    end
  end
end
