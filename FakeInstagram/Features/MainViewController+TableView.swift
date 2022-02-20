import Foundation
import UIKit

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.data[indexPath.section]
        let item = section.rows[indexPath.row]
        
        switch section.type {
        case .recommend:
            return recommendCellConfiguConfiguration(tableView, indexPath: indexPath, item: item)
        case .post:
            return postCellConfiguration(tableView, indexPath: indexPath, item: item)
        }
    }
    
    func recommendCellConfiguConfiguration(_ tableView: UITableView, indexPath: IndexPath, item: Row) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecommendHightlightsCell.self), for: indexPath) as? RecommendHightlightsCell else {
            return UITableViewCell()
        }
        
        cell.item = item
        return cell
    }
    
    func postCellConfiguration(_ tableView: UITableView, indexPath: IndexPath, item: Row) -> UITableViewCell {
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
        case .imageCarousel:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostImageCarouselCell.self), for: indexPath) as? PostImageCarouselCell else {
                return UITableViewCell()
            }
            
            cell.item = item
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        case .action:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PostActionsCell.self), for: indexPath) as? PostActionsCell else {
                return UITableViewCell()
            }
            
            cell.item = item
            cell.delegate = self
            cell.indexPath = indexPath
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.loadNextPageIfNeed(section: indexPath.section)
    }
}
