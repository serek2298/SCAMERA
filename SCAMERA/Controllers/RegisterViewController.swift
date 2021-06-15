
import UIKit

class RegisterViewController: UIViewController {

//    func didFinished(what: networking){
//        switch what{
//        case .Success:
//
//        case .Failure:
//            print("Login Failed from LoginView")
//            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
//            let alert = UIAlertController(title: "Error", message: "Login failed. Please try again", preferredStyle: .alert)
//            alert.addAction(defaultAction)
//            self.epresent(alert, animated: true) {self.emailTextfield.text = "";self.passwordTextfield.text = ""}
//        default:
//            print("LoginView: I sense something")
//        }
//    }

    
    

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBAction func usernameTextField(_ sender: Any) {
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
        let alert = UIAlertController(title: "Warning", message: "Register failed. Service currently under maintaince. Pleasy try again later.", preferredStyle: .alert)
        alert.addAction(defaultAction)
        self.present(alert, animated: true) {self.emailTextfield.text = "";self.passwordTextfield.text = ""}
    }
    
}

