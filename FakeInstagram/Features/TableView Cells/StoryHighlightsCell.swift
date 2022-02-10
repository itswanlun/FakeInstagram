import Foundation
import UIKit

class StoryHightlightsCell: UITableViewCell {
    var item: RowItem? {
        didSet {
            guard let item = item as? StoryHeightlightItem else {
                return
            }
            
            config(stories: item.cellItem)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 15
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
    
    func config(stories: [StoryItem]) {
        for story in stories {
            let view = StoryView()
            view.storyLabel.text = story.title
            if let url = URL(string: story.imageURL) {
                view.storyButton.setImage(url: url)
            }
//            view.storyButton.layoutIfNeeded()
//            view.storyButton.subviews.first?.contentMode = .scaleAspectFill
            
            stackView.addArrangedSubview(view)
        }
    }
}

private extension StoryHightlightsCell {
    func setupUI() {
        contentView.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 100),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor)
        ])
    }
}
