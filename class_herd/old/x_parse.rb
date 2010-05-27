require 'monkeypatch/array'

module ClassHerd
class XParse

	def initialize(schema)
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

	def parse_item(it, schema, result)
		#match finds the schema group which matches this item.
		group = match(schema,it)
		#puts "#{it.inspect} = #{group.inspect}"
		#if this item is a list, process it recursively.
		#if group is a array pass that
		#puts it.inspect
		if group.nil? then
			if it.is_a? Array then#add to this level
				it.each{|it|
				append_level(it,schema, result)
				}
			end	
		elsif group.is_a? Array then 
			#if group is an array, it's a sub rule
			[it.first] + stack_level(it.tail,group)
			#~ elsif it.is_a? Array then
			#~ result << it
		else
			puts "IT:" + it.inspect
			result << it
		end	
	end

	def stack_level(data, schema)
		result = []
		data.each {|it|
			r = []
			parse_item(it,schema,r)
			if r.length > 0 then result << r; end
		}
		result
	end

	def append_level(data, schema,result)
		data.each {|it|
			r =  []
			parse_item(it,schema,r)
			if r.length > 0 then result << r; end
		}
#		puts "RESULT:" + result.inspect
		result
	end


	def parse(data)
		parse_item(data,@schema,[])
	end

end;end