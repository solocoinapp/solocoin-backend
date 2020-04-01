namespace :perf_test_data_seed do

  desc 'Generates a million random entries in users table'
  task :populate_user_table, [:record_count] => :environment do |_task, args|
    puts 'Task started!'
    all_chars = ('a'..'z').to_a
    creation_time = Time.zone.now
    user_data = []
    record_count = args[:record_count].to_i
    if record_count <= 0
      record_count = 1_000_000 # Default
    end
    puts "Generating #{record_count} entries."
    record_count.times do
      user_data << ['test_user', "#{all_chars.shuffle[0, 10].join}@solocoin.com",
                    'IN', rand(100000) / (rand(100) + 1.0), creation_time, creation_time]
    end
    puts 'Data generated. Inserting now...'
    conn = User.connection
    rc = conn.raw_connection
    rc.exec('COPY users(name, email, country_code, wallet_balance, created_at, updated_at) FROM STDIN WITH CSV')
    rc.put_copy_data(user_data.map(&:to_csv).join)
    rc.put_copy_end
    while res = rc.get_result
      if e_message = res.error_message
        puts e_message
      end
    end
  end

end
