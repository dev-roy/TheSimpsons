//
//  MasterViewController.swift
//  TheSimpsons
//
//  Created by Field Employee on 3/26/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MasterViewController: UITableViewController {

    // MARK: - Properties
    var detailViewController: DetailViewController? = nil
    var characters = [Simpson]()
    let delimiter = " - "

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        let reloadButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadTableView(_:)))
        navigationItem.rightBarButtonItem = reloadButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        getCharacters()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    @objc
    func reloadTableView(_ sender: Any) {
        getCharacters()
    }

    // MARK: - Handlers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = characters[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                detailViewController = controller
            }
        }
    }
    
    // MARK: - Networking
    func getCharacters() {
        characters = []
        DispatchQueue.global(qos: .background).async {
            AF.request("http://api.duckduckgo.com/?q=simpsons+characters&format=json").validate().responseJSON { (response) in
                switch response.result {
                case .success(let data):
                    let json: JSON = JSON(data)
                    let subJson = json["RelatedTopics"]
                    for (_, object) in subJson {
                        let simpson = Simpson()
                        let splitString = object["Text"].stringValue.components(separatedBy: self.delimiter)
                        simpson.name = splitString[0]
                        simpson.description = splitString[1]
                        simpson.imageURL = object["Icon"]["URL"].stringValue
                        self.characters.append(simpson)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }

    // MARK: - Table View Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = characters[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            characters.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}


