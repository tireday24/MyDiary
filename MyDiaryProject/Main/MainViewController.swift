//
//  SearchViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit
import MyDairyProjectFrameWork
import RealmSwift // Realm 1번
import PhotosUI

import SnapKit
import Then

protocol SelectImageDelegate {
    func  sendImageData(image: UIImage)
}

class MainViewController: BaseViewController, UITextViewDelegate, UITextFieldDelegate {
    
    let mainView = MainView()
    let localRealm = try! Realm() //Realm 2번 Realm 테이블에 데이터를 CRUD할 때 Realm 테이블 경로에 접근하는 코드
    var imageURL : String?
    
    lazy var imagePicker: UIImagePickerController = {
        let view = UIImagePickerController()
        view.delegate = self
        return view
    }()
    
    let configuration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 0
        return configuration
    }()
    
    lazy var picker: PHPickerViewController = {
        let view = PHPickerViewController(configuration: configuration)
        view.delegate = self
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       // NotificationCenter.default.addObserver(self, selector: #selector(searchImageNotificationObserver(notification:)), name: .searchImage, object: nil)
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    
    
    @objc func searchImageNotificationObserver(notification: NSNotification) {
        if let image = notification.userInfo?["image"] as? String {
            self.mainView.diaryImageView.kf.setImage(with: URL(string: image))
            imageURL = image
        }
        
    }
    
    override func configure() {
        mainView.diaryImageButton.addTarget(self, action: #selector(moreActionTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClikced))
    }
    
    @objc func backButtonClicked() {
        dismiss(animated: true)
    }
    
    
    //저장 해보겠다 Realm + d이미지 도큐먼트 저장
    @objc func saveButtonClikced() {
        
        guard let title = mainView.imgaeTextField.text else {
            showAlert(title: "제목을 입력해주세요", button: "확인")
            return
        }
        
        let tasks = UserDiary(diaryTitle: title, diaryContent: mainView.contentTextView.text!, diaryDate: Date(), regdate: Date(), photo: nil)
        
        do {
            try localRealm.write{
                localRealm.add(tasks)
            }
        } catch let error {
                print(error)
            }
        
        if let image = mainView.diaryImageView.image {
            saveImageToDocument(fileName: "\(tasks.objectId).jpg", image: image)
        }
        
     
//        let task = UserDiary(diaryTitle: mainView.imgaeTextField.text ?? "없음", diaryContent: mainView.subTextField.text ?? "없음", diaryDate: Date(), regdate: Date(), photo: imageURL) // => Record를 하나 추가한다(테이블에서 일자로 보이는 줄)
//
//        try! localRealm.write {
//            localRealm.add(task) //여기서 Create가 일어난다 왜 try? 조금 더 안전하게 데이터를 저장 추가 가져오기 위함
//            print("Realm Succeed")
//            dismiss(animated: true)
//        }
        
        dismiss(animated: true)
    }
    
    
    
//    @objc func diaryImageButtonClicked() {
//        transitionViewController(storyboard: "Main", vc: SearchViewController(), transition: .present) { _ in
//
//        }
//    }
    
    @objc func moreActionTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "방법을 정해주세요!", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라로 촬영하기", style: .default, handler: { _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return
            }
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.picker, animated: true)
        })
        let galleryAction = UIAlertAction(title: "사진 가져오기", style: .default, handler: { _ in
            self.present(self.picker, animated: true)
        })
        let searchAction = UIAlertAction(title: "사진 검색하기", style: .default, handler: { _ in
            let vc = SearchViewController()
            vc.delegate = self
            //화면 전환시 delegate 넘김
            //어떻게 클래스가 들어감? 프로토콜 자체를 타입으로서 기능을 담당함
            self.transition(vc, trasionStyle: .presentFullScreen)
        })
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(searchAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.mainView.diaryImageView.image = image
            dismiss(animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

extension MainViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.mainView.diaryImageView.image = image as? UIImage
                }
            }
        }
    }
}

//0824 프로토콜을 통한 값 전달 1.
extension MainViewController: SelectImageDelegate {
    
    //언제 실행이 되면 될까?
    //선택 버튼 눌렀을때
    func sendImageData(image: UIImage) {
        mainView.diaryImageView.image = image
        //전달 받은 이미지를 보여달라
        print(#function)
    }
    
    
}

//Realm Create Sample Realm 3번
//    @objc func samplebuttonClicked() {
//
//        //mainView.titleTextfield.text 이런식으로 들어감
//        let task = UserDiary(diaryTitle: "가오늘의 일기\(Int.random(in: 1...1000))", diaryContent: "일기 테스트 내용", diaryDate: Date(), regdate: Date(), photo: nil) // => Record를 하나 추가한다(테이블에서 일자로 보이는 줄)
//
//        try! localRealm.write {
//            localRealm.add(task) //여기서 Create가 일어난다 왜 try? 조금 더 안전하게 데이터를 저장 추가 가져오기 위함
//            print("Realm Succeed")
//            dismiss(animated: true)
//        }
//    }
//
