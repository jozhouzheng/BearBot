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

# get "/" do
# 	"Hello world!"
# end
#
#
#
# get "/" do
#  	     redirect '/about'
# end
#
#
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

get '/incoming/sms' do
  session["counter"] ||= 1
  body = params[:Body] || ""
  sender = params[:From] || ""

  if session["counter"] == 1
    message = "Welcome to Bear! I'm a fun-loving, caring and insightful bear. Try talk to me and see what I say 😉 "
    media = "https://media.giphy.com/media/xNQTp4xqjY22I/giphy.gif"
  else
    message = "It's Bear here 🐻. What's up? "#How do i add first name
    media = "https://media.giphy.com/media/lII8kUqoT5MD6/giphy.gif"
    #media = nil
  end

  #try ask what do you do everyday, selecting among giphy" "this is what i like to do" 'want to see more?'
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

get "/test/sms" do

  client = Twilio::REST::Client.new ENV["TWILIO_ACCOUNT_SID"], ENV["TWILIO_AUTH_TOKEN"]

   # Include a message here
  message = "Hi! This is a test SMS from your Sinatra application."

   # this will send a message from any end point
  client.api.account.messages.create(
     from: ENV["TWILIO_FROM"],
     to: ENV["TEST_NUMBER"],
     body: message
  )
 	# response if eveything is OK
 	"An SMS was sent to your number "
end

# get '/test/conversation' do
# 	if params[:Body].nil? && params[:From].nil?
#  		return "What is your phone number?"
#  	elsif params[:From].nil?
#  		return "Please send me your number"
#  	elsif params[:Body].nil?
#  		return "Please give me your number"
#  	end
#  	  determine_response params[:Body]
#  end


 # def determine_response body
 #   laugh = ["haha", "lol", "that's funny!", "omg!!!"]
 #   body = body.downcase.strip
 #
 # 	if body == "hi"
 # 		"I am Bear. I can tell you more about JoJo if we become friends"
 # 	elsif body == "who"
 # 		"I am Bear who can help you know more about Jo. You can reply 'fact' to learn more about her"
 # 	elsif body == "where"
 # 		"I currently in Pittsburgh."
	# elsif body == "why"
	# 	"Jo became interested in conversational UI and I am her first app!"
	# elsif body == "when"
 # 		"I was created in September 2018 in Pittsburgh"
 # 	elsif body == "joke"
 # 		array_of_lines = IO.readlines("jokes.txt")
 # 		return array_of_lines.sample + laugh.sample
 # 	elsif body == "fact"
 # 		array_of_lines = IO.readlines("facts.txt")
 # 		return array_of_lines.sample
 # 	end
