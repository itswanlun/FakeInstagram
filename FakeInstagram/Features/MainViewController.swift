import UIKit

class MainViewController: UIViewController {
    let viewModel: MainViewModel
    
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
        return indicator
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
        
        viewModel.loadPostData()
        viewModel.loadStoryHightlightsData()
    }
    
    func bindViewModel() {
        viewModel.dataChangeClosure = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.headerChangeClosure = { [weak self] storyData in
            self?.storyHightlightsView.config(stories: storyData)
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
        tableView.tableFooterView = indicatorView
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
