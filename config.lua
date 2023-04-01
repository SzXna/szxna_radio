Config = {}

Config.Locale = 'en' -- choose language 'en' or 'pl'
Config.ox_notification = true -- if false will use esx notification

Config.radio_item = false
Config.radio_item_name = 'radio' 

Config.radio_open_button = 'F10' -- only works when radio_item is false

Config.radio_default_volume = 50
Config.maximum_frequency = 150

Config.restricted_frequencies = true
Config.restricted_channels = 5 -- from 1 to the set amount, the channels will be blocked
Config.restricted_channels_jobs_allowed = { -- work only when is true job_blocked_frequencies, max 5 jobs
    'police',
    'ambulance'
}