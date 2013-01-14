INTEGRATION_TASKS = %w(
 integration:start
 integration:bundle_install
 db:migrate
 spec
 integration:coverage_verify
 integration:finish
)