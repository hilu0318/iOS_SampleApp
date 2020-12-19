//
//  ViewController.swift
//  SampleApp
//
//  Created by ByungHak Jang on 2020/12/13.
//

import UIKit

var itemList:[String] = ["Apple Music Library Player"]

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableViewMain: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewMain.delegate = self
        tableViewMain.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableViewMain.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! TableCell
        cell.lblText.text = itemList[indexPath.row]
        cell.lblText.sizeToFit()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            
        
        switch itemList[indexPath.row] {
        case "Apple Music Library Player":
            print(itemList[indexPath.row])
//            let vc =  self.storyboard?.instantiateViewController(withIdentifier: "AppleMusicLibraryPlayer")
//
//            present(vc as! UIViewController, animated: true)
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AppleMusicLibraryPlayer")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        default:
            print("default")
        }
        
    }
    
}

