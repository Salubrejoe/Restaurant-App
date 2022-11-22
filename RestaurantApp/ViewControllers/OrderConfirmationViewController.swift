
import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var confirmationLabel: UILabel!
    let minutesToPrepare: Int
    
    init?(coder: NSCoder, minutesToPrepare: Int) {
        self.minutesToPrepare = minutesToPrepare
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmationLabel.text = "Thanks! Your food will be ready in circa \(minutesToPrepare) minutes"
    }

}
