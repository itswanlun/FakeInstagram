import Foundation
import UIKit

protocol ErrorViewProtocol: AnyObject {
    func retryTapped(_ button: UIButton)
}

class Testbutton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = (isHighlighted) ? .lightGray : UIColor(rgb: 0x121212)
        }
    }
}

class ErrorView: UIView {
    weak var delegate: ErrorViewProtocol?
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Error loading tap to retry"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var retryButton: Testbutton = {
        let button = Testbutton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var viewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.isUserInteractionEnabled = true
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func retryButtonTapped(_ sender: UIButton) {
        
        delegate?.retryTapped(sender)
    }
    
}

extension ErrorView {
    func setupUI() {

        addSubview(stackView)
        addSubview(retryButton)
        stackView.addArrangedSubview(errorLabel)
        stackView.addArrangedSubview(viewContainer)
        viewContainer.addSubview(retryButton)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            retryButton.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
            retryButton.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
