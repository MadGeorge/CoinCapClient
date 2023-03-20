import Foundation
import UIKit

final class LoadingCell: BaseCollectionCell {
    private let activityIndicator = UIFactory.activityIndicator()

    override func setupLayout() {
        super.setupLayout()

        contentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])

        backgroundColor = Asset.Colors.bgMain.color
        accessoryType = .none
        separatorInset = .init(top: .zero, left: UIScreen.main.bounds.width, bottom: .zero, right: .zero)
    }
}

extension LoadingCell {
    func startAnimating() {
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
