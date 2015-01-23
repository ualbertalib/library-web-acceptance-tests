require "json"
require "selenium-webdriver"
require "rspec"
require "spec_helper"
include RSpec::Expectations

describe "BpscTest" do

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @base_url = "http://specialcollections-test.library.ualberta.ca/"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end
  
  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end
  
  it "test_bpsc" do
    @driver.get(@base_url + "/")
    @driver.find_element(:link, "Exhibitions").click
    (@driver.find_element(:css, "h2").text).should == "Exhibitions"
    @driver.find_element(:link, "Research Collections").click
    (@driver.find_element(:css, "h2.span6").text).should == "Research Collections"
  end
  
  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end
  
  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end
  
  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end
  
  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
