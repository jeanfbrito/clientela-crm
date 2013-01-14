namespace :thinking_sphinx do
  task :multiple_configure => :app_env do
    File.open(File.join(Rails.root, 'config', "#{Rails.env}.sphinx.conf"), 'w') do |f|
      f<< ERB.new(IO.readlines(File.join(Rails.root, 'config', 'sphinx.conf')).join('')).result(binding)
    end
  end
end

namespace :ts do
  task :mc => "thinking_sphinx:multiple_configure"
end