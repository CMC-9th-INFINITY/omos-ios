//
//  AllRecordView.swift
//  Omos
//
//  Created by sangheon on 2022/02/06.
//

import UIKit
import SnapKit
import RxSwift

class AllRecordView:BaseView {
    let emptyView = EmptyView()
    
    
    let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(AllRecordTableCell.self, forCellReuseIdentifier: AllRecordTableCell.identifier)
        table.register(AllRecordHeaderView.self, forHeaderFooterViewReuseIdentifier: AllRecordHeaderView.identifier)
        table.showsVerticalScrollIndicator = false 
        return table
    }()
    
    
    //override 되었기 때문에 BaseView에서처럼 ViewdidLoad에 자동 실행
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


class AllRecordHeaderView:UITableViewHeaderFooterView {
    static let identifier = "headerView"
    let disposeBag = DisposeBag()
    
    let label:UILabel = {
        let label = UILabel()
        label.tintColor = .white
        label.text = "인생의 OST"
        return label
    }()
    
    let button:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "keyboard_arrow_left"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()

    }
    
    func configureUI() {
        self.addSubview(label)
        self.addSubview(button)
        
        label.snp.makeConstraints { make in
            make.left.bottom.top.equalToSuperview()
            make.right.equalToSuperview().offset(-100)
        }
        
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(24)
        }
    }
    
//    func binding() {
//        button.rx.tap
//            .subscribe(onNext: {_ in
//                print("click")
//            }).disposed(by: disposeBag)
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
