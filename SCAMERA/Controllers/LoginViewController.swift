
import UIKit

class LoginViewController: UIViewController, LoginDelegate {
   
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    var MyAPI = API()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        MyAPI.loginDelegate = self
    }
    @IBAction func  loginPressed(_ sender: UIButton) {
        if let username = emailTextfield.text, let password = passwordTextfield.text{
            MyAPI.login(username: username, password: password)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is FirstViewController {

        }
        if let vc = segue.destination as? TabBarController {
                vc.myAPI = self.MyAPI
        }
    }

    
 
    func didFinished(what: networking){
        switch what{
        case .Success:
            self.performSegue(withIdentifier: "LoginToTabs", sender: self)
        case .Failure:
            print("Login Failed from LoginView")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Error", message: "Login failed. Please try again", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.emailTextfield.text = "";self.passwordTextfield.text = ""}
        default:
            print("LoginView: I sense something")
        }
    }
    
}


