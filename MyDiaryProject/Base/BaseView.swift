//
//  BaseView.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit

class BaseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //configure
    func configureUI() {
        self.backgroundColor = Constants.BaseColor.background
    }
    
    //constraint
    func setConstraints() {
        
    }
}
