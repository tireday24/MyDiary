//
//  File.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/23.
//

import UIKit

class DiaryImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupView() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = Constants.Desgin.cornerRadius
        layer.borderWidth = Constants.Desgin.borderWidth
        layer.borderColor = Constants.BaseColor.border
    }

}

