require 'nokogiri'
#testxml
root =nil
  builder = Nokogiri::XML::Builder.new do |xml|
#   xml.root{|xml|
	xml.root{
  xml.hello("hello!",:id => 124)
   xml.hello("hello2!",:id => 12423)
}
#	}
  end
 	
  puts builder.to_xml

