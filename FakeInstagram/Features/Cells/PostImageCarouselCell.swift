import Foundation
import UIKit

protocol PostImageCarouselCellProtocol: AnyObject {
    func postImageCarouselCell(_ cell: PostImageCarouselCell, page: Int, indexPath: IndexPath)
}

class PostImageCarouselCell: UITableViewCell {
    var item: Row? {
        didSet {
            guard let item = item as? PostImageCarouselItem else {
                return
            }
            
            config(item: item)
        }
    }
    weak var delegate: PostImageCarouselCellProtocol?
    var indexPath: IndexPath?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.removeAllArrangedSubviews()
    }
    
    func config(item: PostImageCarouselItem) {
        for imageURL in item.imageURLs {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.setImage(url: imageURL)

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                imageView.heightAnchor.constraint(equalToConstant: 500),
            ])
            stackView.addArrangedSubview(imageView)
        }
        
        scrollToPage(page: item.page, animated: true)
    }
    
    func scrollToPage(page: Int, animated: Bool) {
        let x = scrollView.frame.size.width * CGFloat(page)
        let y = 0.0
        scrollView.contentOffset = CGPoint(x: x, y: y)
    }
}

extension PostImageCarouselCell {
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 500),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor)
        ])
    }
}

extension PostImageCarouselCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        guard let indexPath = indexPath, let item = item else { return }
        delegate?.postImageCarouselCell(self, page: page, indexPath: indexPath)
    }
}
