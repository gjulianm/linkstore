desc "Delete done links"
task :delete_done => :environment do
	puts 'Removing done links...'
	LinksHelper.remove_old
	puts 'Links removed.'
end