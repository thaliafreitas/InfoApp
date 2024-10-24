//
//  CardCell.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import UIKit
import SkeletonView

class CardCell: UITableViewCell {
    
    private let imageDefault = UIImage(named: "placeHolder")

    private let noticeImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.image = UIImage(named: "placeHolder")
        image.isSkeletonable = true
        return image
    }()

    private let noticeTitle: UILabel = createLabel(font: .boldSystemFont(ofSize: 16), textColor: .textColor)
    private let noticeDescription: UILabel = createLabel(font: .systemFont(ofSize: 14), textColor: .textColor)
    private let chapeuLabel: UILabel = createLabel(font: .boldSystemFont(ofSize: 14), textColor: .white)
    
    private let chapeuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .red
        view.isSkeletonable = true
        return view
    }()
    
    private let timeLabel: UILabel = createLabel(font: .italicSystemFont(ofSize: 14), textColor: .textColor)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func createLabel(font: UIFont, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.textColor = textColor
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = font
        label.isSkeletonable = true
        return label
    }
}

extension CardCell: ViewCode {

    func setupConstraints() {
        let defaultMargins: CGFloat = 16
        let imageHeight = noticeImage.heightAnchor.constraint(equalToConstant: 250)

        NSLayoutConstraint.activate([
            noticeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2 * defaultMargins),
            noticeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargins),
            noticeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargins),
            imageHeight,

            timeLabel.topAnchor.constraint(equalTo: noticeImage.bottomAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargins),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargins),

            noticeTitle.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            noticeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargins),
            noticeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargins),

            noticeDescription.topAnchor.constraint(equalTo: noticeTitle.bottomAnchor),
            noticeDescription.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargins),
            noticeDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargins),
            noticeDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            chapeuView.topAnchor.constraint(equalTo: noticeImage.topAnchor, constant: 24),
            chapeuView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargins),

            chapeuLabel.trailingAnchor.constraint(equalTo: chapeuView.trailingAnchor, constant: -8),
            chapeuLabel.leadingAnchor.constraint(equalTo: chapeuView.leadingAnchor, constant: 8),
            chapeuLabel.topAnchor.constraint(equalTo: chapeuView.topAnchor),
            chapeuLabel.bottomAnchor.constraint(equalTo: chapeuView.bottomAnchor)
        ])
    }

    func buildViewHierarchy() {
        contentView.addSubview(noticeImage)
        contentView.addSubview(noticeTitle)
        contentView.addSubview(noticeDescription)
        contentView.addSubview(chapeuView)
        contentView.addSubview(timeLabel)
        chapeuView.addSubview(chapeuLabel)
    }

    func setupCell(url: String?, noticeTitle: String?, noticeDescription: String?, chapeuLabel: String?, timeLabel: String?, image: String?) {
        self.noticeTitle.text = noticeTitle
        self.noticeDescription.text = noticeDescription
        self.chapeuLabel.text = chapeuLabel
        self.timeLabel.text = timeLabel

        if let urlString = image, let urlValid = URL(string: urlString) {
            self.noticeImage.load(url: urlValid)
        } else {
            self.noticeImage.image = imageDefault
        }
    }
}
