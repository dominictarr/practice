s(:class,
 :OuterClass,
 nil,
 s(:scope,
  s(:block,
   s(:defn,
    :hello,
    s(:args),
    s(:scope,
     s(:block,
      s(:call,
       nil,
       :puts,
       s(:arglist,
        s(:call,
         s(:const, :String),
         :new,
         s(:arglist, s(:str, "hello, parser!")))))))),
   s(:class,
    :InnerClass,
    nil,
    s(:scope,
     s(:defn,
      :goodbye,
      s(:args),
      s(:scope,
       s(:block,
        s(:call,
         nil,
         :puts,
         s(:arglist,
          s(:call,
           s(:const, :String),
           :new,
           s(:arglist, s(:str, "hello, parser!")))))))))))))


 0.04s:   240.72 l/s:    3.97 Kb/s:    0 Kb:    9 loc:examples/inner_class.rb

 0.04s:   240.72 l/s:    3.97 Kb/s:    0 Kb:    9 loc:TOTAL
