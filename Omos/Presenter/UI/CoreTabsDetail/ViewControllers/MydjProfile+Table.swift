//
//  MydjProfile + Table.swift
//  Omos
//
//  Created by sangheon on 2022/02/27.
//

import Foundation
import KakaoSDKUser
import UIKit

extension MydjProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentUserRecrods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRecordTableCell.identifier, for: indexPath) as! MyRecordTableCell
        let cellData = viewModel.currentUserRecrods[indexPath.row]
        cell.configureUserRecordModel(record: cellData)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height / 5
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MydjProfileHeader.identifier) as! MydjProfileHeader
        guard let headerData = viewModel.currentMydjProfile else { return UITableViewHeaderFooterView() }
        header.configureModel(profile: headerData)
        header.followButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                if header.followButton.layer.borderWidth == 0 {
                    self?.viewModel.saveFollow(fromId: self?.fromId ?? 0, toId: self?.toId ?? 0)
                    header.followButton.layer.borderWidth = 1
                    header.followButton.backgroundColor = .clear
                    header.followButton.setTitleColor(UIColor.mainGrey4, for: .normal )
                    header.followButton.setTitle("팔로잉", for: .normal)
                } else {
                    self?.viewModel.deleteFollow(fromId: self?.fromId ?? 0, toId: self?.toId ?? 0)
                    header.followButton.layer.borderWidth = 0
                    header.followButton.backgroundColor = .mainOrange
                    header.followButton.setTitleColor(UIColor.white, for: .normal )
                    header.followButton.setTitle("팔로우", for: .normal)
                }
            }).disposed(by: header.disposeBag)
        header.followButton.isHidden = (fromId == toId)
        header.settingButton.isHidden = true
        return header
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constant.mainHeight * 0.17
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.mainBlack
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let record = viewModel.currentUserRecrods[safe:indexPath.row] else { return }

        if Account.currentUser == toId {
            let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
            let uc = RecordsUseCase(recordsRepository: rp)
            let vm = MyRecordDetailViewModel(usecase: uc)
            let vc = MyRecordDetailViewController(posetId: record.recordID, viewModel: vm)
            vc.selfView.nicknameLabel.isHidden = true
            vc.selflongView.myView.nicknameLabel.isHidden = true
            vc.selfLyricsView.nicknameLabel.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
            let uc = RecordsUseCase(recordsRepository: rp)
            let vm = AllRecordDetailViewModel(usecase: uc)
            let vc = AllRecordDetailViewController(viewModel: vm, postId: record.recordID)
            vc.selfLongView.nicknameLabel.isHidden = true
            vc.selfShortView.nicknameLabel.isHidden = true
            vc.selfLyricsView.nicknameLabel.isHidden = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
