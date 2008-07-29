require File.dirname(__FILE__) + '/watir_setup'
require 'watir\contrib\enabled_popup'

class WatirTestCase < Test::Unit::TestCase
  
  def startClicker( button , waitTime= 9, user_input=nil )
    # get a handle if one exists
    hwnd = $ie.enabled_popup(waitTime)  
    if (hwnd)  # yes there is a popup
      w = WinClicker.new
      if ( user_input ) 
        w.setTextValueForFileNameField( hwnd, "#{user_input}" )
      end
      # I put this in to see the text being input it is not necessary to work
      #sleep 3         
      # "OK" or whatever the name on the button is
      w.clickWindowsButton_hwnd( hwnd, "#{button}" )
      #
      # this is just cleanup
      w=nil    
    end
    sleep 5
  end

  protected
  
  def teardown
    # this stuff basically works, but depends on "SnagIt" (30-day free trial; inexpensive to purchase)
    # and needs some additional love with regard to that OutputImageFile2.directory setting.
    
    # There are also ways to screenshot just IE (whether we want to do this or not is another issue - see below)
    # and to get SnagIt to scroll the IE window and snapshot the entire content (!) that are worth looking into.

    # The possibilities are endless - perhaps Watir could be wrapped or modified to take a screenshot after every
    # button or link click, or whatnot.

    # Also, consider using something like "CamStudio" to record the Watir test run (?)
    test_label = "#{self.name}"
    screenshot_filename = "#{test_label}"
    results_output_directory = "#{RAILS_ROOT}/watir_test_results"

    begin
      require 'win32ole'
      snagit = WIN32OLE.new('Snagit.ImageCapture')

      # config input
      snagit.Input = 0 #desktop

      #configure output
      snagit.Output = 2 #file
      snagit.OutputImageFile2.FileType = 5 #:png
      snagit.OutputImageFile2.FileNamingMethod = 1 # fixed #

      #location
      snagit.OutputImageFile2.Directory = "#{RAILS_ROOT}/watir_test_results"   # set directy where filename will be saved
      #puts "Outputting to: #{results_output_directory}"
      snagit.OutputImageFile2.Filename = screenshot_filename
      
      # do the duty
      snagit.Capture
      
      # wait for capture to complete
      Watir::Waiter.wait_until(5) { snagit.IsCaptureDone }
    rescue Exception => ex
      puts "Exception taking screenshot of #{test_label}: #{ex}"
    end

    File.open("#{results_output_directory}/#{test_label}.html", "w") {|io| io.write($ie.html)}

    $ie.link(:text, "Logout").click if $ie.link(:text, "Logout").exist?
    sleep 1
  end

end