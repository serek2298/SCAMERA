
import UIKit
import Foundation

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = "SCAMERA"
        self.titleLabel.alpha = 0
        UIView.animate(withDuration: 2, delay: 0, options: .transitionCrossDissolve, animations: {
            self.titleLabel.alpha = 1
        })
    }

    
    

}
