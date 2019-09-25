set :output, "#{path}/log/cron_jobs.log"
set :environment, 'development'
job_type :runner_with_rvm, 'source /etc/profile.d/rvm.sh; cd :path;rvm 2.5.1@currency_monitoring do bundle exec rails runner -e :environment :task  :output'

every 1.hour do
  runner_with_rvm "ParseDollarRateJob.perform_later"
end
