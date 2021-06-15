
import Foundation
import UIKit

class TabBarController: UITabBarController{
    var myAPI: API?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewControllers = viewControllers else {
            return
        }
        for viewController in viewControllers{

                if let vc = viewController as? FirstViewController {
                    vc.myAPI = self.myAPI
                }
            if let vc = viewController as? SecondViewController {
                vc.myAPI = self.myAPI
            }
            
        }
    }
}
