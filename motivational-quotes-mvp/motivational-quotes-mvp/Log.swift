//
//  Log.swift
//  motivational-quotes-mvp
//
//  Created by long vu unstatic on 7/27/21.
//

import Foundation
import SwiftyBeaver

#if DEBUG
let log: SwiftyBeaver.Type = {
    let log = SwiftyBeaver.self
    
    let console = ConsoleDestination()  // log to Xcode Console
    let file = FileDestination()  // log to default swiftybeaver.log file
//        let cloud = SBPlatformDestination(appID: "foo", appSecret: "bar", encryptionKey: "123") // to cloud

    // use custom format and set console output to short time, log level & message
    console.format = "$DHH:mm:ss$d $L $M"
    // or use this for JSON output: console.format = "$J"

    // add the destinations to SwiftyBeaver
    log.addDestination(console)
    log.addDestination(file)
//        log.addDestination(cloud)
    return log
}()
#endif
