//
//  AlertViewController.swift
//  Flash Chat iOS13
//
//  Created by iSero on 14/06/2021.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import UIKit

class AlertView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var selectedIndex:Int = 0
    @IBOutlet weak var tableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedUser.modules?[selectedIndex].attempts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! alertCell
        if(indexPath.row % 2 == 1){cell.backgroundColor = .lightGray}else{cell.backgroundColor = .white}
        if let id = sharedUser.modules?[selectedIndex].attempts?[indexPath.row].id{
        cell.photo.loadImageUsingUrlString(urlString:"http://192.168.1.24:5000/api/get_photo_for_access_attempt?access_attempt_id=\(id)")
            cell.photo.contentMode = .scaleAspectFit
            cell.photo.clipsToBounds = true
        }
        if let gotaccess = sharedUser.modules?[selectedIndex].attempts?[indexPath.row].got_access{
        cell.accessLabel.text = gotaccess ? "ACCESS GRANTED" : "ACCESS DENIED"
        }
        if let date = sharedUser.modules?[selectedIndex].attempts?[indexPath.row].date{
        cell.dataLabel.text = date
        }
        if let plate = sharedUser.modules?[selectedIndex].attempts?[indexPath.row].plate{
        cell.plateLabel.text = plate
        }
            
        return cell
    
}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "alertCell", bundle: nil),
                                forCellReuseIdentifier: "alertCell")
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
