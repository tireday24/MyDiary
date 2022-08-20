//
//  BaseCollectionViewCell.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/20.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI() {
        
    }
    
    func setConstraints() {
        
    }
    
    
}
