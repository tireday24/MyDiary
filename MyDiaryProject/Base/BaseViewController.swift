//
//  BaseViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
    }
    
    //Configure
    func configure() {
        
    }
    
    //Alert
    func showAlert(title: String, button: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
        
    }
    
}
