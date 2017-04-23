//
//  Created by Stefan Brighiu on 23/04/2017.
//  Copyright © 2017 SMBCheeky. All rights reserved.
//

import UIKit


/// Type of the constraint used. 
/// Only use .leading, .trailing, .top, .bottom for superview related constraints or constraints 
/// to views using the same attributes (leading/leading, top/top).
///
/// Only use .left, .right, .above, .below inside the superview, when relating to other views (e.g. view1 
/// is on the "left" of view2). They use opposing attributes like leading/trailing, top/bottom).
public enum SnapConstraintType {
    
    /// Used internally for invalid SnapConstraints. Should not be used...
    case undefined
    
    /// Only use .leading, .trailing, .top, .bottom for superview related constraints or constraints 
    /// using the same attributes. (leading/leading, top/top)
    case leading, trailing, top, bottom
    
    /// Only use .leftOf, .rightOf, .above, .below for constraints inside the superview,
    /// when relating to other views (view1 is on the "left" of view2). These use opposing attributes 
    /// (leading/trailing, top/bottom) when created.
    case leftOf, rightOf, above, below
    
    /// Used for setting width and height of a fixed value or a multiplier.
    case width, height
    
    /// Used to center vertically or horizontally.
    case centerY, centerX
    
    public var description: String {
        switch self {
        case .undefined: return ".undefined"
            
        case .leading:  return ".leading"
        case .trailing: return ".trailing"
        case .top:      return ".top"
        case .bottom:   return ".bottom"
            
        case .leftOf:     return ".left"
        case .rightOf:    return ".right"
        case .above:    return ".above"
        case .below:    return ".below"
            
        case .width:    return ".width"
        case .height:   return ".height"
            
        case .centerY:  return ".centerY"
        case .centerX:  return ".centerX"
        }
    }
    
}
