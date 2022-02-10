import Foundation
import UIKit

class StoryView: UIView {
    lazy var storyButton: UIButton = {
        let storyButton = UIButton()
        storyButton.translatesAutoresizingMaskIntoConstraints = false
        storyButton.clipsToBounds = true
        storyButton.imageView?.contentMode = .scaleAspectFill
        return storyButton
    }()
    
    lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StoryView {
    func setupUI() {
        addSubview(storyButton)
        addSubview(storyLabel)
        
        NSLayoutConstraint.activate([
            storyButton.topAnchor.constraint(equalTo: topAnchor),
            storyButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            storyButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            storyButton.heightAnchor.constraint(equalToConstant: 70),
            storyButton.widthAnchor.constraint(equalToConstant: 70),
            storyLabel.topAnchor.constraint(equalTo: storyButton.bottomAnchor, constant: 10),
            storyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            storyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            storyLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        storyButton.layer.cornerRadius = 35
    }
}
