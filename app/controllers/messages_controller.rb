class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy, :set_message]
  before_action :get_params, only: [:index]
  before_action :get_collections, only: [:new, :create]

  # GET /messages
  # GET /messages.json
  def index
    if current_user.admin?
      @messages = Message.all.order('id DESC').paginate(:page => @page,:per_page => @per_page)
    elsif current_user.parent?
      @messages = current_user.parent.app.messages.order('id DESC').paginate(:page => @page,:per_page => @per_page)
    elsif current_user.supervisor?
      @messages = current_user.supervisor.app.messages.order('id DESC').paginate(:page => @page,:per_page => @per_page)
    else
      @messages = []
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new({message_type: params[:type]}.merge(params[:message] || {}))
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message_type = params[:message] ? params[:message][:message_type] : params[:type]
    if app_required?
      if current_user.admin?
        @app = App.find(params[:app_id]) if params[:app_id]
        @app = App.find(params[:message][:app_id]) if params[:message] && params[:message][:app_id]
        @parent = Parent.find(params[:parent_id]) if params[:parent_id]
        @parent = Parent.find(params[:message][:parent_id]) if params[:message] && params[:message][:parent_id]
      else
        @app = current_user.supervisor.app
        @app = nil if params[:app_id] && (@app.id.to_s != params[:app_id].to_s)
      end
      @parent = @app.supervisor if @app
      @app = @parent.app if @parent
    end
    @child = Child.find(params[:child_id]) if params[:child_id]
    @child = Child.find(params[:message][:child_id]) if params[:message] && params[:message][:child_id]
    @located_at = Time.now
    if Message::MessageTypes::CHECK_IN == @message_type
      @message = Message.send_check_in(@child, @app, @located_at)
      EventLog.createCheckInMessage(current_user, @message)
    elsif Message::MessageTypes::CHECK_OUT == @message_type
      @message = Message.send_check_out(@child, @app)
      EventLog.createCheckOutMessage(current_user, @message)
    elsif Message::MessageTypes::COME_HOME == @message_type
      @recipient_child = Child.find([:recipient_child_id]) if params[:recipient_child_id]
      @recipient_child = Child.find(params[:message][:recipient_child_id]) if params[:message] && params[:message][:recipient_child_id]
      @message = Message.send_come_home(@app, @recipient_child)
      EventLog.createComeHomeMessage(current_user, @message)
    end

    respond_to do |format|
      if @message.save
        format.html { redirect_to messages_url, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new, message: params[:message] }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to messages_url, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /message/1
  def confirm
    @message.received!
    respond_to do |format|
      if @message.valid?
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def get_params
      @message_type = params[:type]
      @page = params[:page]
      @timestamp = params[:timestamp].blank? ? nil : Time.at(params[:timestamp].to_i)
      @per_page = params[:per_page]
      if @per_page.blank?
        @per_page = @timestamp ? 10000 : 10
      end
    end

    def app_required?
      [
        Message::MessageTypes::CHECK_IN,
        Message::MessageTypes::CHECK_OUT,
        Message::MessageTypes::COME_HOME
      ].include?(@message_type)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:child_id, :app_id, :parent_id, :recipient_child_id, :type)
    end

    def get_collections
      @children = Child.all
      @parents = Parent.all
    end
end
