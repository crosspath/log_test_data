# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

require 'csv'

puts 'Import data...'

CSV.open('db/seed.csv', 'r', col_sep: ';', headers: true, quote_char: '`').each do |csv|
    user = csv['user_id'].present? && User.find_or_create_by!(id: csv['user_id']).id
    log = Log.create!(csv.to_h.merge('user_id' => user))
end

puts 'Set session identifier'

Log.find_each do |log|
  ago = log.created_at - Log::SESSION_LENGTH.minutes
  prev_log = Log.where(user_id: log.user_id, created_at: ago..log.created_at).where('id <> ?', log.id).order(created_at: :desc).first
  log.first_id = prev_log.present? ? prev_log.first_id : log.id
  log.save!
end
