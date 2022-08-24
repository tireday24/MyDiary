//
//  Button.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/24.
//

import UIKit

class DiaryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        layer.borderWidth = Constants.Desgin.borderWidth
        layer.cornerRadius = Constants.Desgin.cornerRadius
        layer.borderColor = UIColor.black.cgColor
        setTitleColor(UIColor.black, for: .normal)
    }
}

