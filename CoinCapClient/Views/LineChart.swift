import Foundation
import UIKit
import CoreGraphics

final class LineChartView: UIView {
    let chartLayer = CAShapeLayer()
    let labelMax = UILabel(frame: .zero)
    let labelMin = UILabel(frame: .zero)

    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        labelMax.translatesAutoresizingMaskIntoConstraints = false
        labelMin.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelMax)
        addSubview(labelMin)

        labelMax.topAnchor.constraint(equalTo: topAnchor).isActive = true
        labelMin.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4).isActive = true

        labelMin.font = .systemFont(ofSize: 13)
        labelMax.font = .systemFont(ofSize: 13)

        labelMin.textColor = .gray
        labelMax.textColor = .gray
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        chartLayer.frame = .init(
            origin: .init(x: .zero, y: 19),
            size: .init(width: bounds.width, height: bounds.height - 34)
        )
    }
}

extension LineChartView {
    func draw(chart: [Model.Record]) {
        if chart.count < 2 { return }

        let width = chartLayer.bounds.width
        let height = chartLayer.bounds.height

        var minY = CGFloat.infinity
        var maxY = CGFloat.infinity * -1
        var minPriceX = CGFloat.zero
        var maxPriceX = CGFloat.zero
        var minPrice = "$0"
        var maxPrice = "$0"

        var points = [CGPoint]()

        for record in chart {
            let price = CGFloat(truncating: NumberFormatter().number(from: record.priceUsd) ?? 0)
            let time = CGFloat(record.time)

            if price < minY {
                minY = price
                minPriceX = time
                minPrice = DataFormatter.usd(record.priceUsd, maxFraction: .zero)
            }

            if price > maxY {
                maxY = price
                maxPriceX = time
                maxPrice = DataFormatter.usd(record.priceUsd, maxFraction: .zero)
            }

            points.append(.init(x: time, y: price))
        }

        let minX = points[0].x
        let maxX = points[points.count - 1].x

        let scalingFactorX = width / (maxX - minX)
        let scalingFactorY = height / (maxY - minY)

        minPriceX = (minPriceX - minX) * scalingFactorX
        maxPriceX = (maxPriceX - minX) * scalingFactorX

        let path = UIBezierPath()

        for (i, point) in points.enumerated() {
            points[i] = .init(
                x: (point.x - minX) * scalingFactorX,
                y: height - ((point.y - minY) * scalingFactorY)
            )

            if i == .zero {
                path.move(to: points[i])
            } else {
                path.addLine(to: points[i])
            }
        }

        chartLayer.backgroundColor = UIColor.clear.cgColor
        chartLayer.fillColor = UIColor.clear.cgColor
        chartLayer.strokeColor = UIColor.black.cgColor
        chartLayer.lineWidth = 2
        chartLayer.lineJoin = .bevel
        chartLayer.path = path.cgPath

        labelMax.text = maxPrice
        labelMin.text = minPrice
        labelMax.sizeToFit()
        labelMin.sizeToFit()


        maxPriceX = min((width - labelMax.frame.width), max(.zero, (maxPriceX - labelMax.frame.width / 2)))
        minPriceX = min((width - labelMax.frame.width), max(.zero, (minPriceX - labelMin.frame.width / 2)))

        labelMax.leftAnchor.constraint(equalTo: leftAnchor, constant: maxPriceX).isActive = true
        labelMin.leftAnchor.constraint(equalTo: leftAnchor, constant: minPriceX).isActive = true

        if chartLayer.superlayer == nil {
            layer.addSublayer(chartLayer)
        }
    }
}
