class MercadolibreBotService
  # url target
  LOGIN_URL = 'https://www.mercadolibre.com/jms/mlm/lgz/login?platform_id=ml&go=https%3A%2F%2Fwww.mercadolibre.com.mx%2F&loginType=explicit'.freeze
  TARGET_URL = 'https://articulo.mercadolibre.com.mx/MLM-635686127-cachorros-bulldog-ingles-sin-registro-precio-de-contado-7500-_JM#reco_item_pos=1&reco_backend=machinalis-seller-items&reco_backend_type=low_level&reco_client=vip-seller_items-above&reco_id=6d16b48a-2029-4958-a012-e312d9ce4581'.freeze

  EMAIL = "email@domain.com"
  PASSWORD = "password"

  def initialize
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.register_driver :headless_chrome do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w[headless disable-gpu] }
      )
      Capybara::Selenium::Driver.new app,
                                     browser: :chrome,
                                     desired_capabilities: capabilities
    end
    Capybara.default_driver = :chrome
  end


  # Run service "MercadolibreBotService.new.run"
  def run
    driver_env = Rails.env.production? ? :headless_chrome : :chrome
    session = Capybara::Session.new(driver_env)
    session.visit(LOGIN_URL)
    sleep 1
    # binding.pry
    # find email input
    session.find(:xpath, "//*[@id='user_id']").set(EMAIL)
    sleep 2
    # find button to continue
    session.find(:xpath, "//*[@id='login_user_form']/div[2]/input").click
    sleep 2
    # find password input
    session.find(:xpath, "//*[@id='password']").set(PASSWORD)
    sleep 2
    # find button to continue
    session.find(:xpath, "//*[@id='action-complete']").click

    session.visit(TARGET_URL)

    time = Time.now.strftime("%I:%M:%S")
    while time < "02:00:00"
      session.find('.questions__input')
      session.fill_in 'question', with: 'Esto es un fraude, no confies en este vendedor.'
      sleep 1
      session.find('#question-btn').click
      sleep 3
      time = Time.now.strftime("%I:%M:%S")
    end
  end
end
