
import UIKit

class MenuItemDetailViewController: UIViewController {
    
    init?(_ coder: NSCoder, menuItem: MenuItem) {
        self.menuItem = menuItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var menuItem: MenuItem
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    // MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        itemNameLabel.text = menuItem.name
        itemPriceLabel.text = menuItem.price.formatted(.currency(code: "bpd"))
        descriptionLabel.text = menuItem.description
        
        Task.init {
            if let image = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
                imageView.image = image
            }
        }
    }
    
    // Button animation
    @IBAction func addToOrderButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2 , options: [], animations: {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
        MenuController.shared.order.menuItems.append(menuItem)
    }
    
    
}
