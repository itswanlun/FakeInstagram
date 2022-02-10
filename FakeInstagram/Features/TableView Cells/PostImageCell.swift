import Foundation
import UIKit

class PostImageCell: UITableViewCell {
    var item: RowItem? {
        didSet {
            guard let item = item as? PostImageItem else {
                return
            }
            
            config(url: item.url)
        }
    }
    
    lazy var postImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(url: URL) {
        postImageView.setImage(url: url)
    }
}

private extension PostImageCell {
    func setupUI() {
        contentView.addSubview(postImageView)
        
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
