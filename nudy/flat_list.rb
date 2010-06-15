

class FlatList < Array

	def check_ancestor (c_type)
		if c_type.is_a? @list_type then
			@list_type
		else
			@list_type = @list_type.superclass
			check_ancestor (c_type)
		end
	end

	def check
		@flat = true
		@same_type = true
		@list_type = nil
		self.each {|e|
			puts "#{e.inspect}.is_a? #{Array} = #{e.is_a? Array}"
			if e.is_a? Array then 
				@flat = false
				@same_type = false
				puts "#{@flat}"
			end
			if !@list_type then
				@list_type = e.class
			elsif @list_type != e.class
				@same_type = false
				check_ancestor(e)
			end
		}
	end
	def is_flat?
		f = @flat
		check
#		puts "is_flat? #{f.inspect} => #{@flat}"
		@flat
	end
	def is_same_type?
		check
		@same_type
	end

	def what_type?
		check
#		if !(@flat and  @same_type)
#			raise "#{self.inspect} is not a #{FlatList} is_flat?=#{is_flat?} and is_same_type?=#{is_same_type?}"
#		else
			@list_type
#		end
	end
end
