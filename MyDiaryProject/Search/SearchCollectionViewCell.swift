//
//  SearchCollectionViewCell.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit

import SnapKit

class SearchCollectionViewCell: BaseCollectionViewCell {
    
    let searchImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [searchImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        searchImageView.snp.makeConstraints { make in
            make.bottom.trailing.top.bottom.equalTo(self)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.searchImageView.backgroundColor = .systemBlue
            } else {
                self.searchImageView.backgroundColor = .white
            }
        }
    }
    

}
