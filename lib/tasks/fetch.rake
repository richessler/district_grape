namespace :fetch do
  desc 'Fetch all events from TicketFly'

  task events: :environment do
    response = HTTParty.get('http://www.ticketfly.com/api/events/upcoming.json?orgId=1&metroCode=511')
    events = response['events']
    events.each do |event|
      Event.create(
        added_manually: false,
        address:        event['venue']['address1'],
        age_limit:      event['ageLimit'] || '',
        announce_date:  event['publishDate'].to_date.strftime( "%B %e" ),
        category:       'concert',
        datetime_local: event['startDate'].to_datetime,
        date:           event['startDate'].to_date.to_s,
        date_date:      event['startDate'].to_date,
        dateMD:         event['startDate'].to_date.strftime( "%B %e" ),
        day:            event['startDate'].to_datetime.strftime( "%A" ),
        description:    event['headliners'][0]['eventDescription'].to_s.gsub(/<img[^>]+>(<\/img>)?|<a.+?<\/a>?|<iframe.+?<\/iframe>/, '') || ' ',
        web_description:event['headliners'][0]['eventDescription'].to_s || ' ',
        event_id:       event['id'],
        eventStatus:    event['eventStatus'],
        facebook:       event['headliners'][0]['urlFacebook'] || '',
        image:          event['image'] ? event['image']['large']['path'] : 'http://i.imgur.com/amg7RLK.png',
        isFree:         false,
        isFeatured:     event['featured'],
        lat:            event['venue']['lat'],
        lon:            event['venue']['lng'],
        price:          event['ticketPrice'],
        seatgeek_url:   event['ticketPurchaseUrl'],
        short_title:    event['name'].truncate(42) || '',
        slug:           event['slug'] || '',
        state:          event['venue']['stateProvince'],
        time:           event['startDate'].to_time.strftime("%l:%M %p"),
        title:          event['name'] || '',
        twitter:        event['headliners'][0]['twitterScreenName'] || '',
        venue_blurb:    event['venue']['blurb'],
        venue_id:       event['venue']['id'],
        venue_name:     event['venue']['name'].truncate(31) || '',
        youtube:        event['headliners'][0]['youtubeVideos'][0] || ''
      )
    end
  end
end