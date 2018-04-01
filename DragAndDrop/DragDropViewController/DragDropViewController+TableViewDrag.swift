import UIKit


extension DragDropViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return itemManager.dragTableItems(for: indexPath)
    }
}
