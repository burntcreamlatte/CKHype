//
//  HypeListViewController.swift
//  GetHype
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import UIKit

class HypeListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var hypeTableView: UITableView!
    
    // MARK: - Properties
    let refreshControl = UIRefreshControl()
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //helper functions to clean up VDL
        setupViews()
        loadData()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to see new Hypes")
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        hypeTableView.addSubview(refreshControl)
    }
    
    // MARK: - Actions
    //objc so we can add this function as an action to the refresh control
    @objc func loadData() {
        HypeController.shared.fetchAllHypes { (success) in
            if success {
                self.updateViews()
            }
        }
    }
    
    @IBAction func newHypeButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Get Hype", message: "What is Hype may never die", preferredStyle: .alert)
        
        //text field with placeholder
        alertController.addTextField { (textField) in
            textField.placeholder = "What is hype today?"
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            textField.delegate = self
        }
        
        //add cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        //add newhype button
        //completion block is the code that runs when the button is tapped
        let addHypeAction = UIAlertAction(title: "Send", style: .default) { (_) in
            //check for text in the textField and make sure its not empty
            guard let text = alertController.textFields?.first?.text, !text.isEmpty else { return }
            
            //pass the text to the Model Controller to be saved to the cloud
            HypeController.shared.saveHype(with: text) { (success) in
                //if saves successfully, update ui
                if success {
                    self.updateViews()
                }
            }
        }
        //present alert
        alertController.addAction(addHypeAction)
        
        present(alertController, animated: true)
    }
    
    // MARK: - Methods
    //sets up the tableview and refresh control
    func setupViews() {
        //tableView
        hypeTableView.dataSource = self
        
        //refresh control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to see new Hypes")
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        hypeTableView.addSubview(refreshControl)
    }
    
    //update the ui on the main thread after a successful fetch
    func updateViews() {
        DispatchQueue.main.async {
            self.hypeTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
//    func loadData() {
//        HypeController.shared.fetchAllHypes { (success) in
//            if success {
//                self.updateViews()
//            }
//        }
//    }
}



extension HypeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        HypeController.shared.hypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hypeCell", for: indexPath)
        
        let hype = HypeController.shared.hypes[indexPath.row]
        cell.textLabel?.text = hype.body
        cell.detailTextLabel?.text = hype.timestamp.formattedString()
        
        return cell
    }
}

extension HypeListViewController: UITextFieldDelegate {
    //function that gets called when the hit "Return"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //dismiss keyboard
        textField.resignFirstResponder()
    }
}
