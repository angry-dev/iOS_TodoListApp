//
//  MainViewController.swift
//  TodoListApp
//
//  Created by 전혜성 on 2022/07/04.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateButton: UIButton!
    
    var coment = [Coment]()
    var todo = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteTodo(notification:)), name: Notification.Name("deleteTodo"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTodo(notidication:)), name: Notification.Name("updateTodo"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectDate(notification:)), name: NSNotification.Name("selectDate"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addTodo(notification:)), name: Notification.Name("addTodo"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(doneComent(notification:)), name: Notification.Name("doneComent"), object: nil)

        self.initData()
        self.configureTableview()
            
    }
    
    func configureTableview() {
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: "ComentCell", bundle: nil), forCellReuseIdentifier: "ComentCell")
        self.tableView.register(UINib(nibName: "TodoHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "TodoHeaderCell")
        self.tableView.register(UINib(nibName: "ComentHeaderCell", bundle: nil), forHeaderFooterViewReuseIdentifier: "ComentHeaderCell")
        self.tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        self.tableView.sectionHeaderTopPadding = 0 // 섹션간 간격
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemGray6
    }
    
    func initData() {
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.dateFormat = "yyyy년 M월 dd일(EEEEE)"
        let currentDate = date.string(from: Date())
        self.dateButton.setTitle(currentDate, for: .normal)
        
        let realm = try! Realm()
        let data1 = Array(realm.objects(Coment.self)).filter{$0.date == currentDate}
        self.coment = Array(data1)
        if coment.isEmpty {
            let coment = Coment()
            coment.date = currentDate
            coment.status = ""
            coment.coment = "오늘의 코멘트를 입력하세요."
            self.coment.append(coment)
        }
        
        let todoData = Array(realm.objects(Todo.self)).filter{$0.date == currentDate}
        self.todo = Array(todoData)
        
        print(self.dateButton.currentTitle ?? "aaa")
        print(data1)
        print(coment)
        self.tableView.reloadData()
    }
    
    @objc func selectDate(notification: NSNotification) {
        let data = notification.object as? String ?? ""
        self.dateButton.setTitle(data, for: .normal)
        
        let realm = try! Realm()
        let Datedata = Array(realm.objects(Coment.self)).filter{$0.date == data}
        self.coment = Array(Datedata)
        // 코멘트 배열이 비어있을경우 초기화
        if coment.isEmpty {
            let coment = Coment()
            coment.date = self.dateButton.currentTitle ?? ""
            coment.status = ""
            coment.coment = "오늘의 코멘트를 입력하세요."
            self.coment.append(coment)
        }
        // 선택한 날짜의 할일들 가져오기
        let todoData = Array(realm.objects(Todo.self)).filter{$0.date == data}
        self.todo = Array(todoData)
        self.tableView.reloadData()
    }
    
    @objc func doneComent(notification: Notification) {
        guard let data = notification.object as? [String] else { return }
        let coment = Coment()
        coment.date = self.dateButton.currentTitle ?? ""
        coment.status = data.first ?? ""
        coment.coment = data.last ?? ""
        self.coment = [coment]
        
        
        let realm = try! Realm()
        let loadData = Array(realm.objects(Coment.self)).filter{ $0.date == self.dateButton.currentTitle ?? "" }
        if loadData.first?.date == self.dateButton.currentTitle {
            try! realm.write{
                loadData.first?.status = data.first ?? ""
                loadData.first?.coment = data.last ?? ""
            }
        } else {
            try! realm.write{
                realm.add(coment)
            }
        }
        self.tableView.reloadData()
    }
    
    @objc func addTodo(notification: Notification) {
        let realm = try! Realm()
        guard let data = notification.object as? [String] else { return }
        let update = (realm.objects(Todo.self)).filter{ $0.todo == data.last }
        if update.first?.todo == data.last {
            try! realm.write {
                update.first?.todo = data.first ?? ""
            }
        } else {
            
            let todo = Todo()
            todo.date = self.dateButton.currentTitle ?? ""
            todo.todo = data.first ?? ""
            self.todo.append(todo)
            
            try! realm.write {
                realm.add(todo)
            }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func deleteTodo(notification: Notification) {
        guard let data = notification.object as? String else { return }
        let realm = try! Realm()
        // 선택된 할일의 텍스트를 기준으로 데이터 삭제
        let todoText = Array(realm.objects(Todo.self)).filter{ $0.todo == data }
        try! realm.write {
            realm.delete(todoText)
        }
        // 현재 날짜에 맞는 데이터 가져오기
        let todoData = Array(realm.objects(Todo.self)).filter{$0.date == self.dateButton.currentTitle}
        self.todo = Array(todoData)
        self.tableView.reloadData()
        
    }
    
    @objc func updateTodo(notidication: Notification) {
        guard let data = notidication.object as? String else { return }
        // 선택된 할일의 텍스트를 InputViewController에 보내기
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "InputTodoViewController") as? InputTodoViewController else { return }
        vc.sendText = data
        present(vc, animated: true)
    }
    
    
    @IBAction func tapDateButton(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else { return }
        self.present(vc, animated: true)
    }
}


extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.todo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let comentCell = self.tableView.dequeueReusableCell(withIdentifier: "ComentCell") as? ComentCell else { return UITableViewCell() }
            comentCell.selectionStyle = .none // 셀 선택시 회색 하이라이트 제거
            let data = self.coment[indexPath.row]
            comentCell.status.text = data.status
            comentCell.comentLabel.text = data.coment
            if comentCell.comentLabel.text != "오늘의 코멘트를 입력하세요." {
            comentCell.comentLabel.textColor = .black
            } else {
                comentCell.comentLabel.textColor = .gray
            }
            
            return comentCell
        default:
            guard let todoCell = self.tableView.dequeueReusableCell(withIdentifier: "TodoCell") as? TodoCell else { return UITableViewCell() }
            
            let data = self.todo[indexPath.row]
            todoCell.todoLabel.text = data.todo
            return todoCell
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ComentHeaderCell") as? ComentHeaderCell else { return UITableViewCell() }
            return cell
        default:
            guard let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TodoHeaderCell") as? TodoHeaderCell else { return UITableViewCell() }
            
            cell.addTodoButton.addTarget(self, action: #selector(tapAddTodoButton), for: .touchUpInside)
            return cell
            
        }
        
    }
    
    @objc func tapAddTodoButton() {
        print("tap")
        guard let inputTodoVC = self.storyboard?.instantiateViewController(withIdentifier: "InputTodoViewController") as? InputTodoViewController else { return }
        
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        self.navigationController?.modalTransitionStyle = .crossDissolve
        self.navigationController?.present(inputTodoVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            
            guard let writeComentVC = self.storyboard?.instantiateViewController(withIdentifier: "writeComentVC")
                    as? WriteComentViewController else { return }
            
            self.present(writeComentVC, animated: true)
        } else {
            
    }
    
}




}
