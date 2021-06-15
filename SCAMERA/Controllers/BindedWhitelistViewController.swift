
import Foundation
import UIKit

class First2ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{
    

  
    var myApi:API?
    var selectedIndex:Int?
    var filtered = false
    var filteredData = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var button: UIButton!
    @IBAction func alertButton(_ sender: Any) {
        performSegue(withIdentifier: "showAlerts", sender: self)
    }
    @IBAction func button(_ sender: UIButton) {
        if let name = textField.text{
            myApi?.addWhitelistToModule(whitelist_name: name , unique_id: sharedUser.modules?[self.selectedIndex!].unique_id ?? "")
        }
    }
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        myApi?.addWhitelistToModuleDelegate=self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.textField.delegate = self
        self.tableView.register(UINib(nibName: "ModuleCell", bundle: nil),forCellReuseIdentifier: "ReusableCell")
        self.button.backgroundColor = UIColor(named: "BrandGrey")
        self.button.layer.cornerRadius = button.frame.height / 2
        self.button.layer.shadowOpacity = 0.25

        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text)
        if var text = textField.text{
            print("text = \(text)")
            print("string = \(string)")
            if (text.count == 1 && string == ""){
            filteredText("")
            }else{
                if(string == ""){
                    text.popLast()
                    filteredText(text)
                }else{
                filteredText(text+string)
                }
            }
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AlertView {
            vc.selectedIndex = self.selectedIndex!
        }
    }
    func filteredText(_ query:String){
        filteredData.removeAll()
        print(query)
        if let whitelists = sharedUser.modules?[selectedIndex!].whitelists{
            if query != ""{
            for whitelist in whitelists{
                if(whitelist.contains(query)){
                    filteredData.append(whitelist)
                }
            }
            filtered = true
            }else{
                filtered = false
            }
        }
        self.tableView.reloadData()
        
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered{
            return filteredData.count
        }
        if let whitelist = sharedUser.modules?[self.selectedIndex!].whitelists?.count{
        return whitelist
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ModuleCell
        cell.moduleCellDelegate = self
        if filtered{
            let whitelist = filteredData[indexPath.row]
                cell.label.text = whitelist
                cell.activeLabel.text = ""
                    return cell
        }else{
            if let whitelist = sharedUser.modules?[self.selectedIndex!].whitelists?[indexPath.row]{
                cell.label.text = whitelist
                cell.activeLabel.text = ""
                    return cell
            }
        }
        return cell
    }
}

extension First2ViewController:ModuleCellDelegate{
    func delete(deleted_name: String) {
             myApi?.deleteWhitelistFromModule(whitelist_name: deleted_name, unique_id: (sharedUser.modules?[self.selectedIndex!].unique_id)!, index: self.selectedIndex!)
        }
}

extension First2ViewController:addWhitelistToModuleDelegate{
    func didFinished(what: networking) {
        switch what {
        case .Success:
            print("First2View: addint whitelist complete reloading data")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Success", message: "Adding whitelist completed", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData();print(sharedUser.modules?[self.selectedIndex!].whitelists)}
        case .Failure:
        print("adding whitelis failed")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Error", message: "Adding a whitelist failed. Please try again", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        case .SuccessDeleted:
            print("First2View: addint whitelist complete reloading data")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Success", message: "Adding whitelist completed", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
            
        case .FailureDeleted:
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Error", message: "Deleting a whitelist failed. Please try again", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        default:
            print("First2View co ja robie tu oo")
        }
    }
}
