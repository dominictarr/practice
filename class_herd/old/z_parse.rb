
module ClassHerd
require 'monkeypatch/array'
class ZParse

	def initialize (schema)
		@schema = schema
	end

	def match(schema, item)
		if item.is_a? Array then
			item = item.first
		end
		schema.find {|it|
			if it.is_a? Array then
				it.first == item
			else
				it == item
			end}
	end

	def parse_group(schema,data)
		result = []
		data.each{
			|item|
			parse_item(schema,item,result)
		}
		result
	end

	def parse_item(schema,item,result)
		group = match(schema,item)
		
		#if items is a group, process with group rule.
		#and add result into 
		if group.nil? then #no match, parse sub items
			if item.is_a? Array then
				item.tail.each{ |it|
					parse_item(schema,it,result)
				}
			else
				return nil
			end
		elsif group.is_a? Array 
			#and item.is_a? Array
			then#parse item with groups rule.
			if item.is_a? Symbol then 
				raise "expecting group to be array, not symbol:" + item.inspect
			end
			puts "schema: #{group.tail.inspect} item: #{item.inspect}"
			result << [group.first] + parse_group(group.tail,item.tail)
			#have to go group.tail to remove the group symbol.
			#this is a FRAGILE!
		else #just add the item.
			result << item
		end
	end

	def parse (data)
		result = []
		parse_item(@schema,data,result)
		result
	end

end;end
