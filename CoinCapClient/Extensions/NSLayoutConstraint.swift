import UIKit

extension NSLayoutXAxisAnchor {
    public func constraint(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }

    public func constraint(lessThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }

    public func constraint(greaterThanOrEqualTo anchor: NSLayoutXAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }
}

extension NSLayoutYAxisAnchor {
    public func constraint(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(equalTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }

    public func constraint(lessThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(lessThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }

    public func constraint(greaterThanOrEqualTo anchor: NSLayoutYAxisAnchor, constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualTo: anchor, constant: constant)
        constraint.priority = priority
        return constraint
    }
}

extension NSLayoutDimension {
    /// Same as `constraint(equalToConstant c: CGFloat) -> NSLayoutConstraint` but with layout  priority
    public func constraint(equalToConstant constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(equalToConstant: constant)
        constraint.priority = priority
        return constraint
    }

    public func constraint(greaterThanOrEqualToConstant constant: CGFloat, priority: UILayoutPriority) -> NSLayoutConstraint {
        let constraint = constraint(greaterThanOrEqualToConstant: constant)
        constraint.priority = priority
        return constraint
    }
}

extension UILayoutPriority {
    static let almostRequired = UILayoutPriority(999)
}
