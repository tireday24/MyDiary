//
//  BackUpView.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/24.
//

import UIKit

import SnapKit
import Then

class BackUpView: BaseView {
    
    let backUpBoutton = DiaryButton().then {
        $0.setTitle("백업하기", for: .normal)
        $0.backgroundColor = .lightGray
        
    }
    
    let restoreButton = DiaryButton().then {
        $0.setTitle("복구하기", for: .normal)
        $0.backgroundColor = .systemGray
    }
    
    let backUpTableView = UITableView().then {
        $0.backgroundColor = .lightGray
        $0.rowHeight = 80
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        [backUpBoutton, restoreButton,backUpTableView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        backUpBoutton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(100)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.top.equalTo(backUpBoutton.snp.bottom).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
        backUpTableView.snp.makeConstraints { make in
            make.topMargin.equalTo(restoreButton.snp.bottom).offset(10)
            make.trailing.equalTo(-20)
            make.leading.equalTo(20)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
