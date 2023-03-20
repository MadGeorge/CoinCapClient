import Foundation
import UIKit

final class HeaderCell: BaseCollectionCell {
    private let titleLabel = UIFactory.label(fontSize: 64, weight: .thin, color: Asset.Colors.textBody.color)
    private let subtitleLabel = UIFactory.label(fontSize: 22, color: Asset.Colors.textError.color)
    private let activityIndicator = UIFactory.activityIndicator()
    private let chartContainer = UIFactory.emptyView(background: .clear)
    private let chart = LineChartView()

    override func setupLayout() {
        super.setupLayout()
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(chartContainer)
        contentView.addSubview(chart)
        contentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
        ])

        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])

        NSLayoutConstraint.activate([
            chartContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            chartContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            chartContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            chartContainer.heightAnchor.constraint(equalToConstant: 210),
        ])

        NSLayoutConstraint.activate([
            chart.rightAnchor.constraint(equalTo: chartContainer.rightAnchor),
            chart.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: -28),
            chart.leftAnchor.constraint(equalTo: chartContainer.leftAnchor),
            chart.topAnchor.constraint(equalTo: chartContainer.topAnchor),
        ])

        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: chartContainer.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: chartContainer.centerXAnchor),
        ])

        titleLabel.minimumScaleFactor = 0.3
        titleLabel.textAlignment = .center
        subtitleLabel.textAlignment = .center

        separatorInset = .zero
        accessoryType = .none
        backgroundColor = Asset.Colors.bgMain.color
        selectionStyle = .none
    }
}

extension HeaderCell {
    @discardableResult
    func configure(
        title: String,
        subtitle: String
    ) -> Self {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        activityIndicator.startAnimating()

        return self
    }

    func draw(_ chart: [Model.Record]) {
        self.chart.draw(chart: chart)
        self.activityIndicator.stopAnimating()
    }
}
