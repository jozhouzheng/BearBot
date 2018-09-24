require 'sinatra'
require "sinatra/reloader" if development?
require 'twilio-ruby'

configure :development do
  require 'dotenv'
  Dotenv.load
end

require 'twilio-ruby'

#twilio number
#9738334107

enable :sessions

get "/" do
	"Hello world!"
end



get "/" do
 	     redirect '/about'
end



get "/incoming/sms" do
  session["last_intent"] ||= nil

  session["counter"] ||= 1
  count = session["counter"]

  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip

  if session["counter"] == 1
    message = "It's Bear here 🐻. I'm a fun-loving, caring and insightful bear. Try talk to me and see what I say 😉 . Type in 'question' to get a list of questions you can ask me."
    media = "https://media.giphy.com/media/xNQTp4xqjY22I/giphy.gif"
  elsif body.include? "like to do" or body.include? "like doing" #when user ask what do you like to do
    message = "I like to eat honey, and read! I'm a well-read bear. Give me a book title and I will let you know what I think."
      # media = #gif
  elsif body.include? "quote" #"what's your favorite quote?"
    message = "A well-read bear is a dangerous creature.🤓"
  elsif body.include? "questions"
    message = "You can ask me questions such as:

    \"what do you like to do?\"

    \"what's your favorite quote?\"

    \"what do you like the most?\"

    \"what do you do for fun?\"

    \"what are Bear's favorite books?\""

  elsif body == "what's your favorite books?"
    message = "You just picked my favorite question! Hummm but I can only share it if you feed me with honey 🍯😎...alright alright here you go:

    \"Man's Search for Meaning\"

    \"Sapiens: A Brief History of Humankind\"

    \"Walden\"

    \"The Unbearable Lightness of Being\"

    \"Quiet\"

    \"The Wisdom of Life\"" + "Try type in the title of the book and I will let you know what I think about the book!"
    media ="https://media.giphy.com/media/126BrhLh4YgwkE/giphy.gif"
  elsif body.include? "like the most"
    message = "Food...and honey! "
    media = "https://media.giphy.com/media/fdWVI1op6wi88/giphy.gif"
  elsif body == "what do you do for fun?"
    message = "Cuddle with my pillow."
    media = "https://media.giphy.com/media/2QIbGQ1WEVF6M/giphy.gif"
  else
    message = "Hmmmm...I didn't understand that 🧐. Try type in 'question' to get a list of questions you can ask me."
end
#

  #try ask what do you do everyday, selecting among giphy" "this is what i like to do" "want to see more?"
  #'tell me a little bit more about yourself, and i will tell you more'

# Build a twilio response object
  twiml = Twilio::TwiML::MessagingResponse.new do |r|
    r.message do |m|

      # add the text of the response
      m.body( message )

      # add media if it is defined
      unless media.nil?
        m.media(media)
      end
    end
  end
  # increment the session counter
  session["counter"] += 1



  # send a response to twilio
  content_type 'text/xml'
  twiml.to_s
 end
