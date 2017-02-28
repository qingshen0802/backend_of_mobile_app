class ClearInfosAndMessagesAndPlayInvitations < ActiveRecord::Migration
  def change
  	Info.destroy_all
  	Message.destroy_all
  	PlayInvitation.destroy_all
  end
end
