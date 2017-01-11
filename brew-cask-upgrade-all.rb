#!/usr/bin/env ruby

puts "brew update:"
puts `brew update`

puts "brew upgrade:"
puts `brew upgrade`

puts "brew cask upgrade"

cask_list = `brew cask list`.split("\n")
ignore_item = ['']#gpgtools']

FORCE_UPDATE = ARGV[0] == '-f'

cask_list.each do | item |
  next if ignore_item.include?(item)

  current = `ls -t /usr/local/Caskroom/#{item}/`.split("\n")
  current = current.first

  # for amazon products
  if current.nil?
    puts `ls -t /usr/local/Caskroom/#{item}/`.split("\n")
  else
    current = current.gsub(/,/,".") if current.include?(",")
  end

  current = Gem::Version.create(current) if Gem::Version.correct?(current)
  latest = `brew cask info #{item} | grep #{item} | grep -v github | grep -v http | grep :`

  # output
  puts "#{item}"
  latest = latest.split(" ")[1] if latest.split(" ").count >= 2
  latest = latest.gsub(/,/, '.') if latest.include?(",")
  latest = Gem::Version.create(latest) if Gem::Version.correct?(latest)
  puts "latest  : #{latest}"
  puts "current : #{current}"


  if latest != current || FORCE_UPDATE && latest == 'latest'
      puts "#{item} updating.."
      puts `brew cask uninstall --force #{item}`
      puts `brew cask install #{item}`
      puts "#{item} updated !!!"
  end

  puts " "
end

puts "brew cleanup:"
puts `brew cleanup`

puts "brew cask cleanup:"
puts `brew cask cleanup`

puts "\nall of done.\n"
