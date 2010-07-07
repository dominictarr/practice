#ones_required
require 'count_ones'

class CountOnes2

#CALCULATE ONES REQUIRED IN A SINGLE PASS... OF THE NUMBER.
#TIME PROPORTIONAL TO DIGITS IN n, NOT n.

def matching_columns(str,character)
	r = str.reverse
	a = []
	r.length.times{|i| a << (r[i,1] == character ? 1 : 0)}
	a
end
def add_arrays(a,b)
	sum = a.dup
	b.each_index {|i|
		sum[i] = sum[i] + b[i]
	}
	sum
end
def sum_columns (n)
	totals = []
	return [1] if n == 1
	(1...n + 1).each {|i|
#		puts i
		totals = add_arrays(matching_columns(i.to_s,"1"),totals)
	}
	totals
end

def f(n)

n = fast_calc(n).reverse
s = 0
n.each{|i| s = s + i}
#f(20) is 12. 10 for 10 - 19 + 1 + the unit 1
	#for the unit column: 2(0) * 1 + 0 (number to the left)
	#for the 10 column: 
#how to step through this problem to the solution incrementially? 
#calculate what number of 1s are required for 1 single column, and then add those together.
#then can debug each part of the problem seperately, and figure out the solution.
#but first. eat/	
s
end

# 1 => 1
# 10 => 2 1 + 1
# 11 => 3
# 99 => (1 * 9) + 1*10

def fast_calc(n)
	r = n.to_s.reverse
	a = []
	[1] if n == 1
	r.length.times{|i|
		power = 10**i
		left = r[i + 1,r.length - i].reverse.to_i
		right = r[0,i].reverse.to_i
		col = r[i,1].to_i
		calc = left * power + (col > 1 ? power : (col == 1 ? power/10 * right + 1 : 0))
		puts "#{n}[#{i}] power: #{power} col: #{col} left: #{left} right: #{right} calc: #{calc}"
		a << calc
	}
	a.reverse
end
def columns (n)
	puts "for :" + n.to_s
	sc = sum_columns(n).reverse	
	fc = fast_calc(n)
	puts sc.inspect
	puts fc.inspect
	puts "MISSTAKE!!!!!!" if fc != sc
	puts "answer:" + f(n).to_s
	puts "old answer:" + CountOnes.new.f(n).to_s

end
end

if __FILE__ == $0 then
c = CountOnes2.new
#puts c.matching_columns(10142341.to_s,"1").inspect
#puts x = c.matching_columns(121.to_s,"1").inspect
#puts c.add_arrays(x,[])
c.columns (1)
c.columns (2)

c.columns (12)
c.columns (100)
c.columns (200)
c.columns (222)
c.columns (212)
c.columns (246)
c.columns (1000)
c.columns (2000)
c.columns (20000)
c.columns (3423453)
#there are 3 distinct cases for each column.
#okay, it coming out different to the CountOnes by 1. not sure which class is wrong or which end (hi or low) the error is.
end
