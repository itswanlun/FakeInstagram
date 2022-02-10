import Foundation
import UIKit

class PostActionsCell: UITableViewCell {

    var item: RowItem? {
        didSet {
            guard let item = item as? PostActionsItem else {
                return
            }
            
            config(likeButtonStatus: item.likeButtonStatus)
        }
    }
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(likeButtonStatus: Bool) {
        if likeButtonStatus {
            likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            //likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .white
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            //likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        }
    }
}

private extension PostActionsCell {
    func setupUI() {
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            likeButton.widthAnchor.constraint(equalToConstant: 28),
            likeButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
}
