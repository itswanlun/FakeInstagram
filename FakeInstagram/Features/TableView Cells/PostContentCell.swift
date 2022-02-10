import Foundation
import UIKit

class PostContentCell: UITableViewCell {
    var item: RowItem? {
        didSet {
            guard let item = item as? PostContentItem  else {
                return
            }
            config(likeCount: item.likeCount, account: item.account, content: item.content)
        }
    }
    
    lazy var likeCountTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(likeCount: Int, account: String, content: String) {
        likeCountTitle.text = "\(likeCount)個讚"
        
        // Content
        let mutableAttributedString = NSMutableAttributedString()
        
        let boldAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .bold) ]
        let mediumAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]
        let accountAttributedString = NSAttributedString(string: "\(account) ", attributes: boldAttribute)
        let contentAttributedString = NSAttributedString(string: content, attributes: mediumAttribute)
        
        mutableAttributedString.append(accountAttributedString)
        mutableAttributedString.append(contentAttributedString)

        // set attributed text on a UILabel
        contentLabel.attributedText = mutableAttributedString
    }
}

private extension PostContentCell {
    func setupUI() {
        contentView.addSubview(likeCountTitle)
        contentView.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            likeCountTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            likeCountTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likeCountTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.topAnchor.constraint(equalTo: likeCountTitle.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
