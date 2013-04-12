# Feature Switches

### Status: Alpha (Don't use in production)

## Summary

A small gem for putting feature switches into your application that allow you
to dynamically enable features to a percentage of users or specific cohort
groups without a code deploy. There are some excellent gems that provide this
functionality already -- [rollout](https://github.com/jamesgolick/rollout) and
[flipper](https://github.com/jnunemaker/flipper).  This project is an
experiment aiming for a specific set of design goals:

1. Reduce the chatter in the protocol between a node checking to see if a
   feature is enabled and the backend storage system. We're going to be reading
   this data far more often than we're writing it so we want to aggressively
   cache, but...

2. Ensure all nodes get the latest configuration data as soon as possible. A
   cache that expires given a certain TTL can't work as a client isn't
   guaranteed to talking to the same instance of our application on each
   request. A feature disappearing and reappearing depending on which
   application server instance a user hits is a bug.

3. Allow for extension with new backends that support change notification;
   specifically distributed system synchronization backends like Zookeeper and
   perhaps doozerd. Right now it's initially implemented against Redis and
   Postgres.

4. Ensure that any kind of identifier can be used; not just an object that
   responds to `id` We want to peg our switches on things that aren't
   ActiveRecord objects (e.g., incoming phone numbers, etc).

5. Expose a memorable CLI as `irb` is primarily how we configure the feature
   switches.

## Supported Backends

* Redis
* Postgres
* In-memory (for testing)

## Design

Switches uses a backend for both storage of feature configuration data and for
notifying sibling nodes that a change has been made. We'll look at how this
works against the Redis backend.

On startup, switches will connect to Redis twice: once for querying and setting
configuration data and one for subscribing to a pub/sub channel of change
notifications. When a change is made to configuration data, an extra call is
made to Redis to publish a change notification. Once this change notification is
received by other listening nodes they will refetch the configuration data
and update their local stores.

     Node A              Redis               Node B
       |                   |                   |
       |                   |<-subscribe--------|
       |                   |                   |
       |--------------set->|                   |
       |                   |                   |
       |-----notify(item)->|-notified(update)->|
       |                   |                   |
       |                   |<-get--------------|
       |                   |                   |
       |                   |                   |

This allows a node to validate if a user can pass through a feature switch using
in-memory data without a querying a backend but ensures that each node is using
the same data to make the decision.

## Installation

In your Gemfile:

```ruby
  gem "feature_switches"
```

### Postgres Backend

Switches connects to whatever database is specified as the DATABASE_URL in
your environment. Note that switches will connect to Postgres twice for each
node. This is important as Postgres will fork a new process for each connection
so ensure you have the overhead before using this backend.

To use Postgres a table called `switches` must be created in your database.
Two rake tasks have been included to create and drop this table:

1. Add this to your Rakefile:

```ruby
  require "switches"
  require "switches/tasks"
```

2. To create the table:

```shell
  DATABASE_URL=postgres://root:sekret@localhost/my_application rake switches:postgres:setup
```

3. To drop the table

```shell
  DATABASE_URL=postgres://root:sekret@localhost/my_application rake switches:postgres:remove
```

## Usage

```ruby
# Initialize
$switches = Switches do |config|
  config.backend = "redis://localhost:6379/0"
end
# => #<Switches redis://localhost:6379/12>

# Check to see if a feature is active for an identifier
$switches.feature(:redesign).on?(current_user.id)
# => true

$switches.feature(:redesign).on?(current_user.phone_number)
# => true

# Turn a feature on globally
$switches.feature(:redesign).on
# => #<Feature redesign; 100%>

# Turn a feature on for a given percentage of identifiers
$switches.feature(:redesign).on(25)
# => #<Feature redesign; 25%>

# Turn a feature off globally
$switches.feature(:redesign).off
# => #<Feature redesign; 0%>

# Add or remove an identifier from a cohort group
$switches.cohort(:power_users).add(424)
# => #<Cohort power_users; 1 member>

$switches.cohort(:power_users).remove(424)
# => #<Cohort power_users; 0 members>

# Add a cohort group to a feature
$switches.feature(:redesign).add(:power_users)
# => #<Feature redesign; 0%; power_users>

# Remove a cohort group from a feature
$switches.feature(:redesign).remove(:power_users)
# => #<Feature redesign; 0%>
```
