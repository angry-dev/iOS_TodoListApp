//
//  CalendarViewController.swift
//  TodoListApp
//
//  Created by 전혜성 on 2022/07/11.
//

import UIKit
import FSCalendar
import Foundation

class CalendarViewController: UIViewController {
    
    
    @IBOutlet weak var fscalendarView: FSCalendar!
    var day: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fscalendarView.dataSource = self
        self.fscalendarView.delegate = self
        configureFSCalendarView()
    }
    
    func configureFSCalendarView() {
        fscalendarView.layer.cornerRadius = 15
        fscalendarView.locale = Locale(identifier: "ko_kr")
        fscalendarView.appearance.headerDateFormat = "yyyy년 M월"
        fscalendarView.appearance.headerTitleColor = UIColor.black
        fscalendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        fscalendarView.appearance.weekdayTextColor = UIColor.black
        fscalendarView.headerHeight = 55
    }
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
     func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 날짜 변환 포맷
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "yyyy년 M월 dd일(EEEEE)"
        let finalDate = formatter.string(from: date)
        self.day = finalDate
        // 선택한 날짜가 해당 달 안에 존재하지 않는 경우
        if monthPosition != FSCalendarMonthPosition(rawValue: 1) {
            calendar.select(date, scrollToDate: true)
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("selectDate"), object: finalDate)
            dismiss(animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return true
    }
}



