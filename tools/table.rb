require 'rubygems'
require 'wee'
require 'monkeypatch/module'


class Table

quick_attr :headers, :tabulate, :show_nil, :table_type, :columns

#give a 
# list of objects, and method names
# hash
### or object and method_names
#2d array
def table
	if !headers.is_a? Array and  !headers.nil? then
		headers [headers]
	end
	if tabulate.is_a? Hash then
		@table = tabulate.to_a
		columns 2
		table_type Array
	elsif tabulate.is_a? Array
		#if it's objects...
		tabulate.find{|f| ! f.is_a? Array}	
		if tabulate.find{|f| ! f.is_a? Array} then
			#get the header from each object
			columns headers.length
			table_type Object
#			raise "not implemented yet"
			if headers.nil? or  headers.empty? then
				raise "cannot make table from object array without headers"
			end
			@table = []
			tabulate.each{|r|
				@table << row = []
				headers.each{|h|
				if r.respond_to? h then
					row << r.method(h).call
				else
					row << nil
				end
				}
			}
		else
		#if it's a 2d array
			@table = tabulate
			columns 0
			table_type Array
			@table.each {|r| columns r.length if r.length  > columns}
		end
		#or if it's primitives!... we don't need that yet.
		#or some elements could be Components!
	end

	if headers and headers.length != columns then
		raise "header and table has different number of columns"
	end
	#if it gets this far it's a valid table...
	@table	
end
alias :to_a :table

def table_data (row,index)
#	if table_type == Array then
		row[index]
#	end
end
def rows
	@table.length
end

def to_s (s=",",n="\n")#what about fixed width?
	p = []
	p << headers.join(s) if headers
	table.each{|row|
		p << row.map{|m| m.nil? ? show_nil : m}.join(s)
	}
	p.join(n)
end
end
