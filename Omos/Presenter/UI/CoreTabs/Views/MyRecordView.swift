//
//  MyRecordView.swift
//  Omos
//
//  Created by sangheon on 2022/02/15.
//

import UIKit
//import SnapKit

class MyRecordView:BaseView {
    
    let emptyView = EmptyView()
    
    let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(AllRecordTableCell.self, forCellReuseIdentifier: AllRecordTableCell.identifier)
        table.backgroundColor = .mainBlack
        table.showsVerticalScrollIndicator = false
        table.automaticallyAdjustsScrollIndicatorInsets = false
        //table.contentInsetAdjustmentBehavior = .never
        //table.insetsContentViewsToSafeArea = false
        return table
    }()
    
    override func configureUI() {
        
        self.addSubview(emptyView)
        self.addSubview(tableView)
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        emptyView.isHidden = true
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
