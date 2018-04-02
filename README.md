# Get your Rails requests into Honeycomb

In just two lines of code, bring wonderfully query-able events representing your Ruby on Rails web requests into [Honeycomb.io](https://honeycomb.io/) with the `scout_honeycomb` gem. The gem leverages the [Scout](https://scoutapp.com) Ruby gem - which gathers detailed performance on every web request - and sends those events direct to Honeycomb.

A Scout account isn't required, but it certainly makes performance investigations more fun.

TODO: SCREENSHOT OF DATA IN HONEYCOMB UI 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scout_honeycomb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scout_honeycomb

## Configuration

Create a file in your Rails app called `config/initializers/honeycomb.rb` with the following contents:

```ruby
HONEYCOMB_CLIENT = Libhoney::Client.new(writekey: "[YOUR WRITE KEY]", dataset: "[YOUR APP NAME]")
ScoutHoneycomb.init(HONEYCOMB_CLIENT)
```

## How it works

The `scout_apm` gem automatically instruments your Rails app's web requests, tracking database queries, HTTP calls, Redis queries, rendering time, and more. When a web request completes, `scout_honeycomb` processes the data collected by the `scout_apm` gem and sends a JSON-representation of timing information and [context](http://help.apm.scoutapp.com/#ruby-custom-context) to Honeycomb.

## Example Schema

| Column Key | Data Type | Description |
| - | - | - |
name | string | The name of the transaction. Ex: `Controller/users/show`
uri | string | The URI associated with the request. Ex: `/users/12`
activerecord.duration | float | Time spent (ms) in database calls
controller.duration | float | Exclusive time spent (ms) in the contoller
middleware.duration | float | Exclusive time spent (ms) across middlewares
router.duration | float | Exclusive time spent (ms) in the Rails routing layer
view.duration | float | Exclusive time spent (ms) rendering views, templates, and partials
total_duration | float | The total duration (ms) of the request
git_sha | string | The `git_sha` associated w/the request. Collected via Scout's [deploy tracking](http://help.apm.scoutapp.com/#ruby-deploy-tracking-config).
hostname | string | The hostname of the node handling the request
user.email | string | This is an example of [Scout Context](http://help.apm.scoutapp.com/#ruby-custom-context), reporting the user email associated with the request.

Additional fields can be added:

* Timings - [see the Scout docs](http://help.apm.scoutapp.com/#ruby-custom-instrumentation) for custom instrumentation instructions. These will automatically be reported to Honeycomb.
* Context - add dimensions with important information around web requests (like the `current_user` id or email) via [Scout Context](http://help.apm.scoutapp.com/#ruby-custom-context). These are automatically reported to Honeycomb as well.

## Sampling

The `ScoutHoneycomb` module is initialized with a `Libhoney::Client`. If you wish to sample web request events you send to Honeycomb, use the `sample_rate` parameter when initializing the client:

```ruby
HONEYCOMB_CLIENT = Libhoney::Client.new(writekey: "[YOUR WRITE KEY]", dataset: "[YOUR APP NAME]", sample_rate: 2) # sends 1 out of 2 events or 50% of requests collected by `ScoutHoneycomb` to Honeycomb.io
ScoutHoneycomb.init(HONEYCOMB_CLIENT)
```

## Separating app names by environment

It's often useful to separate your datasets by the Rails app environment. You can dynamically set the dataset w/the Rails environment name:

```ruby
HONEYCOMB_CLIENT = Libhoney::Client.new(writekey: "[YOUR WRITE KEY]", dataset: "[YOUR APP NAME]-#{Rails.env}")
ScoutHoneycomb.init(HONEYCOMB_CLIENT)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/scoutapp/scout_honeycomb.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
