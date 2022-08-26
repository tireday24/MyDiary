//
//  UserDiaryRepository.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/26.
//

import Foundation
import RealmSwift

// 여러개의 테이블 => CRUD => 제네릭으로 확장

protocol UserDiaryRepositoryType {
    func fetch() -> Results<UserDiary>
    func fetchSort(_ sort: String) -> Results<UserDiary>
    func fetchFilter() -> Results<UserDiary>
    func fetchDate(date: Date) -> Results<UserDiary>
    func updateFavorite(item: UserDiary)
    func deleteItem(item: UserDiary)
    func addItem(item: UserDiary)
    
}

class UserDiaryRepository : UserDiaryRepositoryType {
    
    func fetchDate(date: Date) -> Results<UserDiary> {
        
        //NSPredicate
        //첫번째 매개변수 두번째 date timeinterval
        return localRealm.objects(UserDiary.self).filter("diaryDate >= %@ And diaryDate < %@", date, Date(timeInterval: 86400, since: date))
        
    }
    
    func addItem(item: UserDiary) {
        //
    }
    
    let localRealm = try! Realm() // 하나를 가르킨다 구조체가 싱글톤이 안되는 이유 찾아보기 struct
    
    //fetchRealm 개선
    func fetch() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryTitle", ascending: true) //코드 줄이기 위의 인스턴스에서 가져옴 2.
    }
    
    //키패스를 매개변수로 받아도 된다
    func fetchSort(_ sort: String) -> Results<UserDiary> {
        return  localRealm.objects(UserDiary.self).sorted(byKeyPath: sort, ascending: true)
    }
    
    func fetchFilter() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS[c] '일기'")
    }
    
    func updateFavorite(item: UserDiary) {
        try! localRealm.write{
            //하나의 레코드에서 특정 컬럼 하나만 변경
            item.favorite = !item.favorite
            //item.favorite.toggle() 위에 구문과 똑같음
            
        }
    }
    
    func deleteItem(item: UserDiary) {
        
        removeImageFromDocument(fileName: "\(item.objectId).jpg")
        //사진 먼저 지우고 렘 지우면 문제가 안생겼던 이유
        try! localRealm.write{
            self.localRealm.delete(item) //여기서 다 삭제 됨
        }
     
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        //경로를 더 해줌 세부 파일 경로 이미지를 저장할 위치
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error) //얼럿
        }
    }
}
