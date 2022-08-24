//
//  MainViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/19.
//

import UIKit
import MyDairyProjectFrameWork

import Alamofire
import SwiftyJSON
import JGProgressHUD
import Kingfisher


class SearchViewController: BaseViewController {
    
    //0824 프로토콜을 통한 값 전달 2.값 전달 받을 변수 하나 선언
    var delegate: SelectImageDelegate?
    
    var mainView = SearchView()
    
    let hud = JGProgressHUD()
    var searchImageList: [String] = []
    
    var selectImage: String = ""
    //이미지 자체 값전달 1.
    var searchImage: UIImage?
    
    var selectIndexPath: IndexPath?
    
    var startPage = 1
    var totalCount = 0
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configure() {
        let navi = navigationItem
        navi.title = "이미지를 선택해주세요!"
        navi.rightBarButtonItem = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectButtonClicked))
        navi.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        mainView.imageCollectionView.prefetchDataSource = self
        mainView.imageCollectionView.collectionViewLayout = collectionViewLayout()
        mainView.imageCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        
        mainView.imageSearchBar.delegate = self
        
        //서버 통신 interaction 막음, 로딩되는 시점을 알아야한다
        //view.isUserInteractionEnabled = false
        //mainView.imageCollectionView.isUserInteractionEnabled = false
        
        //백업 복구 할 때 못 넘어가게 막아야함
    }
    
    
    
    @objc func selectButtonClicked() {
        // 옵셔널 해제 버튼 눌렀을 때 이미지 넘기기 2.
        guard let searchImage = searchImage else {
            //선택 안했을 때 얼럿 띄우기, 선택 누르지 못하게 disable 설정 토스트가 더 적합하다(확인을 꼭 누르게 할 필요가 없기 때문에)
            showAlert(title: "사진을 선택해주세요", button: "확인")
            return
        }
        
        delegate?.sendImageData(image: searchImage)
        
        //NotificationCenter.default.post(name: .searchImage, object: nil, userInfo: ["image": selectImage])
        
       dismiss(animated: true)
        
    }
    
    @objc func backButtonClicked() {
        
        dismiss(animated: true)

    }
    
    func uploadImage(query: String) {
        APIManager.shared.requsetAPI(query: query, startPage: startPage) { totalCount, list in
            self.totalCount = totalCount
            self.searchImageList.append(contentsOf: list)
            
            DispatchQueue.main.async {
                self.mainView.imageCollectionView.reloadData()
            }
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell()}
        
        cell.layer.borderWidth = selectIndexPath == indexPath ? 4 : 0
        cell.layer.borderColor = selectIndexPath == indexPath ? Constants.BaseColor.point.cgColor : nil
        
        let url = URL(string: searchImageList[indexPath.item])
        cell.searchImageView.kf.setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //선택 된 이미지를 전달 3.
        //어떤 셀인지 어떤 이미지를 가지고 올 지 어떻게 알까? -> indexPath item 활용
        //테그는 기본적으로 Int만 uiimage를 받을 수 없다
        //UICollectionview 요소라 타입캐스팅 활용해서 작업
        guard let cell = collectionView.cellForItem(at: indexPath) as? SearchCollectionViewCell else { return }
        
        searchImage = cell.searchImageView.image
        
        selectIndexPath = indexPath
        collectionView.reloadData()
        
        //selectImage = searchImageList[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        selectIndexPath = nil
        searchImage = nil
        collectionView.reloadData()
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        let width = (UIScreen.main.bounds.width / 2) - (spacing * 3)
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if searchImageList.count - 1 == indexPath.item && searchImageList.count < totalCount{
                startPage += 30
                
                hud.show(in: mainView)
                
                uploadImage(query: mainView.imageSearchBar.text ?? "cat")
            
            }
            
        }
        
        hud.dismiss(animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소: \(indexPaths)")
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let text = searchBar.text {
            hud.show(in: mainView)
            searchImageList.removeAll()
            
            startPage = 1
            
            uploadImage(query: text)
            
        }
        
        mainView.endEditing(true)
        hud.dismiss(animated: true)
}
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchImageList.removeAll()
        self.mainView.imageCollectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

//extension NSNotification.Name {
//    static let searchImage = NSNotification.Name("searchImage")
//}
