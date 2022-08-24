//
//  Extension + UIViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/20.
//

import UIKit

extension UIViewController {
    enum Transiton {
        case push
        case present //네비게이션 없이
        case presentFullScreen //네비게이션 임베드 Present
        case presentNavigation //네비게이션 풀스크린
    }
    
//    func example() {
//        let vc = HomeViewController()
//        vc.tasks = "asdf" // 새로운 값이 들어가게 됨 다시 인스턴스 생성하는 코드 쓰게 되면 인스턴스 생성됨 완전 다르게된다
//    }
    
//    func transitionViewController<T:UIViewController>(storyboard: String, _ vc: T, transition: Transiton, complition: (T) -> ()) {
//
//        let sb = UIStoryboard(name: storyboard, bundle: nil)
//
//        switch transition {
//        case .push:
//            guard let vc = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else { return }
//            complition(vc)
//            navigationController?.pushViewController(vc, animated: true)
//        case .present:
//            guard let vc = sb.instantiateViewController(withIdentifier: T.reuseIdentifier) as? T else { return }
//            let nv = UINavigationController(rootViewController: vc)
//            nv.modalPresentationStyle = .fullScreen
//            present(nv, animated: true)
//        case .presentFullScreen:
//            let vc = ViewController
//            vc.modalPresentationStyle = .overFullScreen
//            self.present(vc, animated: true)
//        }
//    }
    
    func transition<T: UIViewController>(_ viewController: T, trasionStyle: Transiton = .present) {
        
        switch trasionStyle {
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .present:
            //self.present(T(), animated: true) 새로운 값이 들어가게 됨 다시 인스턴스 생성하는 코드 쓰게 되면 인스턴스 생성됨 완전 다르게된다
            self.present(viewController, animated: true)
        case .presentFullScreen:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
        }
    }
}

