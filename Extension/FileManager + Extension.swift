//
//  FileManager + Extension.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/24.
//

import UIKit

extension UIViewController {
    //이미 이미지 없이 저장한 것들이 있을 수 있어서
    func loadImageFromDocument(fileName: String) -> UIImage? {
        //Document 경로 요소를 가져옴(first) 경로 가져오는 코드 안될 수 있으니까 체크(guard) 찍어보면 앱 껐다킬때마다 경로 바뀜 document 파일까지 온거임
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        //경로를 더 해줌 세부 파일 경로 이미지를 저장할 위치
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        //이미지 여부 물어봄
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            //default Image처리
            return UIImage(systemName: "star.fill")
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
    
    //fileManager 활용 싱글톤 패턴으로 이루어져 있음
    func saveImageToDocument(fileName: String, image: UIImage) {
        //Document 경로 요소를 가져옴(first) 경로 가져오는 코드 안될 수 있으니까 체크(guard) 찍어보면 앱 껐다킬때마다 경로 바뀜 document 파일까지 온거임
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        //경로를 더 해줌 세부 파일 경로 이미지를 저장할 위치
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        //용량 줄이는 코드
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        //1gb 저장하고 싶은데 용량없어서 저장 도중에 멈춤 -> error
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
        
    }
}
