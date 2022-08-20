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
    var mainView = SearchView()
    
    let hud = JGProgressHUD()
    var searchImageList: [String] = []
    
    var selectImage: String = ""
    
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
        navi.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
        mainView.imageCollectionView.prefetchDataSource = self
        mainView.imageCollectionView.collectionViewLayout = collectionViewLayout()
        mainView.imageCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reuseIdentifier)
        
        mainView.imageSearchBar.delegate = self
        
        
    }
    
    @objc func selectButtonClicked() {
        
        NotificationCenter.default.post(name: .searchImage, object: nil, userInfo: ["image": selectImage])
        
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
        
        let url = URL(string: searchImageList[indexPath.item])
        cell.searchImageView.kf.setImage(with: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImage = searchImageList[indexPath.item]
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

extension NSNotification.Name {
    static let searchImage = NSNotification.Name("searchImage")
}
