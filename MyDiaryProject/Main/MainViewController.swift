//
//  SearchViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit
import MyDairyProjectFrameWork

import SnapKit
import Then


class MainViewController: BaseViewController {
    var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(searchImageNotificationObserver(notification:)), name: .searchImage, object: nil)
    }
    
    @objc func searchImageNotificationObserver(notification: NSNotification) {
        if let image = notification.userInfo?["image"] as? String {
            self.mainView.diaryImageView.kf.setImage(with: URL(string: image))
        }
    }
    
    override func configure() {
        mainView.diaryImageButton.addTarget(self, action: #selector(diaryImageButtonClicked), for: .touchUpInside)
    }
    
    @objc func diaryImageButtonClicked() {
        transitionViewController(storyboard: "Main", vc: SearchViewController(), transition: .present) { _ in
            
        }
    }
    
    

    
    
}
