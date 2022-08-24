//
//  BackUpViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/24.
//

import UIKit
import SnapKit

class BackUpViewController: BaseViewController {
    
    
    
    let mainView = BackUpView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
    }
    
    override func configure() {
        //
    }
    
    override func setConstraints() {
       
    }
}
