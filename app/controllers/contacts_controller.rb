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
      flash.now[:notice] = 'Thank you for your message!'
    else
      flash.now[:error] = 'Your message could not be sent.'
      render :new
    end
  end
end
