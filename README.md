# Simple api client of [InoReader](http://inoreader.com/)

This gem is Simple api client of [InoReader](http://inoreader.com/)

InoReader official API is [here](http://wiki.inoreader.com/doku.php?id=api)

[![Gem Version](https://badge.fury.io/rb/inoreader-api.png)](http://badge.fury.io/rb/inoreader-api)

## Installation

Add this line to your application's Gemfile:

    gem 'inoreader-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install inoreader-api

## Usage

### Initialize

#### Initialize with Login

```ruby
require 'inoreader-api'

inoreader = InoreaderApi::Api.new(:username => 'username', :password => 'password')
inoreader.auth_token # => 'G2UlCa...Fx'
```

#### Initialize with Token

```ruby
require 'inoreader-api'

inoreader = InoreaderApi::Api.new(:auth_token => 'yourtoken')
inoreader.auth_token # => yourtoken
```

### Token

```ruby
inoreader.token # => yourtoken
```

### User info

```ruby
user = inoreader.user_info
user.userId # => '1005921515'
user.userName # => 'Jacket'
```

### Get unread counters

```ruby
unread = inoreader.unread_counters
unread.max # => 1000
```

### List of user subscriptions

```ruby
inoreader.user_subscription
```

### List of user tags and folders

```ruby
inoreader.user_tags_folders
```

### Stream

#### feed items

For additional parameter about any of the request, see the http://wiki.inoreader.com/doku.php?id=api#stream_contents

``` ruby
# retrieve all feed item
inoreader.items
# => #<Hashie::Mash continuation="bHe_p00GLz2u" description="" direction="ltr"...

# with parameter
inoreader.items('feed/http://feeds.test.com/',{
  :n      => 10,
  :r      => 'o',
  :ot     => '1389756192',
  :xt     => 'user/-/state/com.google/read',
  :it     => 'user/-/state/com.google/read',
  :c      => 'Beg3ah6v3'
})
```

#### item ids

```ruby
# retrieve all item ids
inoreader.item_ids
# => #<Hashie::Mash continuation="eCpdOmg58fOF" itemRefs=[...

# with parameter
inoreader.item_ids('feed/http://feeds.test.com/',{
  :n      => 10,
  :r      => 'o',
  :ot     => '1389756192',
  :xt     => 'user/-/state/com.google/read',
  :it     => 'user/-/state/com.google/read',
  :c      => 'Beg3ah6v3'
})
```

### Tags

#### Rename tag

```ruby
inoreader.rename_tag('oldtag','newtag') # => 'OK'
```

#### Delete tag

```ruby
inoreader.disable_tag('tagname') # => 'OK'
```

#### Add tag

```ruby
inoreader.add_tag('1719158580', 'user/-/state/com.google/read') # => 'OK'
# or
inoreader.add_tag('tag:google.com,2005:reader/item/000000006678359d', 'user/-/state/com.google/read') # => 'OK'
```

#### Remove tag

```ruby
inoreader.remove_tag('1719158580', 'user/-/state/com.google/read') # => 'OK'
# or
inoreader.remove_tag('tag:google.com,2005:reader/item/000000006678359d', 'user/-/state/com.google/read') # => 'OK'
```

### Mark all as read

```ruby
# specify label
inoreader.mark_all_as_read(1373407120123456, 'user/-/label/Google') # => 'OK'

# or feed
inoreader.mark_all_as_read(1373407120123456, 'feed/http://feeds.test.com/') # => 'OK'
```

### Subscription

#### Add subscription (feed)

```ruby
inoreader.add_subscription('http://newfeeditem.com/')
# => #<Hashie::Mash numResults=1 query="http://newfeeditem.com/" streamId="feed/http://rss.newfeeditem.com/feeds">
```

#### Rename subscription

```ruby
inoreader.rename_subscription('feed/http://rss.newfeeditem.com/feeds', 'new title')  # => 'OK'
```

#### Add folder

```ruby
inoreader.add_folder_subscription('feed/http://rss.newfeeditem.com/feeds', 'folderName') # => 'OK'
```

#### Remove folder

```ruby
inoreader.remove_folder_subscription('feed/http://rss.newfeeditem.com/feeds', 'folderName') # => 'OK'
```

#### unsubscribe

```ruby
inoreader.unsubscribe('feed/http://rss.newfeeditem.com/feeds') # => 'OK'
```

#### subscribe

```ruby
inoreader.subscribe('feed/http://rss.newfeeditem.com/feeds') # => 'OK'
# with folder
inoreader.subscribe('feed/http://rss.newfeeditem.com/feeds', 'newFolder') # => 'OK'
```

### Preferences list

```ruby
inoreader.preferences_list
# => #<Hashie::Mash prefs=[#<Hashie::Mash id="lhn-prefs" value="{\"subscriptions\":{\"ssa\":\"false\"}}">]>
```


### Stream preferences list

```ruby
inoreader.stream_preferences_list
# => #<Hashie::Mash streamprefs=#<Hashie::Mash...
```

### Set subscription ordering

```ruby
inoreader.set_subscription_ordering('user/-/state/com.google/root', '00A3AAB000B9C8F9')# => 'OK'
```

## httparty mode
If you attach the `:return_httparty_response => true` when the initiarize, you can return the response of httparty.

[httparty(github)](https://github.com/jnunemaker/httparty)

```ruby
inoreader = InoreaderApi::Api.new(
  :auth_token => 'token',
  :return_httparty_response => true
)

inoreader.item_ids
# <HTTParty::Response:0x7fe10416dd60 parsed_response={"items"=>[], "itemRefs"=>[{"id"=>"1719385305", "directStreamIds"=>[], ...
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
