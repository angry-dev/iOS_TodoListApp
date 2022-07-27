//
//  ComentCell1.swift
//  TodoListApp
//
//  Created by 전혜성 on 2022/07/04.
//

import UIKit

class ComentCell: UITableViewCell {
    
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var comentLabel: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var statusBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.statusBackgroundView.layer.cornerRadius = self.statusBackgroundView.frame.height / 2
        cellBackgroundView.layer.cornerRadius = 10
    }
}
