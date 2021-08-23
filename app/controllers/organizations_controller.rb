# frozen_string_literal: true

# ORGANIZATION
class OrganizationsController < ApplicationController
  before_action :rol_access, except: [:index]

  # GETS
  # http://127.0.0.1:3000/organization/public

  def index
    @organizations = Organization.where({ is_deleted: false })

    if @organizations
      render json: @organizations.as_json(
        only: %I[name email address phone social_network],
        include: %I[picture slides]
      ),
             status: :ok
    else
      render json: { message: 'Organization not found' }, status: 404
    end
  end

  # POST
  # http://127.0.0.1:3000/organizations

  def create
    @organization = Organization.new(params_organization)
    # Call private function
    asign_social_network

    if @organization.save
      render json: @organization
    else
      render json: @organization.errors.full_messages, status: :unprocessable_entity
    end
  end

  # POST
  # http://127.0.0.1:3000/organization/public/12

  def update
    @organization = Organization.find_by({ id: params[:id], is_deleted: false })

    return render json: { status: false, msg: 'Organization not found' }, status: 404 unless @organization.present?

    if @organization.update(params_organization)
      render json: {
        message: "Organization #{@organization.id} updated",
        object: @organization
      }
    else
      render json: @organization.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def params_organization
    params.permit(:name, :email, :welcomeText, :picture)
  end

  def params_network
    params.permit(:facebook, :linkedin, :instegram)
  end

  def asign_social_network
    params_network.each do |key, value|
      @organization.social_network[key] = value unless value.empty? && (@organization.social_network.key? key)
    end
  end
end