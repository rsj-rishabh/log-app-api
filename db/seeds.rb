# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'net/http'
require 'json'

LOG_HEADER = "[LOG APP API SERVER]"

# DataFetcher class to fetch data from url and process it
class DataFetcher
    # get the last log index from the database
    def self.get_last_log_index
        last_entry = LogDatum.last
        if last_entry
            if last_entry.log_index
                puts "#{LOG_HEADER} Last log index: #{last_entry.log_index}"
                return last_entry.log_index
            else
                return -1
            end
        else
            puts "#{LOG_HEADER} No log entries found"
            return -1
        end
    end

    # fetch data from url and process it
    def self.fetch(url)
        uri = URI(url)
        response = Net::HTTP.get_response(uri)
        puts "#{LOG_HEADER} Response code: #{response.code}"

        # check if response is success
        if response.is_a?(Net::HTTPSuccess)
            data = response.body
            json_data = JSON.parse(data)
            # check if fetched data is in JSON format
            if json_data.is_a?(Hash) || json_data.is_a?(Array)
                puts "#{LOG_HEADER} Fetched data is JSON/Array, processing..."
                return process_json_data(json_data)
            else
                raise '#{LOG_HEADER} Error: Fetched data is not in JSON format'
            end
        else
            puts "#{LOG_HEADER} Error: #{response.message}"
        end

        rescue StandardError => e
            puts "#{LOG_HEADER} Error: #{e.message}"
    end

    def self.process_json_data(json_data)
        log_entries = []
        last_log_index = get_last_log_index()

        # check if fetched data is a Hash or Array
        if json_data.is_a?(Hash)
            puts "#{LOG_HEADER} Fetched data is a JSON, processing..."
            # consolidate the logs in json of format
            i = 0
            json_data.each do |key, value|
                # append in log_entries only if log_index is greater than last_log_index
                if i > last_log_index
                    new_log_entry = {
                        log_index: i,
                        log_info: {
                            key => value
                        }
                    }
                    log_entries.append(new_log_entry)
                end
                i += 1
            end

        elsif json_data.is_a?(Array)
            puts "#{LOG_HEADER} Fetched data is an Array, processing..."
            # consolidate the conversations in json of format
            # [{user: "hi", bot: "hello"}, {user: "how are you?", bot: "I am fine"}]  
            i = 0
            json_data.each do |entry|
                #  ignore indices that are already present in the database
                if i > last_log_index
                    conversation_stream = []
                    # iterate through each converation
                    # process alternatively user and bot conversation
                    conversation = {}
                    entry.each do |item|
                        if item['speaker'] == 'U'
                            conversation['user'] = item['text']
                        elsif item['speaker'] == 'S'
                            conversation['bot'] = item['text']
                            conversation_stream.append(conversation)
                            conversation = {}
                        end
                    end
                    if conversation != {}
                        conversation['bot'] = ''
                        conversation_stream.append(conversation)
                    end

                    # append in list of entries to be created
                    new_log_entry = {
                        log_index: i,
                        log_info: conversation_stream
                    }
                    log_entries.append(new_log_entry)
                end
                i += 1
            end
        end
        
        puts "#{LOG_HEADER} Processing complete!"
        return log_entries
    end

end


url = 'https://raw.githubusercontent.com/alexa/alexa-with-dstc10-track2-dataset/main/task1/data/test/logs.json'
puts "#{LOG_HEADER} Fetching data from #{url}..."
data = DataFetcher.fetch(url)
puts "#{LOG_HEADER} Data fetched successfully!"

puts "#{LOG_HEADER} Creating log entries..."
LogDatum.create(data)
puts "#{LOG_HEADER} Log entries created successfully!"