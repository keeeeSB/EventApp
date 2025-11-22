driver = if ENV['CI']
           Capybara.register_driver :headless_chrome_ci do |app|
             Capybara::Selenium::Driver.new(
               app,
               browser: :chrome,
               capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
                 "goog:chromeOptions" => {
                   "args" => %w[
            headless
            no-sandbox
            disable-dev-shm-usage
            disable-gpu
            window-size=1400,1400
          ]
                 }
               )
             )
           end
           :headless_chrome_ci
         else
           :selenium_chrome_headless
         end

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by driver
  end
end
