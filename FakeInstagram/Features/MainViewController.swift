import UIKit

class MainViewController: UIViewController {
    private var data = [Section]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StoryHightlightsCell.self, forCellReuseIdentifier: String(describing: StoryHightlightsCell.self))
        tableView.register(PostHeaderCell.self, forCellReuseIdentifier: String(describing: PostHeaderCell.self))
        tableView.register(PostImageCell.self, forCellReuseIdentifier: String(describing: PostImageCell.self))
        tableView.register(PostActionsCell.self, forCellReuseIdentifier: String(describing: PostActionsCell.self))
        tableView.register(PostContentCell.self, forCellReuseIdentifier: String(describing: PostContentCell.self))
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
}

// MARK: - Load Data
private extension MainViewController {
    func loadData() {
        data = []
        loadStoryHightlightsData()
        loadPostData()
    }
    
    func loadStoryHightlightsData() {
        let emptyStoryItem = StoryItem(imageURL: "", title: "")
        data.append(generateStoryHeightlightsSection(storyData: [emptyStoryItem]))
        
        FakeAPIService.shared.getStoryHeightlight(completionHandler: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let story):
                self.data[0] = self.generateStoryHeightlightsSection(storyData: story)
                
                self.tableView.reloadData()
            case .failure:
                print("error")
            }
            
        })
    }
    
    func loadPostData() {
        FakeAPIService.shared.getPost(completionHandler: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let post):
                for postData in post {
                    self.data.append(self.generatePostSection(postData: postData))
                }
                
                self.tableView.reloadData()
            case .failure:
                print("error")
            }
            
        })
    }

    func generateStoryHeightlightsSection(storyData: [StoryItem]) -> Section {
        var section = StoryHeightlightSection()
        let item = StoryHeightlightItem(items: storyData)
        section.items.append(item)
        return section
    }

    func generatePostSection(postData: PostItem) -> Section {
        var section = PostSection()
        section.items.append(PostHeaderItem(title: postData.account, url: URL(string: postData.accountImage)!))

        section.items.append(PostImageItem(url: URL(string: postData.contentImage)!))
        section.items.append(PostActionsItem(likeButtonStatus: postData.likeButtonStatus))
        section.items.append(PostContentItem(likeCount: postData.likeCount, account: postData.account, content: postData.content))

        return section
    }
}

// MARK: -  Setup UI
private extension MainViewController {
    func setupUI() {
        //view.backgroundColor = .white
        overrideUserInterfaceStyle = .dark
        setupNavigation()
        setupTableView()
    }
    
    func setupNavigation() {
        let titleImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 110, height: 50))
        let logoViewContainer = UIView(frame: titleImageView.frame)
        titleImageView.image = UIImage(named: "instagram")
        titleImageView.contentMode = .scaleAspectFit
//        titleImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
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
        
        tableView.separatorStyle = .none
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = data[indexPath.section]
        let item = section.items[indexPath.row]
        
        switch section.type {
        case .storyHeightlights:
            return storyHightlightsCellConfiguration(tableView, indexPath: indexPath, item: item)
        case .post:
            return postCellConfiguration(tableView, indexPath: indexPath, item: item)
        }
    }
    
    func storyHightlightsCellConfiguration(_ tableView: UITableView, indexPath: IndexPath, item: RowItem) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StoryHightlightsCell.self), for: indexPath) as? StoryHightlightsCell else {
            return UITableViewCell()
        }
        
        cell.item = item
        return cell
    }
    
    func postCellConfiguration(_ tableView: UITableView, indexPath: IndexPath, item: RowItem) -> UITableViewCell {
        switch item.type {
        case .header:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostHeaderCell.self), for: indexPath) as? PostHeaderCell else {
                return UITableViewCell()
            }
            
            cell.item = item
            return cell
        case .image:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostImageCell.self), for: indexPath) as? PostImageCell else {
                return UITableViewCell()
            }
            
            cell.item = item
            return cell
        case .action:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostActionsCell.self), for: indexPath) as? PostActionsCell else {
                return UITableViewCell()
            }
            
            cell.item = item
            return cell
        case .content:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostContentCell.self), for: indexPath) as? PostContentCell else {
                return UITableViewCell()
            }
            
            cell.item = item
            return cell
        default:
            return UITableViewCell()
        }
    }
}
