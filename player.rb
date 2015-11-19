module Player
  ABILITIES = [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma]
  TYPICAL = [15, 14, 13, 12, 10, 8].shuffle

  def modifier(ability_score)
    ((ability_score - 10)/2.0).floor
  end

  ABILITIES.each do |ability|
    define_method("#{ability}_modifier") do
      modifier(send(ability))
    end

    define_method("#{ability}_proficiency?") do
      false
    end

    define_method("#{ability}_save?") do |dc|
      save?(ability, dc)
    end

    define_method(ability) do
      TYPICAL.shift
    end
  end

  def save?(ability, dc)
    roll = d(20) + modifier(send(ability))
    roll += proficiency_bonus if send("#{ability}_proficiency?")
    roll >= dc
  end

  # basic stats

  def name
    "anonymous"
  end

  def level
    1
  end

  def proficiency_bonus
    2
  end
end
