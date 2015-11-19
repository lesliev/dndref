module Dice
  def d(sides, mult=1, plus=0)
    roll = 0
    mult.times{roll += (rand(sides)+1)}
    total = roll + plus

    pm = ''
    pm = "+#{plus}" if plus > 0
    pm = "#{plus}" if plus < 0
    log_bare("roll: #{mult}d#{sides}#{pm} = #{total}")
    total
  end

  def d_disadvantaged(sides)
    log_bare('disadvantaged roll:')
    first = d(sides)
    second = d(sides)
    first < second ? first : second
  end

  def d_advantaged(sides)
    log_bare('advantaged roll:')
    first = d(sides)
    second = d(sides)
    first > second ? first : second
  end

  def d20_disadvantaged
    d_disadvantaged(20)
  end

  def d20_advantaged
    d_advantaged(20)
  end

  def d20(plus = 0)
    d(20, 1, plus)
  end
end
