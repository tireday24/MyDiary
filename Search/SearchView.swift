//
//  MainView.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit

import SnapKit

class SearchView: BaseView {
    
    let imageSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let imageCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout())
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        //collectionView
        [imageSearchBar,imageCollectionView].forEach {
            self.addSubview($0)
        }
        
    }
    
    override func setConstraints() {
        imageSearchBar.snp.makeConstraints { make in
            make.trailingMargin.leadingMargin.equalTo(self.safeAreaLayoutGuide)
            make.topMargin.equalTo(10)
        }
        
        imageCollectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
            make.top.equalTo(imageSearchBar.snp.bottom)
        }
    }
    
}
