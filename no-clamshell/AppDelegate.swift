import Cocoa
import LaunchAtLogin

// NOTE: status bar app / agent app tutorial: https://www.appcoda.com/macos-status-bar-apps/

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet weak var menu: NSMenu!
  @IBOutlet weak var launchAtLoginMenuItem: NSMenuItem!
  
  @objc dynamic var launchAtLogin = LaunchAtLogin.kvo
  
  var statusItem: NSStatusItem?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    statusItem?.button?.title = "No Clamshell"
    statusItem?.menu = menu
  }
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    CGDisplayRegisterReconfigurationCallback({ (_, _, _) in
      if !isBuiltInDisplayConnected() {
        putToSleep()
      }
    }, nil)
  }
}

