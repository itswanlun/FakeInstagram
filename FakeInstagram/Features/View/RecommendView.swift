import Foundation
import UIKit

class RecommendView: UIView {
    let imageWidthScale: CGFloat = 0.5
    
    lazy var storyButton: UIButton = {
        let storyButton = UIButton()
        storyButton.translatesAutoresizingMaskIntoConstraints = false
        storyButton.clipsToBounds = true
        storyButton.imageView?.contentMode = .scaleAspectFill
        return storyButton
    }()
    
    lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .bold, scale: .default)
        let image = UIImage(systemName: "xmark", withConfiguration: imageConfig)
        closeButton.setImage(image, for: .normal)
        //closeButton.setImage(UIImage(systemName: "xmark", withConfiguration: imageConfig), for: .normal)
        //closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .gray
        
        
        
        return closeButton
    }()
    
    lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .white
        return label
    }()
    
    lazy var followButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Follow", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        storyButton.layer.cornerRadius = bounds.width * imageWidthScale * 0.5
    }
}

private extension RecommendView {
    func setupUI() {
        backgroundColor = .black
        
//        layer.borderColor = UIColor.lightGray.cgColor
//        layer.borderWidth = 0.2
        layer.cornerRadius = 5
        
        addSubview(closeButton)
        addSubview(storyButton)
        addSubview(storyLabel)
        addSubview(followButton)
        
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            closeButton.widthAnchor.constraint(equalToConstant: 10),
            closeButton.heightAnchor.constraint(equalToConstant: 10),
            
            storyButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            storyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            storyButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: imageWidthScale),
            storyButton.heightAnchor.constraint(equalTo: storyButton.widthAnchor, multiplier: 1),
            
            storyLabel.topAnchor.constraint(equalTo: storyButton.bottomAnchor, constant: 10),
            storyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            storyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            followButton.topAnchor.constraint(equalTo: storyLabel.bottomAnchor, constant: 30),
            followButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            followButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        followButton.layer.cornerRadius = 5
    }
}
