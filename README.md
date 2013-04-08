# switches

## Usage

```ruby
# Initialize
$switches = Switches do |config|
  config.backend = "redis://localhost:6379/0"
end

# Turn a feature on globally
$switches.feature(:login).on

# Turn a feature on for a given percentage of users
$switches.feature(:login).on(25)

# Turn a feature off globally
$switches.feature(:login).off

# Check if a feature is on either globally or to a percentage
$switches.feature(:login).on?

# Check if a feature is completely disabled
$switches.feature(:login).off?

# Get the percentage a feature is turned on for
$switches.feature(:login).percentage

# Add or remove an identifier from a cohort group
$switches.cohort(:power_users).add(424)
$switches.cohort(:power_users).remove(424)

# Turn on a feature for a cohort group
$switches.feature(:login).cohort(:admins).on

# Turn on a feature for a given percentage of a cohort group
$switches.feature(:login).cohort(:admins).on(75)

# Turn off a feature for a cohort group
$switches.feature(:login).cohort(:admins).off

# Check if a feature is on either globally or to a percentage for a cohort group
$switches.feature(:login).cohort(:admin).on?

# Check if a feature is completely disabled for a cohort group
$switches.feature(:login).cohort(:admin).off?

# Remove a cohort group from a feature; members will be subject
# to the global rules
$switches.feature(:login).cohort(:admins).remove

# Check to see if a feature is active for an entity
$switches.feature(:redesign).on?(current_user.id)
```
