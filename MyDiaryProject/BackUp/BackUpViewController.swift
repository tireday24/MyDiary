//
//  BackUpViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/24.
//

import UIKit
import SnapKit
import Zip

class BackUpViewController: BaseViewController {
    
    let mainView = BackUpView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.backupButtonClicked()
//        }
        mainView.backUpBoutton.addTarget(self, action: #selector(backupButtonClicked), for: .touchUpInside)
        mainView.restoreButton.addTarget(self, action: #selector(restoreButtonClicked), for: .touchUpInside)
    }
    
    override func configure() {
        //
    }
    
    override func setConstraints() {
       //
    }
    
    @objc func backupButtonClicked() {
        
        var urlPaths = [URL]() //1.
        
        //도큐먼트 위치에 백업 파일이 있는지 확인 2.
        // ~~~ /Documents 의경로 터미널에 file ~ document 위치를 알아야 경로를 가져올 수 있다
        guard let path = documentDirectoryPath() else {
            showAlert(title: "도큐먼트 위치에 오류가 있습니다")
            return
        }
        
        //appendingPathComponent -> / /default.realm 찍어서 경로를 보는 구문
        let realmFile = path.appendingPathComponent("default.realm") //경로 명시 3. 도큐먼트 파일에 있는 디폴트 렘에 접근 단순한 경로
        
        //파일이 유효한지 확인 4. 파일 없으면 얼럿
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlert(title: "벡업할 파일이 없습니다")
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!) // url있는지 확인했으니까 보여줄 수 있다 relmFile로 추가해줘도 됨 -> url 리스트에 추가 해줌
        
        //백업 파일을 압축: URL 경로 기반으로 압축 링크를 만듬
        //압축해주는 라이브러리가 있다 swift zip gitub 검색해서 spm
        //위에 배열 가지고 왔고 압축 파일 명이 뒤에 string ~~.zip파일로 저장됨
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "SeSACDiary_1")
            print("Archive Location: \(zipFilePath)")
            showActivityViewController()
        } catch {
            showAlert(title: "압축을 실패했습니다")
        }
        
        //ActivityViewController -> 외부 공유하기 위해서 띄움 성공했을 때만 띄워줌
        
        
    }
    
    //activity 아이템 이미지나 텍스트 우리는 압축 파일을 보내주어야한다 위에 있는 url 가져와야함
    //압축 파일 경로를 아이템 부분에 넣어주자
    func showActivityViewController() {
        
        //도큐먼트 위치 확인하고 -> 압축 파일 확인하고 -> 백업 파일 url // 중복되는 코드 있어서 매개변수 활용해서 줄여주자
        guard let path = documentDirectoryPath() else {
            showAlert(title: "도큐먼트 위치에 오류가 있습니다")
            return
        }
        
        //계속 같은 경로로 받기 떄문에 시간별로 네이밍을 하도록 하면 계속 같은 파일로 복구되는 것은 막을 수 있다
        let backupFileURL = path.appendingPathComponent("SeSACDiary_1.zip")
        
       let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
    @objc func restoreButtonClicked() {
        
        //도큐먼트에서 복사해올건가 -> true 아카이브 형식만 가져온다 도큐먼트 픽커에서 가져올지를 물어봄 가지고 올때 날아가버리면 원하는 형태가 아닐 수 있음
        //파일 원래 형태 유지
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        //여러개 허용?
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
        
    }
    
    
}

extension BackUpViewController: UIDocumentPickerDelegate {
    //유저가 취소 버튼 눌렀을 때
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    //선택시 문서 가져옴
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        //url 배열의 첫번째 요소 가져옴 경로를 알 수 있다 얼럿을 띄운 이유 선택을 함과 동시에 경로를 가져와야하는데 파일앱에서 유저가 파일을 지우거나 파일에 문제가 생겼을 경우
        //선택한 파일 앱을 보니까 마지막 경로의 정보와 도큐먼트 정보를 합쳐서 경로를 지정해준다
        guard let selectedFileURL = urls.first else {
            showAlert(title: "선택하신 파일을 찾을 수 없습니다")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            showAlert(title: "도큐먼트 위치에 오류가 있습니다")
            return
        }
        
        //아직 파일은 들어오지 않고 경로만 명시되어 있음
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        //원래 파일앱에 있던 데이터가 있을거다 파일을 선택하는 순간 앱에 도큐먼트 영역에 zip 파일을 옯겨주어야함
        // 파일 있나 -> 파일 저장을 위한 경로 확인
        // 이미 압축 파일이 있는 경우 기존의 경로를 통해서 압축 풀어줌 -> 파일의 존재 여부 확인 해주어야 한다
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            //파일에 대한 경로 가져오기 샌드박스 Url 가져와도 상관 없다 url이 있는 것이 확실히 알기 때문에
            //폴더 생성, 폴더 안에 파일을 어떻게 저장할 수 있을까
            
            let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
            
            do {
                //어떤 경로? / 압축 푸는 위치/  압축을 풀고 나면 거기에 있는 파일들이 나옴 덮어씌워 줄거냐 / 비밀번호 설정 할거임? / 프로그래스: 몇%풀렸는지 알려줌 다 풀리면 뭐해줄거야? 얼럿 띄우기
                //파일 경로 확실해서 , 도큐먼트 위치(도큐먼트 안), 덮어씌우는게 편함, 앱상에서는 비밀번호 건. 적 거의 없음 / 프로그래스는 로딩뷰를 채워줄 수 있는 뷰를 보여줄 수 있음 /
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlert(title: "복구가 완료되었습니다")
                })
                
            } catch {
                showAlert(title: "압축 해제에 실패했습니다")
            }
            
        } else {
            
            //파일 앱의 데이터를 이동 시켜주어야한다
            do {
                //파일 앱의 zip -> 도큐먼트 폴더에 복사
                //처음 선택 url , 도큐먼트 저장 위치
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("SeSACDiary_1.zip")
                
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlert(title: "복구가 완료되었습니다")
                })
                
                
                
            } catch {
                showAlert(title: "압축 해제에 실패했습니다.")
            }
 
        }
        
        
    }
}
