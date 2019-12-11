//
//  SignUpViewController.swift
//  GetHype
//
//  Created by Aaron Shackelford on 12/10/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let username = userTextField.text, !username.isEmpty,
            let bio = bioTextField.text else { return }
        
        UserController.shared.createUser(with: username, bio: bio) { (success) in
            if success {
                self.presentHypeListVC()
            }
        }
    }
    

    func fetchUser() {
        UserController.shared.fetchUser { (success) in
            if success {
                self.presentHypeListVC()
            }
        }
    }
    
    func presentHypeListVC() {
        DispatchQueue.main.async {
            //storyboard was messed up, SHOULD be "HypeList" but not sure how to fix a storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true)
        }
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
