module Logger
  def log(s)
    puts "#{self.name}: #{s}"
  end

  def log_bare(s)
    puts "  #{s}"
  end
end  
