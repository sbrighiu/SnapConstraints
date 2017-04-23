//
//  Created by Stefan Brighiu on 16/04/2017.
//  Copyright © 2017 SMBCheeky. All rights reserved.
//

import UIKit

/**
 SnapLog calls handler 
 */
internal struct SnapLog {
    
    static var logDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = SnapManager.logDateFormat
        
        return formatter
    }()
}

// MARK: - Log Methods
internal func warninglog(_ items: Any?..., line: Int = #line, file: String = #file) {
    if SnapManager.ENABLE_LOGGING && SnapManager.SHOW_WARNINGS {
        var timeString = " "
        if SnapManager.logDateFormat != "" {
            timeString = " \(SnapLog.logDateFormatter.string(from: Date())) "
        }
        
        let prefix = "[Snap.Warning]\(timeString)\(((file as NSString).lastPathComponent as NSString).deletingPathExtension)[\(line)]:"
        let output = items.reduce(prefix) {text, part in 
            "\(text) \(part != nil ? part! : "(nil)")"
        }
        Swift.print(output)
    }
}

internal func errorlog(_ items: Any?..., line: Int = #line, file: String = #file) {
    if SnapManager.ENABLE_LOGGING && SnapManager.SHOW_ERRORS {
        var timeString = " "
        if SnapManager.logDateFormat != "" {
            timeString = " \(SnapLog.logDateFormatter.string(from: Date())) "
        }
        
        let prefix = "[Snap...Error]\(timeString)\(((file as NSString).lastPathComponent as NSString).deletingPathExtension)[\(line)]:"
        let output = items.reduce(prefix) {text, part in 
            "\(text) \(part != nil ? part! : "(nil)")"
        }
        Swift.print(output)
    }
}
