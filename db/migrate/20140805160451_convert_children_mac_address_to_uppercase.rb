class ConvertChildrenMacAddressToUppercase < ActiveRecord::Migration
  def change
  	Child.all.each do |child|
  		unless child.save
  		  puts "\n\nChild invalid: #{child.id}:\n child.errors.full_messages.join('\n')\n"
  		end
  	end
  end
end
