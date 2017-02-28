class UsePdtForInvitationTextInPlayInvitations < ActiveRecord::Migration
  def change
  	PlayInvitation.all.each do |pi|
  		pi.set_default_invitation_text
  		pi.save
  	end
  end
end
