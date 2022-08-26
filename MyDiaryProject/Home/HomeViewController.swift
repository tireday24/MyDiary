//
//  HomeViewController.swift
//  MyDiaryProject
//
//  Created by 권민서 on 2022/08/22.


import UIKit
import SnapKit
import RealmSwift //Realm1. import
import FSCalendar

class HomeViewController: BaseViewController {
    
    //let localRealm = try! Realm() // Realm 2.
    let repository = UserDiaryRepository() //0826 코드 줄이기 1.
    
    lazy var calendar: FSCalendar = {
        let view = FSCalendar()
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        return view
    }()
    
    let formatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyMMdd"
        return formatter
    }()
    
    var tasks: Results<UserDiary>! {
        didSet {
            //화면 갱신은 화면 전환 코드 및 생명 주기 실행 점검 필요!
            //present, overCurrentContext, overFullScreen > viewWillAppear X
            tableView.reloadData()
            print("Tasks Changed")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        
        fetchDocumentZipFile()
         
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        
        //Realm 3. Realm 데이터를 정렬해 tasks 에 담기
        fetchRealm()
        
    }
    
    func fetchRealm() {
        tasks = repository.fetch() //코드 줄이기 위의 인스턴스에서 가져옴 2.
    }
    
    override func configure() {
        view.addSubview(tableView)
        view.addSubview(calendar)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]

    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            make.topMargin.equalTo(300)
        }
        
        calendar.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(300)
        }
    }
    
    @objc func backupButtonClicked() {
        let vc = BackUpViewController()
        transition(vc, trasionStyle: .push)
    }
    
    @objc func plusButtonClicked() {
        let vc = MainViewController()
        transition(vc, trasionStyle: .presentFullScreen)
    }
    
    @objc func sortButtonClicked() {
        //등록일 기준으로 정렬 방식 바꾸겠다
        tasks = repository.fetchSort("regdate") //코드 줄이기 2.
        //변화 할때마다 테이블 뷰 갱신
        tableView.reloadData() //정렬, 필터, 즐겨찾기
    }
    
    //realm filter query, NSPredicate
    //realm의 규칙에 맞춰서 해야한다 ''안에 들어가야 한다
    @objc func filterButtonClicked() {
        //대문자 A는 안찾아줌 CONTAINS[c] 이런 방식으로 사용
        tasks = repository.fetchFilter() // 코드 줄이기 2.
        //.filter("diaryTitle = '가오늘의 일기117'")
    }
    
   
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? HomeTableViewCell else { return UITableViewCell() }
        cell.setData(data: tasks[indexPath.row])
        cell.diaryImageView.image = loadImageFromDocument(fileName: "\(tasks[indexPath.row].objectId).jpg")
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favorite = UIContextualAction(style: .normal, title: "즐겨찾기") { action, view, complitionHandler in
            
            
            //try! self.localRealm.write{
                //하나의 레코드에서 특정 컬럼 하나만 변경
                //self.tasks[indexPath.row].favorite = !self.tasks[indexPath.row].favorite
               //print("Realm Update Succeed, reloadRows 필요")
                
                //하나의 테이블에 특정 컬럼 전체를 변경
                //self.tasks.setValue(true, forKey: "favorite")
                
                //하나의 레코드에서 여러 컬럼들이 변경
                //어떤 테이블에 누구를 바꿀거냐
                //.all도 모든 것을 바꿀 수 있음
                //self.localRealm.create(UserDiary.self, value: ["objectId": self.tasks[indexPath.row].objectId, "diaryContent": "변경테스트", "diaryTitle": "제목임"], update: .modified)
                
                //print("Realm Update Succeed, reloadRows 필요")
                
                
            self.repository.updateFavorite(item: self.tasks[indexPath.row]) //코드정리 3.
            self.fetchRealm()
            //1.스와이프한 셀 하나만 ReloadRows 구현 => 상대적 효율성
            //2.데이터가 변경됐으니 다시 realm에서 데이터를 가져오기 => didSet 일관적 형태로 갱신
       
        }
        
        let image = tasks[indexPath.row].favorite ? "star.fill" : "star"
        favorite.image = UIImage(systemName: image)
        favorite.backgroundColor = .systemPink
        
        return UISwipeActionsConfiguration(actions: [favorite])
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favorite = UIContextualAction(style: .normal, title: "삭제") { action, view, complitionHandler in
            
            //let task = self.tasks[indexPath.row] //저장이 되어 있기 때문에 이제는 시점 상관없이 오류가 나지 않는다
            
            //순서 중요 -> realm에서 삭제한 경우 이미 모든게 다 삭제 -> 테이블 갱신됨 -> indexPath가 삭제된 후에 이미지를 삭제하려면 IndexPath row에 값이 없다
            //self.removeImageFromDocument(fileName: "\(task.objectId).jpg")
            
            //사진 먼저 지우고 렘 지우면 문제가 안생겼던 이유
           // try! self.localRealm.write{
                //self.localRealm.delete(task) //여기서 다 삭제 됨
           // }
            self.repository.deleteItem(item: self.tasks[indexPath.row])
            self.fetchRealm() //단지 Realm에 저장된 데이터를 가지고 오는 역할
            
        }
        
        return UISwipeActionsConfiguration(actions: [favorite])
    }
}

//갱신 지정 저장된 날짜에 잘나오고 있는 건지 repository의 램의 레코드와 비교해서 봐야함
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    //이벤트에 대한 갯수
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return repository.fetchDate(date: date).count // 베열에 대한 갯수
    }
    
//    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
//        return "새싹"
//    }
    
//    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
//        return UIImage(systemName: "star.fill")
//    }

    //date: yyyyMMdd hh: mm: ss: => dateFormatter
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        //데이트 포멧터 구성과 똑같아야함
        return formatter.string(from: date) == "220907" ? "오프라인 모임" : nil
    }

    //날짜 선택 시, 데이터 100개 특정 날짜의 3개 날짜 필터를 기준으로 3개만 보여줌 
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasks = repository.fetchDate(date: date)
    }

}
