#ones_required

class CountOnes

def ones(n)
		s = n.to_s
		l1 = s.length
		l2 = s.gsub("1","").length
		l1 - l2
end
@last = 0
def next_ones(n)
	@last = @last + ones(n)
	return @last
end

def f(n)
min = 2
return 0 if n == 0
return 1 if n == 1
f_n = 0 
2.upto(n) {|n| n
	f_n = next_ones(n)
	z = (n + 0.0)  / (f_n + 0.0)
#z = "!!!!!" if f_n == n
	if(z <= min) then
		puts "#{f_n} / #{n}	#{z}"
		min = z
	end
	}
f_n
# 1 => 1
# 10 => 2 1 + 1
# 11 => 3
# 99 => (1 * 9) + 1*10

end
