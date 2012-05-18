require 'logger'
require 'blather/stanza/message'
require 'rubygems'
require 'google/api_client'
require 'yaml'

module Bot
    class Callie 
        def initialize()

            oauth_yaml = YAML.load_file('google-api.yaml')
            @client = Google::APIClient.new
            client.authorization.client_id = oauth_yaml["client_id"]
            client.authorization.client_secret = oauth_yaml["client_secret"]
            client.authorization.scope = oauth_yaml["scope"]
            client.authorization.refresh_token = oauth_yaml["refresh_token"]
            client.authorization.access_token = oauth_yaml["access_token"]

            if client.authorization.refresh_token && client.authorization.expired?
              client.authorization.fetch_access_token!
            end

            @service = client.discovered_api('calendar', 'v3')
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
