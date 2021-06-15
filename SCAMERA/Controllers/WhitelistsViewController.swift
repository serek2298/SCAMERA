
import UIKit

class SecondViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,createWhitelistDelegate,UITextFieldDelegate{
    
    
    var myAPI:API?
    var selectedIndex:Int?
    var filtered = false
    var filteredData = [Whitelist]()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func button(_ sender: UIButton) {
        if let text = textField.text{
            if text != ""{
        myAPI?.createWhitelist(whitelist_name: text)
            }else{
                let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
                let alert = UIAlertController(title: "Warning", message: "Whitelist name is empty.", preferredStyle: .alert)
                alert.addAction(defaultAction)
                self.present(alert, animated: true)
            }
        }
    }
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ModuleCell", bundle: nil),forCellReuseIdentifier: "ReusableCell")
        self.tableView.allowsSelection = true
        myAPI?.createWhitelsitDelegate = self
        self.textField.delegate = self

       
        
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
    func filteredText(_ query:String){
        filteredData.removeAll()
        print(query)
        if let whitelists = sharedUser.whitelists{
            if query != ""{
            for whitelist in whitelists{
                if(whitelist.name.contains(query)){
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
        if let whitelist = sharedUser.whitelists?.count{
        return whitelist
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let index = indexPath.row
        if filtered{
            let index = indexPath.row
        for n in 1...sharedUser.modules!.count{
            if sharedUser.whitelists?[n-1].name == filteredData[index].name{
                self.selectedIndex = n-1
            }
        }}else{
            self.selectedIndex = indexPath.row
        }
        self.performSegue(withIdentifier: "WhitelistsToPlates", sender: self)
            
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ModuleCell
        cell.moduleCellDelegate = self
        if filtered{
            let whitelist = filteredData[indexPath.row].name
                cell.label.text = whitelist
                cell.activeLabel.text = ""
                    return cell
        }else{
            if let whitelist = sharedUser.whitelists?[indexPath.row].name{
                cell.label.text = whitelist
                cell.activeLabel.text = ""
                    return cell
            }
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ThirdViewController {
            vc.myApi = self.myAPI
            vc.selectedIndex = self.selectedIndex
            print(sharedUser)
        }
    }
    
    func didFinishes(what: networking) {
        switch what {
        case .Success:
            print("add plate success from view")
            self.tableView.reloadData()
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Success", message: "Creating a whitelist completed", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        case .Failure:
            print("SecondViewController: nie udalo sie utworzyc nowej whitelisty")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Error", message: "Creating a whitelist failed. Please try again", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        default:
            print("SecondViewController: nothing to do")
        }
    }
}


extension SecondViewController:ModuleCellDelegate{
    func delete(deleted_name: String) {
        let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
        let alert = UIAlertController(title: "Info", message: "Service is currently undergoing maintenance", preferredStyle: .alert)
        alert.addAction(defaultAction)
        self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
    }
    
    
}
