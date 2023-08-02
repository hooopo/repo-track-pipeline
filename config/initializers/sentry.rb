Sentry.init do |config|
  config.dsn = 'https://3bd6b029e78c5a6c27efb8e3f179c491@o4505634211430400.ingest.sentry.io/4505634213330944'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
