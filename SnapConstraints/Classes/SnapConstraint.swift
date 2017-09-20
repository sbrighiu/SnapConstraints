//
//  Created by Stefan Brighiu on 16/04/2017.
//  Copyright © 2017 SMBCheeky. All rights reserved.
//

import UIKit

/// Custom NSLayoutConstraint object type for a more productive developing flow.
final public class SnapConstraint: NSLayoutConstraint {
    
    /// A type for the SnapConstraint object.
    public var type = SnapConstraintType.undefined
    
    /// A custom tag for the constraint. It uses the less know .identifier of NSLayoutConstraint.
    public var tag: String {
        get {
            return self.identifier ?? ""
        }
        set {
            self.identifier = newValue
        }
    }
    
    /// Attributes a code to each view reaches the description computed variable. If a view has a tag, 
    /// it will use that tag and mark it with a '*' instead of a '-'.
    fileprivate static var lastViews = [Int: Int]()
    
    /// The description of a SnapConstraint will include more information than a NSLayoutConstraint.
    ///
    /// Format: "(endline)"tag"<[viewTag*/uniqueID]viewClassType.snapConstraintType.priority{priority}.constant(constant).multiplier[xMultiplier]>"
    ///
    /// If you don't like this format, you can revert to the old one by setting 
    /// SnapManager.useOldConstraintsDescription to true.
    public override var description: String {
        if SnapManager.useOldConstraintsDescription {
            return super.description
        }
        return createDescriptionString(withEndline: false)
    }
    
    /// The debug description of a SnapConstraint will include more information than a NSLayoutConstraint.
    ///
    /// Format: "(endline)"tag"<[viewTag*/uniqueID]viewClassType.snapConstraintType.priority{priority}.constant(constant).multiplier[xMultiplier]>"
    ///
    /// If you don't like this format, you can revert to the old one by setting 
    /// SnapManager.useOldConstraintsDescription to true.
    /// 
    /// Debug description also contains endlines for each constraint.
    public override var debugDescription: String {
        if SnapManager.useOldConstraintsDescription {
            return super.description
        }
        return createDescriptionString(withEndline: true)
    }
    
    /// Create the new constraint description string
    ///
    /// Format: "(endline)"tag"<[viewTag*/uniqueID]viewClassType.snapConstraintType.priority{priority}.constant(constant).multiplier[xMultiplier]>"
    ///
    /// If you don't like this format, you can revert to the old one by setting 
    /// SnapManager.useOldConstraintsDescription to true.
    /// 
    /// - Parameter withEndline: True if the string should be prefixed by an endline operator
    /// - Returns: The new description string.
    private func createDescriptionString(withEndline: Bool) -> String {
        guard let firstView = self.firstView else { return "<SnapConstraint(invalid)>" }
        var firstViewDescription: String
        
        switch firstView {
        case is UIButton:                   firstViewDescription = "UIButton"
        case is UILabel:                    firstViewDescription = "UILabel"
        case is UISegmentedControl:         firstViewDescription = "UISegmentedControl"
        case is UITextField:                firstViewDescription = "UITextField"
        case is UISlider:                   firstViewDescription = "UISlider"
        case is UISwitch:                   firstViewDescription = "UISwitch"
        case is UIActivityIndicatorView:    firstViewDescription = "UIActivityIndicatorView"
        case is UIProgressView:             firstViewDescription = "UIProgressView"
        case is UIPageControl:              firstViewDescription = "UIPageControl"
        case is UIStackView:                firstViewDescription = "UIStackView"
        case is UITableView:                firstViewDescription = "UITableView"
        case is UITableViewCell:            firstViewDescription = "UITableViewCell"
        case is UIImageView:                firstViewDescription = "UIImageView"
        case is UICollectionView:           firstViewDescription = "UICollectionView"
        case is UICollectionViewCell:       firstViewDescription = "UICollectionViewCell"
        case is UICollectionReusableView:   firstViewDescription = "UICollectionReusableView"
        case is UITextView:                 firstViewDescription = "UITextView"
        case is UIScrollView:               firstViewDescription = "UIScrollView"
        case is UIDatePicker:               firstViewDescription = "UIDatePicker"
        case is UIPickerView:               firstViewDescription = "UIPickerView"
        case is UIVisualEffectView:         firstViewDescription = "UIVisualEffectView"
        case is UIWebView:                  firstViewDescription = "UIWebView"
        case is UINavigationBar:            firstViewDescription = "UINavigationBar"
        case is UIToolbar:                  firstViewDescription = "UIToolbar"
        case is UITabBar:                   firstViewDescription = "UITabBar"
        case is UISearchBar:                firstViewDescription = "UISearchBar"
        default:                            firstViewDescription = String(describing: Swift.type(of: firstView))
        }
        
        firstViewDescription = String(describing: Swift.type(of: firstView))
        
        var key: Int
        var keyString = ""
        
        let viewTag = firstView.tag
        if viewTag != 0 {
            key = firstView.tag
            keyString = "[\(key)*]"
        } else {
            key = 1000 + (firstView.hash % 1000)
            keyString = "[\(key)]"
        }
        if SnapConstraint.lastViews[key] == nil {
            SnapConstraint.lastViews[key] = key
        }
        
        firstViewDescription = "\(keyString)\(firstViewDescription)"
        
        let constant = self.constant != 0 ? ".constant(\(self.constant))" : ""
        let multiplier = self.multiplier != 1 ? ".multiplier[x\(self.multiplier)]" : ""
        let priority = self.priority.rawValue != 1000 ? ".priority{\(Int(self.priority.rawValue))}" : ""
        let tag = self.tag != "" ? "\"\(self.tag)\":" : ""
        let endline = withEndline ? "\n" : ""
        
        return "\(endline)\(tag)<\(firstViewDescription)\(self.type.description)\(priority)\(constant)\(multiplier)>"
    }
    
    private override init() {
        super.init()
    }
    
    /// This method is used to create an incomplete constraint.
    ///
    /// - Parameter type: The type of the SnapConstraint object.
    /// - Returns: An incomplete constraint.
    internal static func object(_ type: SnapConstraintType) -> SnapConstraint {
        let constraint = SnapConstraint()
        constraint.type = type
        return constraint
    }
    
    /// This method is used to create a dummy constraint, for chaining purposes.
    ///
    /// - Parameters:
    ///   - type: The type of the SnapConstraint object.
    ///   - firstView: The view in question.
    /// - Returns: A dummy constraint, which should never be added to the view.
    internal static func object(_ type: SnapConstraintType, firstView: UIView) -> SnapConstraint {
        let constraint = SnapConstraint(item: firstView, attribute: .top, relatedBy: .equal, toItem: firstView, attribute: .top, multiplier: 1, constant: 0)
        constraint.tag = "dummy"
        constraint.type = type
        return constraint
    }
    
    /// Valid constraints are automatically added to the view hierarchy. If removed the constraint 
    /// can be added again using this method or the ".isActive = true" line.
    public func add() {
        self.isActive = true
    }
    
    public override var isActive: Bool {
        get {
            return super.isActive
        }
        set {
            if newValue == true, firstView == nil {
                warninglog("This constraint is invalid. Please do not use SnapConstraint() initializer to create constraints. Cancelling change.")
                return
            }
            super.isActive = newValue
        }
    }
    
    /// Valid constraints are automatically added to the view hierarchy. To remove a constraint,
    /// use this method or the ".isActive = false" line.
    public func remove() {
        self.isActive = false
    }
    
    /// Wrapper for the 
    public var firstView: UIView? {
        switch self.firstItem {
        case is UILabel: return self.firstItem as? UILabel
        case is UIButton: return self.firstItem as? UIButton
        default:
            return self.firstItem as? UIView
        }
    }
    
    public var secondView: UIView? {
        return (self.secondItem as? UIView)
    }
    
    // MARK: - 
    // MARK: --------------CONSTRAINT PROXIES-------------------------------
    /// Used to add a leading constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top).
    public var leading: SnapConstraint {
        return leading(with: 0, line: #line, file: #file)   
    }
    
    /// Used to add a leading constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top)
    ///
    /// - Parameters:
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func leading(with constant: CGFloat, to secondView: UIView? = nil, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.leading, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: #line, file: #file)   
    }
    
    // MARK: - 
    /// Used to add a trailing constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top).
    public var trailing: SnapConstraint {
        return trailing(with: 0, line: #line, file: #file)
    }
    
    /// Used to add a trailing constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top).
    ///
    /// - Parameters:
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func trailing(with constant: CGFloat, to secondView: UIView? = nil, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.trailing, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: - 
    /// Used to add a top constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top).
    public var top: SnapConstraint {
        return top(with: 0, line: #line, file: #file)
    }
    
    /// Used to add a top constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top).
    ///
    /// - Parameters:
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func top(with constant: CGFloat, to secondView: UIView? = nil, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.top, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: - 
    /// Used to add a bottom constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top).
    public var bottom: SnapConstraint {
        return bottom(with: 0, line: #line, file: #file)
    }
    
    /// Used to add a bottom constraint. Use only for superview related constraints or 
    /// constraints to views using the same attributes. (leading/leading, top/top).
    ///
    /// - Parameters:
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func bottom(with constant: CGFloat, to secondView: UIView? = nil, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.bottom, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: -     
    /// Used to add a trailing constraint to a left SnapConstraint. Use only for constraints 
    /// inside the superview, when relating to other views (e.g. view1 is on the "left" of view2). 
    /// Uses opposing attributes (leading/trailing, top/bottom) when created.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func left(of secondView: UIView, by constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.leftOf, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: -     
    /// Used to add a leading constraint to a right SnapConstraint. Use only for constraints 
    /// inside the superview, when relating to other views (e.g. view1 is on the "right" of view2). 
    /// Uses opposing attributes (leading/trailing, top/bottom) when created.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func right(of secondView: UIView, by constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.rightOf, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: -    
    /// Used to add a bottom constraint to a UIView that is above the one in question. Use only for constraints 
    /// inside the superview, when relating to other views (e.g. view1 is "above" view2). 
    /// Uses opposing attributes (leading/trailing, top/bottom) when created.
    @discardableResult public func above(_ secondView: UIView, by constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.above, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: -   
    /// Used to add a top constraint to a UIView that is below the one in question. Use only for constraints 
    /// inside the superview, when relating to other views (e.g. view1 is "below" view2). 
    /// Uses opposing attributes (leading/trailing, top/bottom) when created.
    @discardableResult public func below(_ secondView: UIView, by constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.below, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: -     
    /// Used to add a width constraint. The constraint can be of a fixed size or it can represent a ratio 
    /// of the secondView.
    ///
    /// - Parameters:
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func width(of constant: CGFloat, equalTo secondView: UIView? = nil, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.width, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    /// Used to add a width constraint. The constraint can be of a fixed size or it can represent a ratio 
    /// of the secondView.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func width(equalTo secondView: UIView, with constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.width, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: -  
    /// Used to add a height constraint. The constraint can be of a fixed size or it can represent a ratio 
    /// of the second view.
    ///
    /// - Parameters:
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func height(of constant: CGFloat, equalTo secondView: UIView? = nil, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.height, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    /// Used to add a height constraint. The constraint can be of a fixed size or it can represent a ratio 
    /// of the second view.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func height(equalTo secondView: UIView, with constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.height, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    /// Used to add a ratio of width/height constraint. By default it is 1:1.
    ///
    /// - Parameters:
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func ratio(of multiplier: CGFloat = 1, with constant: CGFloat = 0, to secondView: UIView? = nil, priority: Float = 1000, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        return ratioWH(of: multiplier, with: constant, to: secondView, priority: priority, relation: relation)
    }
    
    /// Used to add a ratio of width/height constraint. By default it is 1:1.
    ///
    /// - Parameters:
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func ratioWH(of multiplier: CGFloat = 1, with constant: CGFloat = 0, to secondView: UIView? = nil, priority: Float = 1000, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.ratioWH, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    /// Used to add a ratio of height/width constraint. By default it is 1:1.
    ///
    /// - Parameters:
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func ratioHW(of multiplier: CGFloat = 1, with constant: CGFloat = 0, to secondView: UIView? = nil, priority: Float = 1000, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }

        return SnapConstraint.snapConstraint(.ratioHW, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    /// Used to link 2 views with the same ratio. By default it is 1:1.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func ratio(equalTo secondView: UIView, with constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        return self.height(equalTo: secondView, with: constant, priority: priority, multiplier: multiplier, relation: relation).width(equalTo: secondView, with: constant, priority: priority, multiplier: multiplier, relation: relation)
    }
    
    // MARK: -   
    /// Used to add a centerY constraint. This centers the view vertically in the superview.
    public var centerY: SnapConstraint {
        return centerY(to: nil, line: #line, file: #file)
    }
    
    /// Used to add a centerY constraint. This centers the view vertically in the superview.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func centerY(to secondView: UIView?, with constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.centerY, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    /// Used to add a centerY constraint. This centers the view vertically in the superview.
    public var centerVertically: SnapConstraint {
        return centerVertically(to: nil, line: #line, file: #file)
    }
    
    /// Used to add a centerY constraint. This centers the view vertically in the superview or with the second view.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func centerVertically(to secondView: UIView?, with constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.centerY, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: -  
    /// Used to add a centerX constraint. This centers the view horizontally in the superview.
    public var centerX: SnapConstraint {
        return centerX(to: nil, line: #line, file: #file)
    }
    
    /// Used to add a centerX constraint. This centers the view horizontally in the superview.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func centerX(to secondView: UIView?, with constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.centerX, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    /// Used to add a centerX constraint. This centers the view horizontally in the superview.
    public var centerHorizontally: SnapConstraint {
        return centerHorizontally(to: nil, line: #line, file: #file)
    }
    
    /// Used to add a centerX constraint. This centers the view horizontally in the superview or with the second view.
    ///
    /// - Parameters:
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func centerHorizontally(to secondView: UIView?, with constant: CGFloat = 0, priority: Float = 1000, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal, line: Int = #line, file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        return SnapConstraint.snapConstraint(.centerX, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
    }
    
    // MARK: - 
    /// Used to add SnapConstraints to the view.
    /// This method uses anchors and regular contraints and adds them automatically to the proper view.
    /// Do not forget to add the view and the target view to the view hierarchy before calling this method.
    ///
    /// - Parameters:
    ///   - type: The type of the SnapConstraint object. It should be different that .undefined.
    ///   - constant: The constant value for the constraint. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - firstView: The view which benefits from the constraint. "The first view"
    ///   - secondView: The view to which the constraint is related to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final size.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    internal static func snapConstraint(_ type: SnapConstraintType, 
                                        with constant: CGFloat = 0, 
                                        pointsFrom firstView: UIView,
                                        to secondView: UIView? = nil, 
                                        priority: Float = 1000, 
                                        multiplier: CGFloat = 1,
                                        relation: NSLayoutRelation = .equal,
                                        line: Int = #line, 
                                        file: String = #file) -> SnapConstraint {
        
        if let superview = firstView.superview {
            var target = secondView
            
            var firstAttribute: NSLayoutAttribute!
            var secondAttribute: NSLayoutAttribute!
            
            var constraintModifier: CGFloat = 1
            
            switch type {
                
            // Margins Constraints
            case .leading: 
                firstAttribute = NSLayoutAttribute.leading
                secondAttribute = NSLayoutAttribute.leading
                if target == nil {
                    target = superview
                } 
                
            case .trailing: 
                firstAttribute = NSLayoutAttribute.trailing
                secondAttribute = NSLayoutAttribute.trailing
                if target == nil {
                    target = superview
                }
                constraintModifier = -1
                
            case .top: 
                firstAttribute = NSLayoutAttribute.top
                secondAttribute = NSLayoutAttribute.top
                if target == nil {
                    target = superview
                }
                
            case .bottom: 
                firstAttribute = NSLayoutAttribute.bottom
                secondAttribute = NSLayoutAttribute.bottom
                if target == nil {
                    target = superview
                } 
                constraintModifier = -1
                
            // View Constraints
            case .leftOf:
                firstAttribute = NSLayoutAttribute.trailing
                secondAttribute = NSLayoutAttribute.leading
                constraintModifier = -1
                
            case .rightOf:
                firstAttribute = NSLayoutAttribute.leading
                secondAttribute = NSLayoutAttribute.trailing
                
            case .above:
                firstAttribute = NSLayoutAttribute.bottom
                secondAttribute = NSLayoutAttribute.top
                constraintModifier = -1
                
            case .below:
                firstAttribute = NSLayoutAttribute.top
                secondAttribute = NSLayoutAttribute.bottom
                
            // Size Constraints
            case .width:
                firstAttribute = NSLayoutAttribute.width
                if target == nil {
                    secondAttribute = NSLayoutAttribute.notAnAttribute
                } else {
                    secondAttribute = NSLayoutAttribute.width
                }
                
            case .height:
                firstAttribute = NSLayoutAttribute.height
                if target == nil {
                    secondAttribute = NSLayoutAttribute.notAnAttribute
                } else {
                    secondAttribute = NSLayoutAttribute.height
                }
                
            // Ratio Constraints
            case .ratio, .ratioWH:
                firstAttribute = NSLayoutAttribute.width
                secondAttribute = NSLayoutAttribute.height
                if target == nil {
                    target = firstView
                }
                
            case .ratioHW:
                firstAttribute = NSLayoutAttribute.height
                secondAttribute = NSLayoutAttribute.width
                if target == nil {
                    target = firstView
                }
                
            // Center Constraints
            case .centerY:
                firstAttribute = NSLayoutAttribute.centerY
                secondAttribute = NSLayoutAttribute.centerY
                if target == nil {
                    target = superview
                }
                
            case .centerX:
                firstAttribute = NSLayoutAttribute.centerX
                secondAttribute = NSLayoutAttribute.centerX
                if target == nil {
                    target = superview
                }
                
            default:
                warninglog("Constraint type was not treated correctly. Bypassing \(type.description) and returning default constraint.", line: line, file: file)
            }
            
            if firstAttribute != nil && secondAttribute != nil {
                firstView.translatesAutoresizingMaskIntoConstraints = false
                
                // Creating the constraint
                var constraint: SnapConstraint
                constraint = SnapConstraint(item: firstView, 
                                            attribute: firstAttribute, 
                                            relatedBy: relation, 
                                            toItem: target, 
                                            attribute: secondAttribute, 
                                            multiplier: multiplier, 
                                            constant: constraintModifier * constant)
                
                constraint.priority = UILayoutPriority(rawValue: priority)
                
                // Adding superview Metadata
                constraint.type = type
                
                // Adding to view hierarchy
                constraint.add()
                
                return constraint
                
            } else {
                return SnapConstraint.object(type)
            }
            
        } else {
            errorlog("The view was not added to the view hierarchy. Use .addSubview() on the superview of your choosing and then try again. Bypassing and returning default constraint.")
            return SnapConstraint.object(type)
        }
    }
    
    // MARK: - 
    // MARK: --------------ADD MASKS---------------------------------------------    
    /// Used to add a mask of SnapConstraints, without making an array object. These masks are 
    /// represented as an array of SnapMaskValues.
    ///
    /// - Parameters:
    ///   - values: The list of SnapMaskValues.
    ///   - constant: The constant value for the constraints. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraints relate to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final locations.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult public func mask(_ values: SnapMaskValue..., 
        with constant: CGFloat = 0,
        to secondView: UIView? = nil, 
        priority: Float = 1000, 
        multiplier: CGFloat = 1,
        relation: NSLayoutRelation = .equal,
        line: Int = #line, 
        file: String = #file) -> SnapConstraint {
        var constraint: SnapConstraint!
        for value in values {
            let types = value.types 
            constraint = mask(types, with: constant, to: secondView, priority: priority, multiplier: multiplier, relation: relation)
        }
        
        return constraint ?? SnapConstraint.object(.undefined)
    }
    
    /// Used to add a mask of SnapConstraints, without needing a SnapMask object. This method was 
    /// created for convenience.
    ///
    /// - Parameters:
    ///   - types: The array of SnapConstraintTypes. It should not contain .undefined.
    ///   - constant: The constant value for the constraints. This value will be a modifier if the 
    /// multiplier parameter is != than 1.
    ///   - secondView: The view to which the constraints relate to. When this is not mentioned or is nil, 
    /// it defaults to the superview. "The second view"
    ///   - priority: The UILayoutPriority to be used.
    ///   - multiplier: The multiplier value used to calculate the final locations.
    ///   - relation: The NSLayoutRelation to be used.
    ///   - line: Remembers the #line the method was called from.
    ///   - file: Remembers the #file the method was called from.
    @discardableResult private func mask(_ types: [SnapConstraintType], 
                                         with constant: CGFloat = 0,
                                         to secondView: UIView? = nil, 
                                         priority: Float = 1000, 
                                         multiplier: CGFloat = 1,
                                         relation: NSLayoutRelation = .equal,
                                         line: Int = #line, 
                                         file: String = #file) -> SnapConstraint {
        guard let firstView = self.firstView else { return SnapConstraint.object(type) }
        
        var constraint: SnapConstraint!
        for type in types {
            constraint = SnapConstraint.snapConstraint(type, with: constant, pointsFrom: firstView, to: secondView, priority: priority, multiplier: multiplier, relation: relation, line: line, file: file)
        }
        return constraint ?? SnapConstraint.object(.undefined)
    }
    
}


















