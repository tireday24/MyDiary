//
//  SearchView.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit
import SnapKit
import Then

class MainView: BaseView {
    
    let diaryImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.borderWidth = 1
        $0.contentMode = .scaleToFill
    }
    
    let diaryImageButton = UIButton().then {
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor.black.cgColor
        $0.backgroundColor = .black
        $0.layer.borderWidth = 1
        $0.setTitle("Search", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: "systemFont" ,size: 14)
    }
    
    let imgaeTextField = TextFieldSet().then {
        $0.placeholder = " 제목을 입력해주세요"
    }
    
    let subTextField = TextFieldSet().then {
        $0.placeholder = " 부제목을 입력해주세요"
       
    }
    
    let contentTextView = UITextView().then {
        $0.textColor = .black
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 1
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func configureUI() {
        [diaryImageView, diaryImageButton, imgaeTextField, subTextField, contentTextView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        diaryImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leadingMargin.equalTo(20)
            make.trailingMargin.equalTo(-20)
            make.height.equalTo(self).multipliedBy(0.3)
        }
        
        diaryImageButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(44)
            make.trailingMargin.equalTo(diaryImageView.snp.trailing).inset(20)
            make.bottomMargin.equalTo(diaryImageView.snp.bottom).inset(15)
        }
        
        imgaeTextField.snp.makeConstraints { make in
            make.top.equalTo(diaryImageView.snp.bottom).offset(20)
            make.leadingMargin.equalTo(20)
            make.trailingMargin.equalTo(-20)
            make.height.equalTo(50)
        }
        
        subTextField.snp.makeConstraints { make in
            make.top.equalTo(imgaeTextField.snp.bottom).offset(20)
            make.leadingMargin.equalTo(20)
            make.trailingMargin.equalTo(-20)
            make.height.equalTo(50)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(subTextField.snp.bottom).offset(20)
            make.leadingMargin.equalTo(20)
            make.trailingMargin.equalTo(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
