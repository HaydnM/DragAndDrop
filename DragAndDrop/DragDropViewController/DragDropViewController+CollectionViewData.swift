import UIKit


extension DragDropViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemManager.titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        cell.layer.cornerRadius = 12.0
        cell.titleLabel.text = itemManager.titles[indexPath.row]
        cell.backgroundColor = itemManager.colors[indexPath.row]
        return cell
    }
}
