desc "Delete done links"
task :delete_done => :environment do
	puts 'Removing done links...'
	LinksHelper.remove_old
	puts 'Links removed.'
end

desc 'Search for links done'
task :search_done => :environment do
	puts 'Searching for links...'
	LinksHelper.search_done_links 'http://www.genbeta.com/index.xml'
	puts 'Finished.'
end