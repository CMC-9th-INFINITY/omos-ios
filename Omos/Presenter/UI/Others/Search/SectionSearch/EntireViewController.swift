//
//  entireViewController.swift
//  Omos
//
//  Created by sangheon on 2022/02/27.
//

import UIKit

class EntireViewController:BaseViewController {
    
    let selfView = EntireView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfView.tableView.delegate = self
        selfView.tableView.dataSource = self
    }
    
    
    override func configureUI() {
        super.configureUI()
        self.view.addSubview(selfView)
        
        selfView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
        }
        
    }
    
    
}

extension EntireViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //모델에 따라 여기서 분리
       return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SongTableCell.identifier, for: indexPath) as! SongTableCell
            cell.selectionStyle = . none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableCell.identifier, for: indexPath) as! AlbumTableCell
            cell.selectionStyle = . none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier:  ArtistTableCell.identifier, for: indexPath) as! ArtistTableCell
            cell.selectionStyle = . none
            return cell
        default:
            print("de other")
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return Constant.mainHeight * 0.094
        case 1:
            return Constant.mainHeight * 0.108
        case 2:
            return Constant.mainHeight * 0.094
        default:
            print("de other")
        }
        return Constant.mainHeight * 0.094
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllRecordHeaderView.identifier) as! AllRecordHeaderView
        headerView.button.setImage(nil, for: .normal)
        headerView.button.setTitle("더보기", for: .normal)
        headerView.button.setTitleColor(.mainGrey3, for: .normal)
        headerView.button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        headerView.button.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                print("click is here ")
            }).disposed(by: headerView.disposeBag)
        switch section {
        case 0:
            headerView.label.text = "노래"
        case 1:
            headerView.label.text = "앨범"
        case 2:
            headerView.label.text = "아티스트"
        default:
            print("you need to add section case")
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.mainBackGround
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 17
    }
    
    
}