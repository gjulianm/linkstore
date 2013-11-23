require 'action_view'
include ActionView::Helpers::DateHelper

module LinksHelper
  def self.to_relative_date date

    from_time = Time.now

    distance_of_time_in_words(from_time, date)
  end

  def self.remove_old
    old_threshold = 1.day.ago
    Link.where('updated_at < ? and done = ?', old_threshold, true ).destroy_all
  end
  
  def self.search_done_links feed
    begin
      links = Link.all
      res = RestClient.get feed

      if res.code == 200
        body = res.body
        links.each do |l|
          if body.index l.url
            l.done = true
            l.save
          end
        end
      end
    rescue
    end
  end

  def self.extract_title body
    body = body.encode!('UTF-8', 'UTF-8', :invalid => :replace) 
    title_regex = '<title>(.*)</title>'
    match = body.match title_regex
    if match
      return match[1]
    else
      return ' - Title unknown - '
    end
  end

  def self.get_title url
    begin
      LinksHelper.log 'Trying to get title for ' + url

      resp = RestClient.get url

      if resp.code == 200
        return LinksHelper.extract_title resp.body
      else
        LinksHelper.log 'Could not get title. Reply ' + resp.code + ' by ' + url
        return ' - Title unavailable - '
      end
    rescue => e
      LinksHelper.log 'Error getting title for ' + url + ': ' + e.inspect
      return ' - Title unknown - '
    end
  end


  def self.log what
    STDOUT.puts what
  end

  def self.extract_domain url
    domain_regex = 'https?://([^/]*)/?'
    match = url.match domain_regex
    if match
      return match[1]
    else
      return url
    end
  end
end
