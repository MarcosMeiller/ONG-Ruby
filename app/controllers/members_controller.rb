class MembersController < ApplicationController
  before_action :authorized
  before_action :rol_access, only: [:index]

  def index
    render json: {
      members: params[:page].present? ? one_page_hash : full_news_hash,
    },status: 200
  end

  def create
      @member = Member.new(member_params)
      if @member.save
          render json: @member , status: :created
      else
          render json: @member.errors, status: :unprocessable_entity
      end
  end

  def update
      @member = Member.find_by(id: params[:id], is_deleted: false)

      if @member.update!(member_params)
        render json: {
          message: "Member #{@member.id} updated",
          object: @member
        }
      else
          render json: @member.errors, status: 404
      end

  end

  def destroy
      set_memberid
      return render json: { error: "Member not found " }, status: 404 if @memberId.nil?
      if @memberId.is_deleted == false
      @memberId.update_attribute('is_deleted', true)
      render json: {
          message: 'Data deleted, but persistent in the database',
          object_deleted: @memberId
      }, status: :ok
      else
      render json: @memberId.errors, status: 404
      end
  end

  private

  def member_params
    params.permit(:id, :name, :facebookUrl, :instagramUrl, :linkedinUrl, :description, :memberImage)
  end

  def set_memberid
    param_member_id = params[:id]
    @memberId = Member.find(param_member_id)
  end

  def members
    Member.where(is_deleted: nil)
  end

  def number_of_pages
    (Member.count / Member.per_page).truncate + 1
  end

  def page
    params[:page].to_i
  end

  def one_page_hash
    {
      previous_page: page.zero? ? nil : "http://#{request.host}/members/query?page=#{page - 1}",
      members: empty_page?(page) ? 'Página vacia' : Member.paginate(page: page),
      next_page: page == number_of_pages ? nil : "http://#{request.host}/members/query?page=#{page + 1}"
    }
  end

  def empty_page?(page)
    Member.paginate(page: page).empty?
  end

  def full_news_hash
    hash = {}
    i = 0
    number_of_pages.times do
      hash["page#{i + 1}"] = {
        previous_page: i.zero? ? nil : "http://#{request.host}/members/query?page=#{i}",
        members: empty_page?(i + 1) ? 'Página vacia' : Member.paginate(page: i + 1),
        next_page: i == number_of_pages ? nil : "http://#{request.host}/members/query?page=#{i + 2}"
      }
      i += 1
    end
    hash
  end
end
