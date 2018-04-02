require 'discordrb'
require 'dotenv'
# Create a bot
# Here we output the invite URL to the console so the bot account can be invited to the channel. This only has to be
Dotenv.load
bot = Discordrb::Bot.new token: ENV['TOKEN'], client_id: '425377506041004033'
# done once, afterwards, you can remove this part if you want
puts "This timebot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

bot.message(start_with: '/timebot') do |event|
    try_this = event.content[9..-1]
   
    def letters?(string)
        string.chars.any? { |char| ('a'..'z').include? char.downcase }
    end
    
    def time_changer(time, zone_a, zone_b)
        message_time = zone_b
        from_time = zone_a
        zone_a = zone_a * 100
        zone_b = zone_b * 100
        new_time = time - (zone_a - zone_b)
        if new_time < 0
            final_answer =  "#{time} UTC #{from_time} is **#{2400 - new_time.abs} previous day UTC #{message_time}**" 
        elsif new_time > 2400
            final_answer = "#{time} UTC #{from_time} is **#{(2400 - new_time).abs} next day UTC #{message_time}**"
        elsif new_time == 2400
            final_answer = "#{time} UTC #{from_time} is **midnight UTC #{message_time}**"
        elsif new_time == 0
            final_answer = "#{time} UTC #{from_time} is **midnight previous day UTC #{message_time}**"
        elsif new_time < 100
            final_answer  = "#{time} UTC #{from_time} is **00#{new_time} UTC #{message_time}**"
        else
            final_answer = "#{time} UTC #{from_time} is **#{new_time } UTC #{message_time}**"
        end
        return final_answer
    end
    
    if try_this == 'list'
        event.respond "#{event.user.mention} Here is a list of all the timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations."
    elsif try_this == 'help'
        event.respond "#{event.user.mention} Enter time to be converted using the 24hr clock, from which timezone, and to which timezone \nTimezones MUST be a numerical value. \n**_Example:_** _2100 +3 -4_\nType 'list' for a list of all timezones"
    else 
        splitting = try_this.split(' ')
        if splitting.count != 3
            event.respond "#{event.user.mention} You done messed up, Timebot requires 3 inputs. It should look like this: _2100 +3 -4_"
        elsif letters?(splitting[1]) == true || letters?(splitting[2]) == true
            event.respond "#{event.user.mention} Timezones must be in numerical format.  It should look like this: _2100 +3 -4_" 
        else
            user_input = splitting.map { |x| x.to_i }
            event.respond "#{event.user.mention} #{time_changer(user_input[0], user_input[1], user_input[2])}"
        end
    end
end


bot.run
