require './dice'
require './player'
require './logger'

class Wizard
  include Dice
  include Player
  include Logger

  def spell_attack_bonus
    intelligence_modifier + proficiency_bonus
  end

  def save_vs_spell_dc
    8 + proficiency_bonus + intelligence_modifier
  end

  # When you cast a spell, only one of the following things happens:
  #   1. You roll to hit (proficiency bonus + spellcasting ability modifier)
  #   2. They roll to save (against a DC equal to 8 + your proficiency bonus + your spellcasting ability modifier)
  #   3. It just works (autohit)
  #
  # The spell description specifies which to do. Don't do anything that isn't in the spell description.
  # For example, Burning Hands requires a save
  #   Shocking Grasp requires a melee attack roll
  #   Guiding Bolt requires a ranged attack roll
  #   Magic Missile automatically hits
  #   Sleep requires no rolls to determine whether or not it works, but you do have to roll to see how well it works

  # ranged_spell: true is spell says "make a ranged spell attack"
  # returns true if melee spell is out of range
  def spell_too_far?(range, ranged_spell)
    !ranged_spell && range > 5
  end

  # ranged_spell: true is spell says "make a ranged spell attack"
  # returns true if ranged spell is too close
  def spell_too_close?(range, ranged_spell)
    ranged_spell && range <= 5
  end

  # Spell attack
  # Only do this if the text says "make a melee/ranged spell attack"
  # otherwise the spell requires a save or is an autohit
  #
  # range: range to closest hostile that can see you and isn't incapacitated
  # ranged_spell: true is the spell says "make a ranged spell attack"
  # enemy_ac: ememy's AC to hit
  #
  # returns true if hit
  def spell_attack_roll(enemy_ac, range, ranged_spell)
    raise "can't use melee spell at range" if spell_too_far?(range, ranged_spell)

    disadvantage = spell_too_close?(range, ranged_spell)
    
    roll = disadvantage ? d20_disadvantaged : d20
    roll_plus = roll + spell_attack_bonus

    hit = roll_plus >= enemy_ac
    log("#{roll} + #{spell_attack_bonus} [#{roll_plus}] >= #{enemy_ac}: #{hit ? 'hit' : 'miss'}")
    hit
  end

  # If concentrating on a spell, this needs to be called every time the
  # player takes damage to see if the spell ends
  def concentrating_after_damage?(damage_taken)
    return true unless damage_taken > 0

    dc = [10, (damage_taken/2.0).floor].max
    return false unless constitution_save?(dc)

    true
  end

  # If concentrating on a spell, this is called to see if the spell ends
  # another_spell: true if another spell requiring concentration has been cast
  def concentrating?(another_spell, incapacitated)
    return false if another_spell | incapacitated
    true
  end

  ### SPELLS

  # Fires a dart at each of the enemies listed - which can be repeated if needed.
  # If there are more darts than enemies, the last enemy gets the remainder.
  def magic_missile(enemies, range, slot_level)
    log "magic missile"
    raise 'target out of range' if range > 120

    darts = 3
    darts += slot_level-1
    
    enemies.each do |e|
      if darts > 1
        damage = d(4, 1, 1)
        e.damage(damage)
        darts -= 1
      end
    end

    darts.times do
      damage = d(4, 1, 1)
      enemies.last.damage(damage)
    end
  end

  def ray_of_frost(enemy_ac, range)
    log "ray of frost"
    raise "target out of range" if range > 60
    hit = spell_attack_roll(enemy_ac, range, true)
    if hit
      damage = d(8)
      damage += d(8) if level >= 5
      damage += d(8) if level >= 11
      damage += d(8) if level >= 17
      log("enemy takes #{damage} damage and speed reduced by 10 until start of my next turn")
    end  
  end

  # TODO: range is in the shape of a cone
  def burning_hands(enemies, range, slot_level)
    log "burning hands"
    raise 'target out of range' if range > 15
    enemies.each do |e|
      damage = 0
      slot_level.times{damage += d(6, 3)}
      if e.dex_save(save_vs_spell_dc)
        e.damage(damage/2)
      else
        e.damage(damage)
      end
    end
  end

  def charm_person(enemies, range, slot_level)
    log "burning hands"
    raise 'target out of range' if range > 30

    targets = slot_level
    enemies.each do |e|
      if targets > 0
        unless e.wis_save(save_vs_spell_dc)
          e.charmed!
        end
      end
      targets -= 1
    end
  end

  def witch_bolt(enemy, range, slot_level)
    log "witch bolt"
    raise 'target out of range' if range > 30

    hit = spell_attack_roll(enemy.ac, range, true)
    if hit
      enemy.damage(d(12, slot_level))
    end
  end

  #TODO: total cover also ends spell
  # this is called on each subsequent turn to resume witch_bolt damage
  def witch_bolt_resume(enemy, range, slot_level, time_seconds, concentration_kept)
    log "witch bolt resume"
    raise 'target out of range' if range > 30
    raise 'duration exceeded' if time_seconds > 60
    raise 'lost concentration' unless concentration_kept

    enemy.damage(d(12, slot_level))
  end
end
