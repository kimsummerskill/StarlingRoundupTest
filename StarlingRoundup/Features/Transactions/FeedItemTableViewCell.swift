//
//  FeedItemTableViewCell.swift
//  StarlingRoundup
//
//  Created by Kim Summerskill on 28/06/2022.
//

import UIKit

class FeedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var transactionTimeLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .white
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(with feedItem: FeedItem, index: Int) {
        accessibilityIdentifier = "feedItem_\(feedItem.feedItemUid)_index_\(index)"
        amountLabel.text = feedItem.amount.amountString
        referenceLabel.text = feedItem.reference
        transactionTimeLabel.text = feedItem.transactionTime
    }
}
