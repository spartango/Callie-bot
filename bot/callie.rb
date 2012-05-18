require 'logger'
require 'blather/stanza/message'
require 'amatch'
require 'gcal'

module Bot
    class Callie 
        def initialize(apiKey, apiSecret, oauthToken, oauthSecret)
            @client = GCal::Client.new(api_key, api_secret, oauth_token, oauth_secret)

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
                return [(buildMessage message.from.stripped, "Callie: No problem, "+senderName)]
            
            elsif queryText.match /hi/i or queryText.match /hello/i or queryText.match /hey/i
                return [(buildMessage message.from.stripped, "Callie: Hello, "+senderName)]
            end  
            # Default / Give up
            return [(buildMessage message.from.stripped, "Callie: Sorry? Is there a way I can help?")]
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
