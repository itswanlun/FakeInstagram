import UIKit

enum ViewState {
    case success
    case error
}

class BaseViewController: UIViewController, ErrorViewProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func isContainErrorView() -> Bool {
        for subviews in view.subviews {
            if subviews is ErrorView {
                return true
            }
        }
        return false
    }
    
    func showFullErrorView() {
        guard !isContainErrorView() else { return }
        
        let errorView = ErrorView()
        errorView.delegate = self
        errorView.backgroundColor = UIColor(rgb: 0x121212)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        errorView.bringSubviewToFront(view)
        
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
    }
    
    func removeFullErrorView() {
        for subviews in view.subviews {
            if subviews is ErrorView {
                subviews.removeFromSuperview()
            }
        }
    }
    
    func retryTapped(_ button: UIButton) {
        // do nothing
    }
}

class MainViewController: BaseViewController {
    let viewModel: MainViewModel
    
    let footerHeight: CGFloat = 40
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        
        tableView.register(PostHeaderCell.self, forCellReuseIdentifier: String(describing: PostHeaderCell.self))
        tableView.register(PostImageCell.self, forCellReuseIdentifier: String(describing: PostImageCell.self))
        tableView.register(PostImageCarouselCell.self, forCellReuseIdentifier: String(describing: PostImageCarouselCell.self))
        tableView.register(PostActionsCell.self, forCellReuseIdentifier: String(describing: PostActionsCell.self))
        tableView.register(PostContentCell.self, forCellReuseIdentifier: String(describing: PostContentCell.self))
        
        tableView.register(RecommendHightlightsCell.self, forCellReuseIdentifier: String(describing: RecommendHightlightsCell.self))
        
        return tableView
    }()
    
    lazy var storyHightlightsView: StoryHightlightsView = {
        let view = StoryHightlightsView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        return view
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    lazy var noResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "End"
        label.textColor = .white
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Initialization
    init(viewModel: MainViewModel = MainViewModel()) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadData()
    }
    
    // MARK: - Override
    override func retryTapped(_ button: UIButton) {
        viewModel.loadData()
    }
    
    func bindViewModel() {
        viewModel.dataChangeClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.headerChangeClosure = { [weak self] storyData in
            DispatchQueue.main.async {
                self?.storyHightlightsView.config(stories: storyData)
            }
        }
        
        viewModel.isLoadingClosure = { [weak self] isLoading in
            if isLoading {
                self?.indicatorView.startAnimating()
            } else {
                self?.indicatorView.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.partDataChangeClosure = { [weak self] indexPaths in
            self?.tableView.performBatchUpdates({ 
                self?.tableView.reloadRows(at: indexPaths, with: .none)
            }, completion: nil)
        }
        
        viewModel.loadMoreDataChangeClosure = { [weak self] sections in
            self?.tableView.performBatchUpdates({
                self?.tableView.insertSections(IndexSet(sections), with: .fade)
            }, completion: nil)
        }
        
        viewModel.isNoResultClosure = { [weak self] isNoResult in
            if isNoResult {
                self?.noResultLabel.isHidden = false
            } else {
                self?.noResultLabel.isHidden = true
            }
        }
        
        viewModel.viewStateChageClosure = { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .success:
                    self?.removeFullErrorView()
                case .error:
                    self?.showFullErrorView()
                }
            }
        }
    }
}

// MARK: - Actions
extension MainViewController {
    @objc func refresh() {
        viewModel.refresh()
    }
}

// MARK: -  Setup UI
private extension MainViewController {
    func setupUI() {
        overrideUserInterfaceStyle = .dark
        
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 50))
        let logoViewContainer = UIView(frame: titleImageView.frame)
        titleImageView.image = UIImage(named: "instagram")
        titleImageView.contentMode = .scaleAspectFit
        logoViewContainer.addSubview(titleImageView)
        
        let imageBarButtonItem = UIBarButtonItem(customView: logoViewContainer)
        navigationItem.leftBarButtonItem = imageBarButtonItem
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        tableView.tableHeaderView = storyHightlightsView
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        footerView.addSubview(indicatorView)
        footerView.addSubview(noResultLabel)
        
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            noResultLabel.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            noResultLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        tableView.tableFooterView = footerView
    }
}

// MARK: - PostActionsCellProtocol
extension MainViewController: PostActionsCellProtocol {
    func postActionsCell(_ cell: PostActionsCell, likeButtonTapped info: LikeButtonInfo) {
        viewModel.updateLikeStatus(info: info)
        tableView.reloadRows(at: [info.indexPath], with: .automatic)
    }
}

// MARK: - PostImageCarouselCellProtocol
extension MainViewController: PostImageCarouselCellProtocol {
    func postImageCarouselCell(_ cell: PostImageCarouselCell, page: Int, indexPath: IndexPath) {
        viewModel.changeSectionPage(page, indexPath: indexPath)
    }
}
