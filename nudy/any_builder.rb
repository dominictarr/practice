class AnyBuilder

def klass (k)
	@klass = k
	self
end
def defaults(map)
	@map = map
	self
end
def attrs(*maps)
	@each_map = maps	
	self
end
def table (headers,table)
	unless headers.is_a? Array then
		headers = [headers]
		table = table.collect {|c| [c]}
	end
	@each_map = []
	table.each{|row|
		map = Hash.new
		@each_map << map
		headers.each_index{|i|
			key = headers[i]
			map[key] = row[i]
	}}
	self
end
def build_one (map = @map)
	n = @klass.new
	map.each {|k,v|
		n.method(k).call(v)
	}
	n
end
def build

if !@each_map then
	build_one
else
	@each_map.collect{|v|
		build_one(@map.merge(v))
	}
end

end
end
