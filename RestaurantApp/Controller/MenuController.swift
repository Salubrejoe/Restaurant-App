
import UIKit

class MenuController {
    
    var userActivity = NSUserActivity(activityType: "com.exercise.RestaurantApp.order"
    )
    
    // Shared singleton
    static let shared = MenuController()
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
            userActivity.order = order
        }
    }
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    
    // MARK: !!Error enum
    enum MenuControllerError: Error, LocalizedError {
        case categoriesNotFound
        case menuItemsNotFound
        case orderRequestFailed
        case imageNotFound
    }
    
    // MARK: Fetch Categories
    func fetchCategories() async throws -> [String] {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        // Use a shared instance of URLSession to make the Request
        let (data, response) = try await URLSession.shared.data(from: categoriesURL)
        
        // Catch errors
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.categoriesNotFound
        }
        
        // Decode
        let jsonDecoder = JSONDecoder()
        let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
        
        return categoriesResponse.categories
    }
    
    
    // MARK: Fetch MenuItems
    func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
        let baseMenuURL = baseURL.appendingPathComponent("menu")
        
        // Use URLComponents to append a collection of URLQueryItems
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        
        // Use a shared instance of URLSession to make the Request
        let (data, response) = try await URLSession.shared.data(from: menuURL)
        
        // Catch errors
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.menuItemsNotFound
        }
        
        // Decode
        let decoder = JSONDecoder()
        let menuResponse = try decoder.decode(MenuResponse.self, from: data)
        
        return menuResponse.items
    }
    
    
    // MARK: Fetch Images
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.imageNotFound
        }
        
        guard let image = UIImage(data: data) else {
            throw MenuControllerError.imageNotFound
        }
        
        return image
    }
    
    
    // MARK: Submit Order
    
    typealias MinutesToPrepare = Int
    func submitOrder(forMenuIDs menuIDs: [Int]) async throws -> MinutesToPrepare {
        let orderURL = baseURL.appendingPathComponent("order")

        // Create a URL request rather then submitting the request with a url
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Store an array of menu IDs in JSON under menuIds with a dictionary
        let menuIdsDictionary = ["menuIds":menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(menuIdsDictionary)
        // Store the data for a POST in the body of the request, then data(for:delegate:)
        request.httpBody = jsonData

        // Make request
        let (data, response) = try await URLSession.shared.data(for: request)

        //Catch errors
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw MenuControllerError.orderRequestFailed
        }

        // Decode
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(OrderResponse.self, from: data)

        return orderResponse.prepTime
    }
    
}
