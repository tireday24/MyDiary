//
//  RealmModel.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/22.
//

import Foundation
import RealmSwift

//UserDiary: table이름
//@Persisted: Column
//Object Realm 만들어질때 필요한거구나
//테이블 정리할 때 필요한 코드
class UserDiary: Object {
    @Persisted var diaryTitle: String //제목(필수)
    @Persisted var diaryContent: String?//내용(옵션)
    @Persisted var diaryDate = Date()//작성 날짜(필수)
    @Persisted var regdate = Date()//등록 날짜(필수)
    @Persisted var favorite: Bool //즐겨찾기(필수)
    @Persisted var photo: String?//사진String(옵션)
    
    //PK(필수): Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    
    convenience init(diaryTitle: String, diaryContent: String?, diaryDate: Date, regdate: Date, photo: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryDate = diaryDate
        self.regdate = regdate
        self.favorite = false
        self.photo = photo
    }
}
    
    //Thread 1: "Attempting to create an object of type 'UserDiary' with an existing primary key value '0'."
    //-> object 아이디를 가져올 때 int 기반으로 가져오면 초기값 0이기 때문에 똑같이 0으로 다음버튼 눌렀을 때 저장되기 때문에 PK 중복으로 오류 난다
    //추가 삭제시 이전 데이터의 테이블을 가지고 있어서(version1) 이 상태에서 테이블을 하나 더 만들어서(version2) 엑셀시트는 version1 그러기 때문에 version2를 가져오면 충돌남
    //해결하기 쉬운 방법 -> 1. 앱을 삭제했다가 다시 설치 -> 테이블도 날라간다
    //              -> 2. 이미 출시를 했다면? 마이그레이션 이전 버전과 이후 버전을 일치시켜주는 용어, 스키마 버전 관리하기 위해서 만듬 -> migration이 요구된다고 debugging에 나옴





