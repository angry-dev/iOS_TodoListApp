//
//  TodoCell.swift
//  TodoListApp
//
//  Created by 전혜성 on 2022/07/14.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var pullDown: UIButton!
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var checkImageButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let ok = UIAction(title: "수정",  handler: { _ in
            NotificationCenter.default.post(name: Notification.Name("updateTodo"), object: self.todoLabel.text)
        })
        let cancel = UIAction(title: "삭제", attributes: .destructive, handler: { _ in
            NotificationCenter.default.post(name: Notification.Name("deleteTodo"), object: self.todoLabel.text)
        })
        
        let buttonMenu = UIMenu(title: "관리", children: [ok, cancel])
        self.pullDown.menu = buttonMenu
        
        self.cellBackgroundView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.checkImageButton.setImage(UIImage(named: "check"), for: .normal)
        } else {
            self.checkImageButton.setImage(UIImage(named: "noncheck"), for: .normal)
        }
    }
    @IBAction func checkImage(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "noncheck") {
            sender.setImage(UIImage(named: "check"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "noncheck"), for: .normal)
        }
        
    }
}
