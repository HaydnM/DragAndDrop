import UIKit


extension DragDropViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return itemManager.dragCollectionItems(for: indexPath)
    }
}
