# Application Insights SDK for Ruby #

[![Gem Version](https://badge.fury.io/rb/azure_application_insights.svg)](http://badge.fury.io/rb/azure_application_insights)
[![Build Status](https://travis-ci.org/Microsoft/AzureApplicationInsights-Ruby.svg)](https://travis-ci.org/Microsoft/AzureApplicationInsights-Ruby)

>Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write.
> -- <cite>[Ruby - Official Site](https://www.ruby-lang.org/en/)</cite>

This project extends the Application Insights API surface to support Ruby. [Application Insights](http://azure.microsoft.com/en-us/services/application-insights/) is a service that allows developers to keep their application available, performing and succeeding. This Ruby gem will allow you to send telemetry of various kinds (event, trace, exception, etc.) to the Application Insights service where they can be visualized in the Azure Portal.


## Requirements ##

Ruby 1.9.3 is currently supported by this gem.

## Installation ##

To install the latest release you can use *gem*.

```
$ gem install azure_application_insights
```

## Usage ##

Once installed, you can send telemetry to Application Insights. Here are a few samples.

>**Note**: before you can send data to you will need an instrumentation key. Please see the [Getting an Application Insights Instrumentation Key](https://github.com/Microsoft/AppInsights-Home/wiki#getting-an-application-insights-instrumentation-key) section for more information.


### Sending a simple event telemetry item ###
```ruby
require 'azure_application_insights'
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>'
tc.track_event 'My event'
tc.flush
```

### Sending an event telemetry item with custom properties and measurements ###
```ruby
require 'azure_application_insights'
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>'
tc.track_event 'My event', :properties => { 'custom property' => 'some value' }, :measurements => { 'custom metric' => 13 }
tc.flush
```

### Sending a trace telemetry item with custom properties ###
```ruby
require 'azure_application_insights'
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>'
tc.track_trace 'My trace statement', AzureApplicationInsights::Channel::Contracts::SeverityLevel::INFORMATION, :properties => { 'custom property' => 'some value' }
tc.flush
```

### Sending a metric telemetry item (without and with optional values) ###
```ruby
require 'azure_application_insights'
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>'
tc.track_metric 'My metric', 42
# with all optional values set
tc.track_metric 'My metric', 42, :kind => AzureApplicationInsights::Channel::Contracts::DataPointType::AGGREGATION, :count => 3, :min => 1, :max => 100, :std_dev => 10, :properties => { 'custom property' => 'some value' }
tc.flush
```

### Sending an exception telemetry item with custom properties and measurements ###
```ruby
require 'azure_application_insights'
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>'
begin
  raise ArgumentError, 'Something has gone wrong!'
rescue => e
  tc.track_exception e
end
tc.flush
```

### Configuring context for a telemetry client instance ###
```ruby
require 'azure_application_insights'
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>'
tc.context.application.ver = '1.2.3'
tc.context.device.id = 'My current device'
tc.context.device.oem_name = 'Asus'
tc.context.device.model = 'X31A'
tc.context.device.type = "Other"
tc.context.user.id = 'santa@northpole.net'
tc.track_trace 'My trace with context'
tc.flush
```

### Configuring synchronous (default) channel properties ###
```ruby
require 'azure_application_insights'
tc = AzureApplicationInsights::TelemetryClient.new
# flush telemetry if we have 10 or more telemetry items in our queue
tc.channel.queue.max_queue_length = 10
# send telemetry to the service in batches of 5
tc.channel.sender.send_buffer_size = 5
```

### Configuring an asynchronous channel instead of the synchronous default ###
```ruby
require 'azure_application_insights'
sender = AzureApplicationInsights::Channel::AsynchronousSender.new
queue = AzureApplicationInsights::Channel::AsynchronousQueue.new sender
channel = AzureApplicationInsights::Channel::TelemetryChannel.new nil, queue
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>', channel
# Note: the event will be sent on a separate thread; if the app finishes before
#       the thread finishes, the data is lost
tc.track_event 'My event'
```

### Configuring asynchronous channel properties ###
```ruby
require 'azure_application_insights'
sender = AzureApplicationInsights::Channel::AsynchronousSender.new
queue = AzureApplicationInsights::Channel::AsynchronousQueue.new sender
channel = AzureApplicationInsights::Channel::TelemetryChannel.new nil, queue
tc = AzureApplicationInsights::TelemetryClient.new '<YOUR INSTRUMENTATION KEY GOES HERE>', channel
# flush telemetry if we have 10 or more telemetry items in our queue
tc.channel.queue.max_queue_length = 10
# send telemetry to the service in batches of 5
tc.channel.sender.send_buffer_size = 5
# the background worker thread will be active for 5 seconds before it shuts down. if
# during this time items are picked up from the queue, the timer is reset.
tc.channel.sender.send_time = 5
# the background worker thread will poll the queue every 0.5 seconds for new items
tc.channel.sender.send_interval = 0.5
```

### Collecting unhandled exceptions ###
```ruby
require 'azure_application_insights'
# setup unhandled exception handler
AzureApplicationInsights::UnhandledException.collect('<YOUR INSTRUMENTATION KEY GOES HERE>')
# raise an exception and this would be send to Application Insights Service
raise Exception, 'Boom!'
```

### Collecting requests for rack applications ###
```ruby
# set up the TrackRequest middleware in the rackup (config.ru) file
require 'azure_application_insights'
use AzureApplicationInsights::Rack::TrackRequest, '<YOUR INSTRUMENTATION KEY GOES HERE>', <buffer size>
# For rails, suggest to set up this middleware in application.rb so that unhandled exceptions from controllers are also collected
config.middleware.use AzureApplicationInsights::Rack::TrackRequest, '<YOUR INSTRUMENTATION KEY GOES HERE>', <buffer size>
```

#### Rerieving the Request-Id value from AzureApplicationInsights ####
```ruby
# from time to time you may need to access a request's id from within your app
azure_application_insights_request_id = env['AzureApplicationInsights.request.id']

# this can be used for a number of different purposes, including telemetry correlation
uri = URI('http://api.example.com/search/?q=test')

req = Net::HTTP::Get.new(uri)
req['Request-Id'] = "#{azure_application_insights_request_id}1" if azure_application_insights_request_id

Net::HTTP.start(uri.hostname, uri.port) { |http| http.request(req) }
```
