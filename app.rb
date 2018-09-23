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


# empty_array = []
# greetings = ["Howdy!", "Hola.", "Hiyaya.", "I'm sun-bathing, what are you doing?", "Heya.", "Hey you.","Moin"]
#
# get '/about' do
# 	session["visits"] ||= 0 # Set the session to 0 if it hasn't been set before
#   session["visits"] = session["visits"] + 1
#
#   time = Time.new
#   num_choice = rand(7) #To random greetings
#
# 	if !session[:first_name].nil? && !session[:number].nil?
# 	     greetings.sample + ", " + "#{session[:first_name]} (#{session[:number]})
# 	     <br />
# 	     Total visits: #{session[:visits].to_s} times as #{time.strftime("%A %B %d, %Y %H:%M")}"
# 	else
# 	     "Bear is a fun-loving, caring and insightful bear. Try talk to him and see what he says :)
# 	     <br />
# 	     You have visited #{session[:visits].to_s} times as of #{time.strftime("%A %B %d, %Y %H:%M")}"#returns mmddyy
# 	end
# end

#
# get '/signup' do
#   	"Sign up for Bear" + "</br>" + "Enter your name"
# end
#
# get '/signup/:first_name/:number' do
#   	session[:first_name] = params[:first_name]
#   	session[:number] = params[:number]
#   	"<h1> Hi, </h1>" + params[:first_name] + ", "+ params[:number]
# end
#
#   post "/signup" do
#     if params[:first_name] == "" || params[:number]==""
#       return "Your information in incomplete."
#     else
#       client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]
#
#       # Include a message here
#       message = "Hi" + params[:first_name] + ", welcome to Bear! I can respond to who, what, where, when and why. If you're stuck, type help."
#       # this will send a message from any end point
#       client.api.account.messages.create(
#         from: ENV["TWILIO_FROM"],
#         to: params[:number],
#         body: message
#       )
#   	   # response if eveything is OK
#   	   return "You're signed up. You'll receive a text message in a few minutes from Bear. "
#      end
#    end


get "/incoming/sms" do
  session["last_intent"] ||= nil

  session["counter"] ||= 1
  count = session["counter"]

  sender = params[:From] || ""
  body = params[:Body] || ""
  body = body.downcase.strip

  if session["counter"] == 1
    message = "It's Bear here 🐻. I'm a fun-loving, caring and insightful bear. Try talk to me and see what I say 😉 . Type in 'questions' to get a list of questions you can ask me."
    media = "https://media.giphy.com/media/xNQTp4xqjY22I/giphy.gif"
  elsif body.include? "like to do" or body.include? "like doing" #when user ask what do you like to do
    message = "I like to eat honey, and read! I'm a well-read bear. Give me a book title and I will let you know what I think"
      # media = #gif
  elsif body.include? "quote" #"what's your favorite quote?"
    message = "A well-read bear is a dangerous creature.🤓"
  elsif body.include? "questions"
    message = "You can ask me questions such as:

    \"What do you like to do?\"

    \"What's your favorite quote?\"

    \"What books are you currently reading?\"

    \"What do you like the most?\"

    \"What books are you currently reading?\"

    \"What are Bear's favorite books?\""
  elsif body == "What are Bear's favorite books?"
    message = "You just picked my favorite question! Hummm but I can only share it if you feed me honey 🍯😎...alright alrigh here you go:

    \"Man's Search for Meaning\"

    \"Sapiens: A Brief History of Humankind\"

    \"Walden\"

    \"The Unbearable Lightness of Being\"

    \"Quiet\"

    \"The Wisdom of Life\"

    Try type in the title of the book and I will let you know what I think about the book!"  
    media ="https://media.giphy.com/media/126BrhLh4YgwkE/giphy.gif"
  elsif body == "What do you like the most?"
    message = "Food...and honey! "
    media = "https://media.giphy.com/media/fdWVI1op6wi88/giphy.gif"
  elsif body == "What do you like to do?"
    message = "Cuddle with my pillow."
    media = "https://media.giphy.com/media/2QIbGQ1WEVF6M/giphy.gif"

  else
    message = "I didn't understand that. You can type in 'questions' to get a list of questions you can ask me."
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
