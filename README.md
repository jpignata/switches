# switches

## Usage

```ruby
# Initialize
$switches = Switches do |config|
  config.backend = "redis://localhost:6379/0"
end

# Check to see if a feature is active for an identifier
$switches.feature(:redesign).on?(current_user.id)
$switches.feature(:redesign).on?(current_user.phone_number)
$switches.feature(:redesign).on?(Time.now.hour)

# Turn a feature on globally
$switches.feature(:redesign).on

# Turn a feature on for a given percentage of identifiers
$switches.feature(:redesign).on(25)

# Turn a feature off globally
$switches.feature(:redesign).off

# Add or remove an identifier from a cohort group
$switches.cohort(:power_users).add(424)
$switches.cohort(:power_users).remove(424)

# Add a cohort group to a feature
$switches.feature(:redesign).add(:power_users)

# Remove a cohort group from a feature
$switches.feature(:redesign).remove(:power_users)
```
