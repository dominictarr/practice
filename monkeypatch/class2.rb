require 'class_herd/class_references4'

class Class
#if someone else has hooked and given it the same alias a bad thing will happen.

#aha, since this a subclass of module module doesn't have these functions.


	attr_accessor :duped, :replacements
	@duped = nil
	def is_duplicated?
		!(@duped.nil?)
	end
	def original_class
		@duped || self
	end
	
	#alias_method :was_equal?, :equal?
	def eql? obj
		if !(Class === obj) then return false; end
			obj2 = obj.duped || obj 
			obj1 = duped || self 
		return obj1.equal? obj2
	end
	
	def == obj
		eql? obj
	end

	alias_method :real_name, :name
	def name
		@duped ? @duped.real_name : real_name
	end

	alias_method :left_angle_bracket, :<
	def < (obj)
		if self == obj then return false; end
		#puts "#{self} < #{obj}"

		obj1 = duped ? duped : self
	   	obj2 = obj.duped ? obj.duped : obj
		if obj1.superclass.nil? then return false; end

		if(obj1.superclass == obj2) then
			return true
		elsif obj2 == Object then
			return false
		else
			return obj1.superclass < obj2
		end
	end

	def > obj
		obj < self
	end

	def <= (obj)
		self < obj || eql?(obj)
	end

        def >= (obj)
                obj <= self
        end

	alias_method :tripple_equals, :===	
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
#				return "#<#{duped.inspect}\' (#{nest_inspect(@replacements,"|","=>")})>"
				return "<#{duped.to_s}\' (#{_rewires.to_s})>"
			else
				to_s_old
			end
		end
		
		def _reffs
			if @reffs.nil? then
				cr = ClassHerd::ClassReferences4.new
				cr.parse(self)
				@reffs = cr.reffs
			end
			@reffs
		end
	def _rewires
		_wiring (false)
	end
	def _wiring (defaults = true)
		map = Hash.new
		cr = ClassHerd::ClassReferences4.new
				begin
		cr.parse(self)
		rescue
				raise "_wiring couldn't load a class for :#{self}"
		end
		#if it has not been rewired, give the default.
		cr.reffs.each{|r|
			if constants.include? r.to_s and 
				Class === const_get(r) then
				map[r] = const_get(r)
			elsif defaults then #default wiring.
				begin
					map[r] = cr.default_class(r)
				rescue 
					puts "_wiring couldn't load a class for :#{r}"
				end
			end
		}
		map
	end

end
	
	class Object 
#		alias_method :was_a?, :is_a?
		def is_a? klass
			(self.class.duped || self.class) <= (klass.duped || klass)
		end
	end
