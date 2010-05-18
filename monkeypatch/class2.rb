class Class
#if someone else has hooked and given it the same alias a bad thing will happen.

#aha, since this a subclass of module module doesn't have these functions.


	attr_accessor :duped, :replacements
	@duped = nil

	alias_method :was_equal?, :equal?
	def equal? obj
		if !(obj.is_a? Class) then return false; end
			obj2 = obj.duped || obj 
			obj1 = duped || self 
		return obj1.was_equal? obj2
	end
	
	def == obj
		equal? obj
		end
	alias_method :"tripple_equals",:"===" 	
	def === obj
		if(obj.class.duped && duped) then
			tripple_equals(obj)
		elsif(obj.class.duped && !(duped)) then
			return obj.is_a? self
                elsif(!(obj.class.duped) && duped) then
                        return duped.tripple_equals(obj)
		else
			return tripple_equals(obj) 		
		end
		#obj1 = obj.class.duped || obj
		#klass = duped || self
		#puts "#{klass}===#{obj1}"	
		#return klass.tripple_equals obj1
	end
		def nest_inspect (array,*joiner)
		#	puts "nest_inspect: #{array.inspect} ... #{joiner.inspect} [#{joiner.first}]"
		if !(array.is_a? Array) then
			return array.inspect
		else
			(array.collect {|it|
				if it.is_a? Array then
					nest_inspect(it, *joiner.dup.delete_at(1))
				else
					it
				end
				}).join(joiner.first)
		end
		end
		alias_method :to_s_old, :to_s
		def to_s
			if(duped)
				return "#<#{duped.inspect}\' (#{nest_inspect(@replacements,"|","=>")})>"
			else
				to_s_old
			end
		end
end
	
	class Object 
#		alias_method :was_a?, :is_a?
		def is_a? klass
			(self.class.duped || self.class) <= (klass.duped || klass)
		end
	end
