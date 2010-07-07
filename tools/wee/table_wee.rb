require 'rubygems'
require 'wee'
require 'monkeypatch/module'
require 'tools/table'


class TableWee < Wee::Component

quick_attr :table


def render (r)
	table = @table.table
	r.table{
		r.table_row{
			@table.headers.each{|h|
				r.table_header h
			}}
		table.each {|row|
			r.table_row{
				@table.headers.each_index{|index|
					r.table_data @table.table_data(row,index)
				}}}
	}
end

end



if __FILE__ == $0 
class TestTable < TableWee
def initialize 
	super
	table(Table.new.tabulate([[1,2,3,4],[5,6,7,8]]).headers(:a,:b,:c,:d))
end
end
Wee.runcc(TestTable, :server => :Mongrel) 
end
