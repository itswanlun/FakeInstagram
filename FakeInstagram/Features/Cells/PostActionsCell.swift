import Foundation
import UIKit

typealias LikeButtonInfo = (indexPath: IndexPath, status: Bool)

protocol PostActionsCellProtocol: AnyObject {
    func postActionsCell(_ cell: PostActionsCell, likeButtonTapped info: LikeButtonInfo)
}

class PostActionsCell: UITableViewCell {
    weak var delegate: PostActionsCellProtocol?
    
    var item: Row? {
        didSet {
            guard let item = item as? PostActionsItem else {
                return
            }
            
            config(item: item)// likeButtonStatus: item.likeButtonStatus, likeButtonID: item.id, page: item.page, totalPage: item.totalPage)
        }
    }
    
    var indexPath: IndexPath?
    var likeButtonStatus: Bool = false
    var likeButtonID: Int?
    var page: Int?
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(changeLikeButtonStatus), for: .touchUpInside)
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .systemBlue
        return pageControl
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func config(item: PostActionsItem) {
        self.likeButtonStatus = item.likeButtonStatus
        self.likeButtonID = item.id
        self.page = item.page
        
        if likeButtonStatus {
            likeButton.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = .white
        } else {
            likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = .white
        }
        
        if item.totalPage == 1 {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
            pageControl.numberOfPages = item.totalPage
        }
        
        pageControl.currentPage = item.page
    }
}

private extension PostActionsCell {
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(likeButton)
        contentView.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            likeButton.widthAnchor.constraint(equalToConstant: 28),
            likeButton.heightAnchor.constraint(equalToConstant: 25),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    @objc func changeLikeButtonStatus(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        let info = LikeButtonInfo(indexPath: indexPath, status: likeButtonStatus)
        delegate?.postActionsCell(self, likeButtonTapped: info)
    }
}
