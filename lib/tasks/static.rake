namespace :static do
  task generate: :environment do
    Dir.mkdir 'out' unless File.exist? 'out'
    Dir.chdir 'out' do
      `wget -mnH http://localhost:3000/`
    end
    `rsync -ruv --exclude=.git/ public/ out/`
  end

  desc 'Run tiny HTTP server from ./out/ directory'
  task :server do
    Dir.chdir 'out' do
      puts 'Started HTTP server at http://localhost:8000/. Press CTRL+C to exit.'
      `python -m SimpleHTTPServer`
    end
  end
end
