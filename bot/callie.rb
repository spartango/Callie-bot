require 'logger'
require 'blather/stanza/message'

require 'rubygems'
require 'google_calendar'

module Bot
    class Callie 
        def initialize(calUsername, calPassword)
            @cal = Google::Calendar.new(:username => calUsername,
                                        :password => calPassword,
                                        :app_name => 'Callie-bot')
            
            @log       = Logger.new(STDOUT)
            @log.level = Logger::DEBUG
        end

        # Messaging
        def buildMessage(user, body) 
            return Blather::Stanza::Message.new user, body
        end

        # Events
        def onStatus(fromNodeName)
            # Dont do anything on status
            return []
        end

        # Query
        def onQuery(message)
            # Anne Queries
            senderName = message.from.node.to_s

            queryText = message.body # Strip the Anne part out
            
            # Listing
                        
            if queryText.match /thank/i
                return [(buildMessage message.from.stripped, "No problem, "+senderName)]
            
            elsif queryText.match /hi/i or queryText.match /hello/i or queryText.match /hey/i
                return [(buildMessage message.from.stripped, "Hello, "+senderName)]
            end  
            # Default / Give up
            return [(buildMessage message.from.stripped, "Sorry? Is there a way I can help?")]
        end

        def onMessage(message, &onProgress)
            # Query handling
            queryMsgs = []
            if message.body.match /Anne/i 
                queryMsgs = onQuery message, &onProgress
            end

            return queryMsgs
        end

    end
end
