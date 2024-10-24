//
//  CardCell.swift
//  InfoApp
//
//  Created by Thalia on 24/10/24.
//

import Foundation
import UIKit

class CardCell: UITableViewCell {
    
    private let imageDefault = UIImage(named: "placeHolder")

    lazy var noticeImage: UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 24
        image.image = imageDefault
        return image
    }()

    lazy var noticeTitle: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.textColor = .textColor
        textLabel.textAlignment = .natural
        textLabel.numberOfLines = 0
        textLabel.backgroundColor = .clear
        textLabel.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel.layer.cornerRadius = 24
        return textLabel
    }()

    lazy var noticeDescription: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.textColor = .textColor
        textLabel.textAlignment = .natural
        textLabel.backgroundColor = .clear
        textLabel.numberOfLines = 0
        textLabel.font = textLabel.font.withSize(14)
        textLabel.layer.cornerRadius = 24
        return textLabel
    }()

    lazy var chapeuLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.textColor = .white
        textLabel.textAlignment = .justified
        textLabel.font = UIFont.boldSystemFont(ofSize: 14)
        textLabel.layer.cornerRadius = 24
        return textLabel
    }()

    lazy var chapeuView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.backgroundColor = .red
        return view
    }()

    lazy var timeLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.adjustsFontForContentSizeCategory = true
        textLabel.textColor = .textColor
        textLabel.textAlignment = .justified
        textLabel.font = UIFont.italicSystemFont(ofSize: 14)
        textLabel.layer.cornerRadius = 14
        return textLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has ot been implemented")
    }

}

extension CardCell: ViewCode {

    func setupConstraints() {
        let defaultMargins: CGFloat = 16
        let noticeConstraints = noticeTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

        let imageHeight = noticeImage.heightAnchor.constraint(equalToConstant: 250)

        noticeConstraints.priority = .defaultLow
            NSLayoutConstraint.activate([

                noticeImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2*defaultMargins),
                noticeImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargins),
                noticeImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargins),
                imageHeight,

                timeLabel.topAnchor.constraint(equalTo: noticeImage.bottomAnchor, constant: 4),
                timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -defaultMargins),
                timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: defaultMargins),
                timeLabel.bottomAnchor.constraint(equalTo: noticeTitle.topAnchor),

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
                chapeuLabel.bottomAnchor.constraint(equalTo: chapeuView.bottomAnchor),
                noticeConstraints
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
