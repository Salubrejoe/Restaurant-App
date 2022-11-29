
import Foundation

extension NSUserActivity {
    
    var order: Order? {
        
        // Attempt to load an Order from the underlying userInfo dict
        get {
            guard let jsonData = userInfo?["order"] as? Data else { return nil }
            
            return try? JSONDecoder().decode(Order.self, from: jsonData)
            
        }
        
        // Takes the provided Order instance and encodes it to userInfo as JSONData, both using the same "order" key
        set {
            if let newValue = newValue,
               let jsonData = try? JSONEncoder().encode(newValue) {
                addUserInfoEntries(from: ["order": jsonData])
            } else {
                userInfo?["order"] = nil
            }
        }
    }
}
