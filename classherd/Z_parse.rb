require 'monkeypatch/array'

module ClassHerd
class YParse

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
			r = parse_item(schema,item)
			if r then result << r end
		}
		result
	end

	def parse_item(schema,item)
		group = match(schema,item)
		
		#if items is a group, process with group rule.
		#and add result into 
		if group.nil? then #no match, parse sub items
			if item.is_a? Array then
				#raise "can't parse group without rule, #{item.inspect} not implemented yet"
				#parse items but dont nest output
				r = []
				item.tail.each{ |it|
					r << parse_item(schema,it)
				}
				return *r
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
			return [group.first] + parse_group(group.tail,item.tail) 
			#have to go group.tail to remove the group symbol.
			#this is a FRAGILE!
		else #just add the item.
			return item
		end
	end

	def parse (data)
		parse_item(@schema,data)
	end
	
end;end