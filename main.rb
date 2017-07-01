# Телеграм-бот

# Этот код необходим при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
###

require 'telegram/bot'

TOKEN = ENV['bot425459205:AAFKH0d1SejXev0gIvSsKDvaqkZJo1MzIQE']

# путь к файлу с ответами
ANSWERS_FILE_PATH = "#{File.dirname(__FILE__)}/data/answers.txt"

# путь к файлу с приветствием
GREETING_FILE_PATH = "#{File.dirname(__FILE__)}/data/greeting.txt"

# открываю файл с ответами
begin
  file_answers = File.open(ANSWERS_FILE_PATH, "r:utf-8")
rescue Errno::ENOENT => e
  puts "Файл с ответами не найден"
  abort e.message
end

answers_lines = file_answers.readlines
file_answers.close

# открываю файл с приветствием
begin
  file_greeting = File.open(GREETING_FILE_PATH, "r:utf-8")
rescue Errno::ENOENT => e
  puts "Файл с ответами не найден"
  abort e.message
end

greeting_lines = file_greeting.readlines
file_greeting.close

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
      when '/start', '/start start'
        bot.api.send_message(
            chat_id: message.chat.id,
            text: "Здравствуй, #{message.from.first_name}.\n" +
                "Можешь задать мне любой интересующий тебя вопрос..."
        )
      else
        sleep 1
        bot.api.send_message(
            chat_id: message.chat.id,
            text: greeting_lines.sample
        )

        sleep 3
        bot.api.send_message(
            chat_id: message.chat.id,
            text: answers_lines.sample
        )
    end
  end
end
