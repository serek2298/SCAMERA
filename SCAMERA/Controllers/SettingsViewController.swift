
import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
     override func viewWillAppear(_ animated: Bool) {
        let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
        let alert = UIAlertController(title: "Info", message: "Service is currently unavailable", preferredStyle: .alert)
        alert.addAction(defaultAction)
        self.present(alert, animated: true){
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "Logout", sender: self)
            }
            
        }
    }
}
