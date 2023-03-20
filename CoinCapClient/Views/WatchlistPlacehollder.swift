import Foundation
import UIKit

final class WatchlistPlaceholder: UIView {
    private let titleLabel = UIFactory.label(fontSize: 17, weight: .semibold, color: Asset.Colors.textBody.color)
    private let subtitleLabel = UIFactory.label(fontSize: 13, color: Asset.Colors.textCaptionB.color)
    private let stack = UIFactory.stackV(spacing: 4)

    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
        ])

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)

        titleLabel.text = L10n.watchPlaceholderTitle
        subtitleLabel.text = L10n.watchPlaceholderSubtitle

        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init?(coder:) unavailable")
    }
}
