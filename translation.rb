require 'rest-client'
require 'json'

class Translatable
    @@url = 'https://translate.yandex.net/api/v1.5/tr.json/translate'
    @@token = 'trnsl.1.1.20190818T192858Z.452847045394d585.9ecd8dd9190b3b7049b208902edbe2394834817a'
    
    def initialize(phrase, fromLanguage, toLanguage)
        @phrase = phrase.to_str
        @fromTo = (fromLanguage + "-" + toLanguage)
    end

    def translate
        @response = RestClient.post(@@url, {key: @@token, text: @phrase, lang: @fromTo}, headers={})
        @response_hash = JSON[@response]
        @translation = @response_hash["text"].join('')
        return "Phrase: #{@phrase}\nLanguages: #{@fromTo}\nTranslation: #{@translation}"
    end
end

language = File.read('language.json')
language_hash = JSON[language]

print 'Enter the phrase you with to translate: '
phrase = gets.chomp
print 'Enter the input language: '
fromLanguageValue = gets.chomp
print 'Enter the output language: '
toLanguageValue = gets.chomp

fromLanguage = language_hash[fromLanguageValue.downcase]
toLanguage = language_hash[toLanguageValue.downcase]

translatable = Translatable.new(phrase, fromLanguage, toLanguage)
fileName = Time.now.strftime("%d-%m-%y_%H-%M.txt")
file = File.new(fileName, "w")
file.print translatable.translate
file.close