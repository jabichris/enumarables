module Enumerable
  def my_each
        return to_enum(:my_each) unless block_given? 
        index = 0
        while index < size
          yield(self[index])
          index += 1
        end
        self
  end

  def my_each_with_index(given_index = nil)
        return enum_for(:my_each_with_index) unless block_given?
    
        index = 0
        index = given_index unless given_index.nil?
        my_each do |x|
          yield(x, index)
          index += 1
        end
        self
  end
    
    
  def my_select
      select_array = []
      return enum_for(:my_select) unless block_given?

      my_each { |x| select_array << x if yield x }
      select_array
  end

  def my_all?(pattern = nil)
    my_each do |x|
      if block_given?
        return false unless yield x
      elsif !pattern.nil?
        return false if all_check(pattern, x) == false
      else
        return false unless x
      end
    end
    true
  end

  def my_any?(pattern = nil)
    my_each do |x|
      if block_given?
        return true if yield x
      elsif !pattern.nil?
        return true if any_check(pattern, x)
      elsif x
        return true
      end
    end
    false
  end

  def my_none?(pattern = nil)
    my_each do |x|
      if block_given?
        return false if yield x
      elsif !pattern.nil?
        return false if none_check(pattern, x) == false
      elsif x
        return false
      end
    end
    true
  end

  def my_count(items = nil)
    repetitions = 0
    my_each do |x|
      if !items.nil?
        repetitions += 1 if items == x
      elsif block_given?
        repetitions += 1 if yield x
      else
        repetitions += 1
      end
    end
    repetitions
  end

  def my_map(proc = nil)
    return enum_for(:my_map) unless block_given?
    arr = []
    each do |x|
      arr << if block_given?
               (yield x)
             else
               proc.call(x)
             end
        end
    arr
   end
  end

  def my_inject(accumulator = nil, value_given = nil)
    return symbol_logic(value_given, accumulator) if accumulator.class == Integer && !value_given.nil?
    return symbol_logic(accumulator, 0) if accumulator.class == Symbol
    each do |x|
      accumulator = if accumulator.class == Integer
                      yield(accumulator, x)
                    elsif accumulator.nil?
                      x
                    else
                      yield(accumulator, x)
                    end
     end
    accumulator
  end

  def symbol_logic(symbol, accumulator)
    each do |x|
      case symbol
      when :+
        accumulator += x
      when :-
        accumulator -= x
      when :*
        accumulator *= x
      when :/
        accumulator /= x
      end
    end
    accumulator
  end

  def all_check(pattern, exponent)
    if pattern.is_a? Regexp
      return false if exponent !~ pattern
    elsif pattern.is_a? Class
      return false unless exponent.is_a? pattern
    elsif exponent != pattern
      return false
    end
    true
  end

  def any_check(pattern, exponent)
    if pattern.is_a? Regexp
      return false if pattern =~ exponent
    elsif pattern.is_a? Class
      return true if exponent.is_a? pattern
    elsif exponent == pattern
      return true
    end
    false
  end

  def none_check(pattern, exponent)
    if pattern.is_a? Regexp
      return false if pattern =~ exponent
    elsif pattern.is_a? Class
      return false if exponent.is_a? pattern
    elsif exponent == pattern
      return false
    end
    true
  end
  