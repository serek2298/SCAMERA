
import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate{
    var myAPI : API?
    var selectedIndex:Int?
    var filteredData = [Module]()
    var filtered = false
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addButton(_ sender: Any) {
        if let text = textField.text{
            myAPI?.addModule(module_id: text )
        }
    }
    @IBOutlet weak var textField: UITextField!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if var text = textField.text{
            if (text.count == 1 && string == ""){
                filteredText("")
            }else{
                if(string == ""){
                    _ = text.popLast()
                    filteredText(text)
                }else{
                    filteredText(text+string)
                }
            }
        }
        return true
    }
    func filteredText(_ query:String){
        filteredData.removeAll()
        print(query)
        if let modules = sharedUser.modules{
            if query != ""{
                for module in modules{
                    if(module.unique_id.contains(query)){
                        filteredData.append(module)
                    }
                }
                filtered = true
            }else{
                filtered = false
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Modules"
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ModuleCell", bundle: nil),
                                forCellReuseIdentifier: "ReusableCell")
        self.tableView.allowsSelection = true
        self.tableView.delegate = self
        self.textField.delegate = self
        myAPI?.addModuleDelegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        myAPI?.getWhitelists(username: sharedUser.username, password: sharedUser.password)
    }
    @objc func notificationReceived(){
        
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        
    }
    
    
}


extension FirstViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filtered{
            return filteredData.count
        }
        if let modules = sharedUser.modules{
            return modules.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if filtered{
            let index = indexPath.row
            for n in 1...sharedUser.modules!.count{
                if sharedUser.modules?[n-1].unique_id == filteredData[index].unique_id{
                    self.selectedIndex = n-1
                }
            }}else{
                self.selectedIndex = indexPath.row
            }
        self.performSegue(withIdentifier: "FirstToFirst2", sender: self)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ModuleCell
        cell.moduleCellDelegate = self
        if filtered{
            let modules = filteredData
            cell.label.text = "\(modules[indexPath.row].unique_id)"
            if(modules[indexPath.row].isActive){
                cell.activeLabel.text = "Active"
            }else{
                cell.activeLabel.text = "Inactive"
                cell.activeLabel.textColor = UIColor.red
                
            }
            return cell
        }else{
            if let modules = sharedUser.modules{
                cell.label.text = "\(modules[indexPath.row].unique_id)"
                if(modules[indexPath.row].isActive){
                    cell.activeLabel.text = "Active"
                }else{
                    cell.activeLabel.text = "Inactive"
                    cell.activeLabel.textColor = UIColor.red
                    
                }
                return cell
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? First2ViewController {
            vc.myApi = self.myAPI
            self.myAPI?.getAttempts(module_index: selectedIndex!)
            vc.selectedIndex = self.selectedIndex
            
        }
    }
}


extension FirstViewController: ModuleCellDelegate{
    func delete(deleted_name: String) {
        myAPI?.deleteModule(module_id: deleted_name)
    }
}

extension FirstViewController:addModuleDelegate{
    func didFinished(what: networking) {
        switch what{
        case .Success:
            print("FirstViewController: dodanie pomyslnie -> reloading data")
            self.tableView.reloadData()
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Success", message: "Binding module completed.", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        case .Failure:
            print("FirstViewController: dodanie nie pomyslnie")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Error", message: "Binding module failed. Please try again", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
            
            
            
            
        case .FailureDeleted:
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Error", message: "Deleting module failed. Please try again", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        case .SuccessDeleted:
            self.tableView.reloadData()
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Success", message: "Module deleted.", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        }
    }
}
