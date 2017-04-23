//
//  Created by Stefan Brighiu on 23/04/2017.
//  Copyright © 2017 SMBCheeky. All rights reserved.
//

import UIKit

/// ALL YOU NEED TO DO IS .snap ;)
///
/// # Useful information ahead:
///
/// - Constraints are added as soon as they are created. 
/// * Views who are subject to SnapConstraints have .translatesAutoresizingMaskIntoConstraints 
/// set to false automatically.
/// - This framework is optimized to hide as many negative values as possible. If a constraint 
/// is not shown properly, try setting the constant as a negative value, and maybe check if you 
/// are using the correct type of SnapConstraint. 
/// * The SnapManager contains internal logging and SnapConstraints options. Please modify as you wish.
/// - The framework is build around SnapConstraintTypes and constraints can be created by accessing
/// any child of UIView, and using the variable '.snap' to initiate the chaining of constraints and mask.
/// Yup, **chaining and masks**, you heard right.
/// * All constraints created can be retrieved immediately by using the .snaps methods on the view they are
/// added to. 
///
/// # Future work:
/// This framework allows you to do a lot of things, but most importantly, it will signal, in the 
/// near future, when you are trying to do something prohibited by your view hierarchy, and most of 
/// the time, it will help you do it in a safe way ;). Some of the issues are: 
/// 1. 1000/999 priority changes
/// 2. multiplier change after the creation of a constraint
/// 3. ... and more to come
///
/// Configure SnapConstraints settings
/// 
/// - Requires: iOS 9
/// - Author: Stefan M. Brighiu (SMBCheeky)
/// - Copyright: Apache License 2.0
public struct SnapManager {
    
    // MARK: - Logging
    /// Turning off logging will stop showing all logs. This is not encouraged because the framework only
    /// logs what the developer must see, like an invalid operation, or that a crash was avoided.
    public static var ENABLE_LOGGING = true
    
    /// Warnings usually are very sparse, and only show if to inform you of something important. It is a 
    /// good idea to not disabled them.
    public static var SHOW_WARNINGS = true
    
    /// Error usually are shown when a crash has been avoided. The framework will handle these cases
    /// but the developer needs to know that something went wrong along the way. All logs done by 
    /// the framework represent invaluable data when debugging. Check your constraints and how 
    /// you implement them and only disable errors as a last resort.
    public static var SHOW_ERRORS = true
    
    private static var _logDateFormat = "HH:mm:ss.SSS"
    /// To disable the logging timestamp, set .logDateFormat to "" (empty string). This value is used as 
    /// .dateFormat for a DateFormatter, so be careful what value you attribute to it. Other values 
    /// can be "HH:mm:ss.SSS", "HH:mm:ss" or "".
    public static var logDateFormat: String {
        get {
            return _logDateFormat
        }
        set {
            _logDateFormat = newValue
            
            let old = SnapLog.logDateFormatter.dateFormat
            if old != _logDateFormat {
                SnapLog.logDateFormatter.dateFormat = _logDateFormat
            }
        }
    }
    
    // MARK: - SnapConstraints
    private static var _useOldConstraintsDescription = false
    /// If you don't like the new constraint format, you can revert to the old one by setting this to true.
    public static var useOldConstraintsDescription: Bool {
        get {
            return _useOldConstraintsDescription
        }
        set {
            _useOldConstraintsDescription = newValue
        }
    }
    
}
