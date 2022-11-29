//
//  TableViewCell.swift
//  Api2
//
//  Created by Даша Волошина on 28.11.22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var viewImage = UIImageView()
    var label = UILabel()
    
    static let id = "TableViewCell"
//    static let nib = UINib(nibName: id, bundle: nil)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(viewImage)
        contentView.addSubview(label)
       createconstraints()
        
        viewImage.contentMode = .scaleAspectFill
        label.text = "Hi"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      
        
    }
    func createconstraints () {
        viewImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().inset(20)
            make.left.equalToSuperview()
        }
        
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(10)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
    }

}
