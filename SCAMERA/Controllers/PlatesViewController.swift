

import UIKit

class ThirdViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    
    
    var myApi:API?
    var selectedIndex:Int?
    var filtered = false
    var filteredData = [String]()
    
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func button(_ sender: Any) {
        if let plate = textField.text{
            myApi?.addPlate(whitelist_name: sharedUser.whitelists?[self.selectedIndex!].name ?? "", plate: plate)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.textField.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ModuleCell", bundle: nil),forCellReuseIdentifier: "ReusableCell")
        print(sharedUser)
        myApi?.addPlateDelegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
    }
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
        if let plates = sharedUser.whitelists?[self.selectedIndex!].plates{
            if query != ""{
                for plate in plates{
                    if(plate.contains(query)){
                        filteredData.append(plate)
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
        if let whitelist = sharedUser.whitelists?[self.selectedIndex!].plates?.count{
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
            let plate = filteredData[indexPath.row]
            cell.label.text = plate
            cell.activeLabel.text = ""
            return cell
            
        }else{
            if let plate = sharedUser.whitelists?[self.selectedIndex!].plates?[indexPath.row]{
                cell.label.text = plate
                cell.activeLabel.text = ""
                return cell
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
}

extension ThirdViewController:ModuleCellDelegate{
    func delete(deleted_name: String) {
        let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
        let alert = UIAlertController(title: "Info", message: "Service is currently undergoing maintenance", preferredStyle: .alert)
        alert.addAction(defaultAction)
        self.present(alert, animated: true) {self.textField.text = "";}
    }
    
    
}

extension ThirdViewController:addPlateDelegate{
    func didFinished(what: networking) {
        switch what{
        case .Success:
            self.tableView.reloadData()
            print("ThirdViewController: Adding plate complete initializing reloading data")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Success", message: "Adding new plate to whitelist completed", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
            
        case .Failure:
            print("ThirdViewController: Adding plate failed")
            let defaultAction = UIAlertAction(title: "OK", style: .default){action in}
            let alert = UIAlertController(title: "Error", message: "Adding plate failed. Pleasy try again. ", preferredStyle: .alert)
            alert.addAction(defaultAction)
            self.present(alert, animated: true) {self.textField.text = "";self.filtered = false;self.tableView.reloadData()}
        case .SuccessDeleted:
            print("thirdview successedelted maintaince")
        case .FailureDeleted:
            print("thirdview failuredelted maintaince")
        }
    }
}
