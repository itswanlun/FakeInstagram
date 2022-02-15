import Foundation
import UIKit

class PostHeaderCell: UITableViewCell {
    var item: Row? {
        didSet {
            guard let item = item as? PostHeaderItem else {
                return
            }
            
            config(title: item.title, url: item.url)
        }
    }
    
    lazy var storyButton: UIButton = {
        let storyButton = UIButton()
        storyButton.translatesAutoresizingMaskIntoConstraints = false
        storyButton.clipsToBounds = true
        storyButton.imageView?.contentMode = .scaleAspectFill
        return storyButton
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(title: String, url: URL) {
        titleLabel.text = title
        storyButton.setImage(url: url)
    }
}

private extension PostHeaderCell {
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(storyButton)
        
        NSLayoutConstraint.activate([
            storyButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            storyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            storyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            storyButton.heightAnchor.constraint(equalToConstant: 36),
            storyButton.widthAnchor.constraint(equalToConstant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: storyButton.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
        
        storyButton.layer.cornerRadius = 18
    }
}
