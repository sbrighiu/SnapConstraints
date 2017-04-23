//
//  Created by Stefan Brighiu on 16/04/2017.
//  Copyright © 2017 SMBCheeky. All rights reserved.
//

import UIKit

// This extension adds functionality to every view, without an extra line of code
public extension UIView {
    
    // MARK: --------------RETURN CONSTRAINTS------------------------------------
    /// Used for fetching all SnapConstraint objects of this object from the superview. 
    /// This can eliminate the need to save references and also facilitate easy access 
    /// to the view's constraints. This variable only returns the constraints from one 
    /// layer above the current one (from the immediate superView) and may not return a 
    /// valid result for more complex view hierarchies.
    public var snapsFromSuperview: [SnapConstraint] {
        get {
            if let superview = superview {
                return superview.snaps(fromView: self)
            } else {
                return []
            }
        }
    }
    
    /// Used for fetching all SnapConstraint objects. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    public var snaps: [SnapConstraint] {
        get {
            return self.constraints.filter { $0 is SnapConstraint }.map { $0 as! SnapConstraint }
        }
    }
    
    /// Used for fetching all SnapConstraint objects, by type. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    ///
    /// - Parameter type: The type of the SnapConstraint object (default as: .undefined).
    /// - Returns: The filtered array of SnapConstraint objects.
    @discardableResult public func snaps(ofType type: SnapConstraintType) -> [SnapConstraint] {
        return snaps.filter { 
            if $0.type == type {
                return true
            } 
            return false
        }
    }
    
    /// Used for fetching all SnapConstraint objects, by tag. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    ///
    /// - Parameter tag: The tag of the SnapConstraint object (default as: "").
    /// - Returns: The filtered array of SnapConstraint objects.
    @discardableResult public func snaps(withTag tag: String) -> [SnapConstraint] {
        return snaps.filter {  
            if $0.tag == tag {
                return true
            } 
            return false
        }
    }
    
    /// Used for fetching all SnapConstraint objects, by first view. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    ///
    /// - Parameter firstView: The view you created the constraints on.
    /// - Returns: The filtered array of SnapConstraint objects.
    @discardableResult public func snaps(fromView firstView: UIView) -> [SnapConstraint] {
        return snaps.filter {  
            if $0.firstView == firstView {
                return true
            } 
            return false
        }
    }
    
    /// Used for fetching all SnapConstraint objects, by type and tag. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    ///
    /// - Parameters:
    ///   - type: The type of the SnapConstraint object (default as: .undefined).
    ///   - tag: The tag of the SnapConstraint object (default as: "").
    /// - Returns: The filtered array of SnapConstraint objects.
    @discardableResult public func snaps(ofType type: SnapConstraintType, andTag tag: String) -> [SnapConstraint] {
        return snaps(withTag: tag).filter {  
            if $0.type == type {
                return true
            } 
            return false
        }
    }
    
    /// Used for fetching all SnapConstraint objects, by first view and tag. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    ///
    /// - Parameter firstView: The view you created the constraints on.
    /// - Returns: The filtered array of SnapConstraint objects.
    @discardableResult public func snaps(fromView firstView: UIView, andTag tag: String) -> [SnapConstraint] {
        return snaps(withTag: tag).filter {  
            if $0.firstView == firstView {
                return true
            } 
            return false
        }
    }
    
    /// Used for fetching all SnapConstraint objects, by first view and type. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    ///
    /// - Parameter firstView: The view you created the constraints on.
    /// - Returns: The filtered array of SnapConstraint objects.
    @discardableResult public func snaps(fromView firstView: UIView, andType type: SnapConstraintType) -> [SnapConstraint] {
        return snaps(ofType: type).filter {  
            if $0.firstView == firstView {
                return true
            } 
            return false
        }
    }
    
    /// Used for fetching all SnapConstraint objects, by first view, type and tag. This can eliminate the need 
    /// to save references and also facilitate easy access to the view's constraints.
    ///
    /// - Parameter firstView: The view you created the constraints on.
    /// - Returns: The filtered array of SnapConstraint objects.
    @discardableResult public func snaps(fromView firstView: UIView, type: SnapConstraintType, andTag tag: String) -> [SnapConstraint] {
        return snaps(withTag: tag).filter {  
            if $0.type == type {
                if $0.firstView == firstView {
                    return true
                } 
            } 
            return false
        }
    }
    
    /// Used for creating a dummy constraint that should never be added to the view hierarchy.
    /// Created for the sole purpose of enabling chaining and a clean code.
    var snap: SnapConstraint {
        return SnapConstraint.object(.undefined, firstView: self)
    }

}
