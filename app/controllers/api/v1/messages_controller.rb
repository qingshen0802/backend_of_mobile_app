class Api::V1::MessagesController < Api::BaseController
  include CalculateUserDetailsActions

  protect_from_forgery with: :null_session

  before_action :get_params, only: :index
  before_action :set_message, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :calculate_user_details, only: :create
  respond_to :json

  # GET /messages.json
  def index
    EventLog.getMessages(current_user)
    if current_user.admin?
      @messages = Message.all.by_message_type(@message_type).after(@timestamp).paginate(:page => @page,:per_page => @per_page)
    elsif current_user.parent?
      @messages = current_user.parent.app.messages.by_message_type(@message_type).after(@timestamp).paginate(:page => @page,:per_page => @per_page)
    elsif current_user.supervisor?
      @messages = current_user.supervisor.app.messages.by_message_type(@message_type).after(@timestamp).paginate(:page => @page,:per_page => @per_page)
    else
      @messages = []
    end
  end

  # GET /messages/1.json
  def show
  end

  # POST /messages.json
  def create
    if current_user.admin?
      @app = App.find(params[:app_id])
    else
      @app = current_user.supervisor.app
      @app = nil if params[:app_id] && (@app.id.to_s != params[:app_id].to_s)
    end
    @located_at = Time.now
    if params[:playcelet_ids]
      @messages = []
      params[:playcelet_ids].split(',').each do |playcelet_id|
        if (params[:type] == Message::MessageTypes::CHECK_IN)
          @child = Child.find_by_mac_address(playcelet_id)
          if @child
            @message = Message.send_check_in(@child, @app, @located_at)
            @messages << @message
            EventLog.createCheckInMessage(current_user, @message)
          end
        elsif params[:type] == Message::MessageTypes::CHECK_OUT
          @child = Child.find_by_mac_address(playcelet_id)
          if @child
            @message = Message.send_check_out(@child, @app)
            @messages << @message
            EventLog.createCheckOutMessage(current_user, @message)
          end
        end
      end
    else
      @child = Child.find_by_mac_address(params[:playcelet_id])
      if @child.blank?
        render json: {code: 404, error: 'Child not found'}
        return
      elsif @app.blank?
        render json: {code: 404, error: 'Parent not found'}
        return
      end
      if (params[:type] == Message::MessageTypes::CHECK_IN)
        @message = Message.send_check_in(@child, @app, @located_at)
        EventLog.createCheckInMessage(current_user, @message)
      elsif params[:type] == Message::MessageTypes::CHECK_OUT
        @message = Message.send_check_out(@child, @app)
        EventLog.createCheckOutMessage(current_user, @message)
      elsif params[:type] == Message::MessageTypes::PLAY_INVITATION
        if params[:duration]
          @duration = params[:duration].to_i
        elsif params[:end_time]
          params[:end_time].is_a?(Integer)
          @end_time = params[:end_time].blank? ? nil : Time.at(params[:end_time].to_i)
        else
          @duration = 240
        end
        if params[:invited_playcelet_id]
          @invited_child = Child.find_by_mac_address(params[:invited_playcelet_id])
          if @invited_child.blank?
            render json: {code: 404, error: 'Invited Child not found'}
            return
          end
          create_play_invitation_from_child_to_child(@child, @invited_child, @app)
        elsif params[:invited_playcelet_ids]
          created_at_least_one = false
          params[:invited_playcelet_ids].split(',').each do |mac_address|
            @invited_child = Child.find_by_mac_address(mac_address)
            if @invited_child
              created_at_least_one = true
              create_play_invitation_from_child_to_child(@child, @invited_child, @app)
            end
          end
          unless created_at_least_one
            render json: {code: 404, error: 'Invited Children not found'}
            return
          end
        end
      end
    end

    if @messages
      @message = @messages.first 
      EventLog.createMessage(current_user, @message, params)
    end

    if @message && @message.valid?
      render json: {code: 200}.merge(json_user_details)
    elsif @messages && @messages.all?(&:valid?)
      render json: {code: 200}.merge(json_user_details)
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1.json
  def update
    if @message.update(message_params)
      render :show, status: :ok, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1.json
  def destroy
    @message.destroy
    head :no_content
  end

  # POST /message/1
  def confirm
    @message.received!
    if @message.valid?
      render json: {code: 200}
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
    def create_play_invitation_from_child_to_child(child, invited_child, app)
      @messages ||= []
      message_text = params[:text]
      message = Message.create_play_invitation_message(child, invited_child, message_text, app, @duration, @end_time)
      EventLog.createPlayInvitationMessage(current_user, message)
      @messages << message
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    def get_params
      @message_type = params[:type]
      @page = params[:page]
      @timestamp = params[:timestamp].blank? ? nil : Time.at(params[:timestamp].to_i)
      @per_page = params[:per_page]
      if @per_page.blank?
        @per_page = @timestamp ? 10000 : 10
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:playcelet_id, :invited_playcelet_id, :invited_playcelet_ids, :app_id, :type)
    end
end
