import UIKit
import MobileCoreServices


class Item: NSObject, Codable {
    
    fileprivate static let customTypeIdentifier = "com.dossierapps.draganddrop.item"
    
    let title: String
    let image: UIImage
    
    enum CodingKeys: String, CodingKey
    {
        case title
        case image
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        let imageData = try values.decode(Data.self, forKey: .image)
        self.image = UIImage(data: imageData)!
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        let imageData = UIImagePNGRepresentation(image)
        try container.encode(imageData, forKey: .image)
    }
    
    init(title: String, color: UIColor) {
        self.title = title
        
        let rect = CGRect(origin: .zero, size: CGSize(width: 30, height: 30))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        self.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
}

extension Item: NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return [customTypeIdentifier, String(kUTTypeUTF8PlainText)]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        var fetchBlock: () -> ()
        switch typeIdentifier {
        case Item.customTypeIdentifier:
            fetchBlock = {
                let encoder = JSONEncoder()
                do {
                    let data = try encoder.encode(self)
                    completionHandler(data, nil)
                }
                catch {
                    completionHandler(nil, error)
                }
            }
        case String(kUTTypeUTF8PlainText):
            fetchBlock = {
                completionHandler(self.title.data(using: String.Encoding.utf8), nil)
            }
        default:
            return nil
        }
        
        let progress = Progress(totalUnitCount: 100)
        
        let queue = DispatchQueue.global()
        let workItem = DispatchWorkItem(block: fetchBlock)
        
        progress.cancellationHandler = {
            workItem.cancel()
        }
        
        queue.async(execute: workItem)
        
        return progress
    }
}

extension Item: NSItemProviderReading {
    
    static var readableTypeIdentifiersForItemProvider: [String] {
        return [customTypeIdentifier]
    }
    
    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(self, from: data)
    }
}


