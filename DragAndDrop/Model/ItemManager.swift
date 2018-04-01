import UIKit
import MobileCoreServices

class ItemManager {
    
    let titles = [
        "Item 1",
        "Item 2",
        "Item 3",
        "Item 4",
        "Item 5"
    ]
    
    let colors = [
        UIColor(named: "Color1")!,
        UIColor(named: "Color2")!,
        UIColor(named: "Color3")!,
        UIColor(named: "Color4")!,
        UIColor(named: "Color5")!
    ]
    
    private(set) var tableItems = [Item]()
    
    func addTableItem(_ item: Item, at index: Int) {
        tableItems.insert(item, at: index)
    }
    
    func removeTableItem(at index: Int) {
        tableItems.remove(at: index)
    }
    
    func swapTableItems(indexA: Int, indexB: Int) {
        tableItems.swapAt(indexA, indexB)
    }
    
    func dragTableItems(for indexPath: IndexPath) -> [UIDragItem] {
        let item = tableItems[indexPath.row]
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypeData as String, visibility: .all) { completion in
            completion(try! JSONEncoder().encode(item), nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
    func dragCollectionItems(for indexPath: IndexPath) -> [UIDragItem] {
        let title = titles[indexPath.row]
        let color = colors[indexPath.row]

        let item = Item(title: title, color: color)

        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}
