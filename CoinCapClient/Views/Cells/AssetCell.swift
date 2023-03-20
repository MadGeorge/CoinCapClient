import Foundation
import UIKit
import Kingfisher

final class AssetCell: BaseCollectionCell {
    private let leftImage = UIFactory.image(nil)
    private let titleLabel = UIFactory.label(fontSize: 22, color: Asset.Colors.textBody.color)
    private let subtitleLabel = UIFactory.label(fontSize: 13, color: Asset.Colors.textCaptionA.color)
    private let costLabel = UIFactory.label(fontSize: 22, color: Asset.Colors.textCaptionB.color)
    private let changeLabel = UIFactory.label(fontSize: 17, color: Asset.Colors.textSuccess.color)
    private let stackLeft = UIFactory.stackV(spacing: 3)
    private let stackRight = UIFactory.stackV(spacing: 3)

    override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(leftImage)
        contentView.addSubview(stackLeft)
        contentView.addSubview(stackRight)

        NSLayoutConstraint.activate([
            leftImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15),
            leftImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10, priority: .almostRequired),
            leftImage.widthAnchor.constraint(equalToConstant: 60),
        ])

        NSLayoutConstraint.activate([
            stackLeft.leftAnchor.constraint(equalTo: leftImage.rightAnchor, constant: 15),
            stackLeft.centerYAnchor.constraint(equalTo: leftImage.centerYAnchor),
        ])

        NSLayoutConstraint.activate([
            stackRight.leftAnchor.constraint(greaterThanOrEqualTo: stackLeft.rightAnchor, constant: 8),
            stackRight.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            stackRight.centerYAnchor.constraint(equalTo: leftImage.centerYAnchor),
        ])

        stackLeft.addArrangedSubview(titleLabel)
        stackLeft.addArrangedSubview(subtitleLabel)

        stackRight.addArrangedSubview(costLabel)
        stackRight.addArrangedSubview(changeLabel)

        separatorInset = .init(top: .zero, left: 90, bottom: .zero, right: .zero)

        titleLabel.minimumScaleFactor = 0.5
        subtitleLabel.minimumScaleFactor = 0.5
        costLabel.minimumScaleFactor = 0.5
        changeLabel.minimumScaleFactor = 0.5
        costLabel.textAlignment = .right
        changeLabel.textAlignment = .right

        accessibilityLabel = UITests.Identifiers.assetCell
    }
}

extension AssetCell {
    @discardableResult
    func configure(
        image: URL?,
        symbol: String,
        name: String,
        cost: String,
        change: String
    ) -> Self {
        leftImage.kf.setImage(
            with: image,
            placeholder: Asset.Images.assetPlaceholder.image,
            options: [.transition(.fade(0.2))]
        )

        titleLabel.text = symbol
        subtitleLabel.text = name
        costLabel.text = cost
        changeLabel.text = change

        changeLabel.textColor = change.starts(with: "-")
            ? Asset.Colors.textError.color
            : Asset.Colors.textSuccess.color

        return self
    }
}
