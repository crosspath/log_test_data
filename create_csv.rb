require 'csv'

columns = 'http_method;query;parameters;user_id;response_code;controller;action;referer;referer_controller;created_at'
attrs = columns.split(';')

CSV.open('db/seed2.csv', 'w', col_sep: ';', headers: columns, write_headers: true, quote_char: '`') do |csv|
    Log.find_each { |log| csv << log.attributes.slice(*attrs) }
end
