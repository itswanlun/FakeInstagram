import Foundation
import UIKit

class RecommendHightlightsCell: UITableViewCell {
    var item: Row? {
        didSet {
            guard let item = item as? RecommendListItem else {
                return
            }
            
            config(item: item)
        }
    }
    
    lazy var backgroundStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        //stackView.backgroundColor = UIColor(rgb: 0xFAFAFA)121212
        stackView.backgroundColor = UIColor(rgb: 0x121212)
        return stackView
    }()
    
    lazy var recommendLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "為你推薦"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.removeAllArrangedSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(item: RecommendListItem) {
        for recommend in item.data {
            let view = RecommendView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.storyLabel.text = recommend.title
            if let url = URL(string: recommend.imageURL) {
                view.storyButton.setImage(url: url)
            }

            stackView.addArrangedSubview(view)
            
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: 150),
                view.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
    }
}

extension RecommendHightlightsCell {
    func setupUI() {
        contentView.addSubview(backgroundStackView)
        backgroundStackView.addArrangedSubview(recommendLabel)
        backgroundStackView.addArrangedSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            backgroundStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recommendLabel.heightAnchor.constraint(equalToConstant: 20),
            recommendLabel.topAnchor.constraint(equalTo: backgroundStackView.topAnchor, constant: 16),
            recommendLabel.leadingAnchor.constraint(equalTo: backgroundStackView.leadingAnchor, constant: 16),
            scrollView.heightAnchor.constraint(equalToConstant: 210),
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor)
        ])

    }
}
