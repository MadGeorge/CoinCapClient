import Foundation
import UIKit

enum UIFactory {
    /// Vertical stack, distribution = .fill
    static func stackV(spacing: CGFloat = .zero) -> UIStackView {
        let view = UIStackView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.distribution = .fill
        view.axis = .vertical
        view.spacing = spacing

        return view
    }

    static func label(fontSize: CGFloat, weight: UIFont.Weight = .regular, color: UIColor) -> UILabel {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: fontSize, weight: weight)
        view.textColor = color
        view.adjustsFontSizeToFitWidth = true

        return view
    }

    static func image(_ img: UIImage?, mode: UIView.ContentMode = .scaleAspectFit) -> UIImageView {
        let view = UIImageView(image: img)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = mode

        return view
    }

    static func table(style: UITableView.Style) -> UITableView {
        let view = UITableView(frame: .zero, style: style)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }

    static func emptyView(background: UIColor) -> UIView {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = background

        return view
    }

    static func activityIndicator() -> UIActivityIndicatorView {
        let view: UIActivityIndicatorView

        if #available(iOS 13.0, *) {
            view = UIActivityIndicatorView(style: .large)
        } else {
            view = UIActivityIndicatorView(style: .gray)
        }

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }
}
