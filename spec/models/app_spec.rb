require 'rails_helper'

RSpec.describe App, :type => :model do
  describe "create_android_app" do

    it "success" do
      a = App.create_android_app
      a.name.should == "Playcelet Phone"
      a.version.should == "Android"
    end
  end

end
