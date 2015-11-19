class Enemy
  include Dice
  include Logger

  attr_reader :ac, :hp, :name, :effects

  def initialize(name, ac, hp)
    @name = name
    @ac = ac
    @hp = hp
    @effects = []
  end

  def to_s
    "#{name} #{hp} [#{effects.join(' ')}] "
  end

  def damage(d, effect = nil)
    @effects << effect if effect

    if @effects.any?
      effect_s = ' [' + @effects.join(' ') + ']'
    else
      effect_s = ''
    end

    old_hp = hp
    @hp -= d
    log_bare("#{old_hp} - #{d} damage = #{hp}#{effect_s} -> #{name}")
    @hp
  end

  def dex_save_modifier
    2
  end

  def wis_save_modifier
    -1
  end

  def charmed!
    @effects << 'charmed'
  end

  def dex_save(versus)
    roll = d20(dex_save_modifier)
    saved = roll >= versus
    saved_s = saved ? 'saved' : 'fail'
    log("dex_save: #{roll} >= #{versus}: #{saved_s}")
    saved
  end

  def wis_save(versus)
    roll = d20(wis_save_modifier)
    saved = roll >= versus
    saved_s = saved ? 'saved' : 'fail'
    log("wis_save: #{roll} >= #{versus}: #{saved_s}")
    saved
  end
end
