//
//  Created by Stefan Brighiu on 23/04/2017.
//  Copyright © 2017 SMBCheeky. All rights reserved.
//

import UIKit

/// Used to describe what constraints you want to add to the view. Keep in mind that the 
/// constraint returned after the mask is used will always be the last one (useful when chaining).
public enum SnapMaskValue: Int {
    
    /// These keys are used only for simple SnapConstraints.
    case leading
    case trailing
    case top
    case bottom
    
    case leftOf
    case rightOf
    case above
    case below
    
    case width
    case height
    
    case centerX
    case centerY
    
    /// These keys are used to describe true masks
    case margins, paddings
    
    case fillHorizontally
    case fillVertically
    case fill
    
    case centerHorizontally
    case centerVertically
    case center
    
    case pinTopRightLeft, pinTopLeftRight
    case pinLeftTopBottom, pinLeftBottomTop
    case pinBottomLeftRight, pinBottomRightLeft
    case pinRightTopBottom, pinRightBottomTop
    
    case pinVertically, pinHorizontally
    case pinTopRight, pinTopLeft
    case pinLeftTop, pinLeftBottom
    case pinBottomLeft, pinBottomRight
    case pinRightBottom, pinRightTop
    case pinTopBottom, pinBottomTop
    case pinLeftRight, pinRightLeft
    
    public var types: [SnapConstraintType] {
        switch self {
            
        case .leading:  return [.leading]
        case .trailing: return [.trailing]
        case .top:      return [.top]
        case .bottom:   return [.bottom]
            
        case .leftOf:     return [.leftOf]
        case .rightOf:    return [.rightOf]
        case .above:    return [.above]
        case .below:    return [.below]
            
        case .width:    return [.width]
        case .height:   return [.height]
            
        case .centerY:  return [.centerY]
        case .centerX:  return [.centerX]
            
        // Real masks
        case .margins, .fill, .paddings:        return [.leading, .trailing, .top, .bottom]
        case .fillHorizontally:                 return [.leading, .trailing]
        case .fillVertically:                   return [.top, .bottom]
            
        case .centerHorizontally:   return [.centerX]
        case .centerVertically:     return [.centerY] 
        case .center:               return [.centerX, .centerY]
            
        case .pinTopRightLeft:      return [.top, .trailing, .leading]
        case .pinTopLeftRight:      return [.top, .leading, .trailing]
        case .pinLeftTopBottom:     return [.leading, .top, .bottom]
        case .pinLeftBottomTop:     return [.leading, .bottom, .top]
        case .pinBottomLeftRight:   return [.bottom, .leading, .trailing]
        case .pinBottomRightLeft:   return [.bottom, .trailing, .leading]
        case .pinRightTopBottom:    return [.trailing, .top, .bottom]
        case .pinRightBottomTop:    return [.trailing, .bottom, .top]
        case .pinVertically:        return [.top, .bottom]
        case .pinHorizontally:      return [.leading, .trailing]
            
        case .pinTopRight:          return [.top, .trailing]
        case .pinTopLeft:           return [.top, .leading]
        case .pinTopBottom:         return [.top, .bottom]
        case .pinLeftTop:           return [.leading, .top]
        case .pinLeftBottom:        return [.leading, .bottom]
        case .pinLeftRight:         return [.leading, .trailing]
        case .pinBottomLeft:        return [.bottom, .leading]
        case .pinBottomRight:       return [.bottom, .trailing]
        case .pinBottomTop:         return [.bottom, .top]
        case .pinRightBottom:       return [.trailing, .bottom]
        case .pinRightTop:          return [.trailing, .top]
        case .pinRightLeft:         return [.trailing, .leading]
        }
    }
    
}
























