//
//  TextField.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/21.
//

import UIKit

class TextFieldSet: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        backgroundColor = .clear
    }
    
}
