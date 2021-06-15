
//  Created by iSero on 28/04/2021.


import UIKit

protocol ModuleCellDelegate{
    func delete(deleted_name:String)
}
class ModuleCell: UITableViewCell {
    var moduleCellDelegate:ModuleCellDelegate?
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activeLabel: UILabel!
    
    @IBAction func deleteButton(_ sender: Any) {
        if let text = self.label.text{
        moduleCellDelegate?.delete(deleted_name: text)
        }
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
}
