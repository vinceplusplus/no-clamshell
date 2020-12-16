import Cocoa
import Logging
import LoggingOSLog

let logger = Logger(
  label: Bundle.main.bundleIdentifier!,
  factory: LoggingOSLog.init
)

// https://github.com/Tyilo/Lid-sleep/blob/master/Lid%20sleep/main.m
func isBuiltInDisplayConnected() -> Bool {
  for screen in NSScreen.screens {
    if let screenNumber = screen.deviceDescription[.init(rawValue: "NSScreenNumber")] as? NSNumber {
      if CGDisplayIsBuiltin(screenNumber.uint32Value) != 0 {
        return true
      }
    }
  }
  return false
}

// https://developer.apple.com/forums/thread/90702?answerId=273910022#273910022
func putToSleep() {
  var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kSystemProcess))
  let target = NSAppleEventDescriptor(
    descriptorType: typeProcessSerialNumber,
    bytes: &psn,
    length: MemoryLayout.size(ofValue: psn)
  )
  let event = NSAppleEventDescriptor(
    eventClass: kCoreEventClass,
    eventID: kAESleep,
    targetDescriptor: target,
    returnID: AEReturnID(kAutoGenerateReturnID),
    transactionID: AETransactionID(kAnyTransactionID)
  )
  do {
    _ = try event.sendEvent(options: [.noReply], timeout: TimeInterval(kAEDefaultTimeout))
  } catch let error {
    logger.error("\(error)")
  }
}

