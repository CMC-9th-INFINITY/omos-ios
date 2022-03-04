//
//  ArtistViewController.swift
//  Omos
//
//  Created by sangheon on 2022/02/27.


import UIKit

class ArtistViewController:BaseViewController {
    
    let selfView = ArtistView()
    
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

extension ArtistViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistTableCell.identifier, for: indexPath) as! ArtistTableCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.mainHeight * 0.094
    }
    
    
}