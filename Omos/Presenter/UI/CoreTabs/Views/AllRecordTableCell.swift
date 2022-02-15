//
//  AllRecoredTableCell.swift
//  Omos
//
//  Created by sangheon on 2022/02/07.
//

import Foundation
import UIKit

class AllRecordTableCell:UITableViewCell {
    static let identifier = "AllRecordTableCell"
    
    private var collectionView:UICollectionView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCollectionView()
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal//UIScreen.main.bounds.height / 4.72)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 1.22 , height: UIScreen.main.bounds.height / 4.74) //비율정해서 설정하기
        layout.minimumLineSpacing = 6
        layout.minimumInteritemSpacing = 6
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AllRecordCollectionCell.self, forCellWithReuseIdentifier: AllRecordCollectionCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        contentView.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension AllRecordTableCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllRecordCollectionCell.identifier, for: indexPath) as! AllRecordCollectionCell
        cell.backgroundColor = .black
        return cell
    }

}
