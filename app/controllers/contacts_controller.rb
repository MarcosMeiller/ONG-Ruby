class ContactsController < ApplicationController
    before_action :authorized
    before_action :rol_access, only: [:allContacts]

    def create
        @contact = @user.contacts.new(params_contact)
        if @contact.save
            UserNotifierMailer.new_contact(@user).deliver_now
            render json: @contact, status: :created
        else 
            render json: @contact.errors.full_messages, status: :unprocessable_entity
        end
    end

    def allContacts
        @contacts = Contact.where(is_deleted: false)
        render json: @contacts, status: :ok
    end
    
    def index
        @contacts = Contact.where(is_deleted: false).where(user_id: @user.id)
        if @contacts
         render json: @contacts, status: :ok
        else
            render json: {msg: "you dont have contacts"}, status: 204
        end
    end

    private

    def params_contact
        params.permit(:name, :email, :phone, :message)
      end
end
