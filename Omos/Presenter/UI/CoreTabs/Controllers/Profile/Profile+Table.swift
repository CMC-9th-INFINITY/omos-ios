//
//  Profile + Table.swift
//  Omos
//
//  Created by sangheon on 2022/02/07.
//

import Foundation
import UIKit

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.selectionStyle = .none
        let recordData = viewModel.currentMyProfileRecord
        switch indexPath.section {
        case 1:
            cell.configureScrap(record: recordData)
            cell.selfViewOne.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let recordID = recordData.scrappedRecords[safe:0]?.recordID else { return }
                    let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                    let uc = RecordsUseCase(recordsRepository: rp)
                    let vm = AllRecordDetailViewModel(usecase: uc)
                    let vc = AllRecordDetailViewController(viewModel: vm, postId: recordID)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: cell.disposeBag)

            cell.selfViewTwo.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let recordID = recordData.scrappedRecords[safe:1]?.recordID else { return }
                    let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                    let uc = RecordsUseCase(recordsRepository: rp)
                    let vm = AllRecordDetailViewModel(usecase: uc)
                    let vc = AllRecordDetailViewController(viewModel: vm, postId: recordID)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: cell.disposeBag)
            return cell
        case 2:
            cell.configureLike(record: recordData)
            cell.selfViewOne.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let recordID = recordData.likedRecords[safe:0]?.recordID else { return }
                    let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                    let uc = RecordsUseCase(recordsRepository: rp)
                    let vm = AllRecordDetailViewModel(usecase: uc)
                    let vc = AllRecordDetailViewController(viewModel: vm, postId: recordID )
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: cell.disposeBag)

            cell.selfViewTwo.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { [weak self] _ in
                    guard let recordID = recordData.likedRecords[safe:1]?.recordID else { return }
                    let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
                    let uc = RecordsUseCase(recordsRepository: rp)
                    let vm = AllRecordDetailViewModel(usecase: uc)
                    let vc = AllRecordDetailViewController(viewModel: vm, postId: recordID)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: cell.disposeBag)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: MydjProfileHeader.identifier) as! MydjProfileHeader
            header.followButton.isHidden = true
            header.settingButton.isHidden = false
            guard let headerData = viewModel.currentMyProfile else { return header }
            header.configureMyProfile(profile: headerData)

            header.settingButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    let vc = SettingViewController(viewModel: self!.viewModel)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }).disposed(by: header.disposeBag)

            return header
        } else {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: AllRecordHeaderView.identifier) as! AllRecordHeaderView
            if section == 1 {
                header.label.text = "???????????? ?????????"
                if viewModel.currentMyProfileRecord.likedRecords.isEmpty {
                    header.button.isHidden = true
                } else {
                    header.button.isHidden = false
                }
                header.button.rx.tap
                    .subscribe(onNext: { [weak self] _ in
                        let vc = InteractionRecordViewController(viewModel: self!.viewModel, type: .scrap)
                        vc.title = header.label.text
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }).disposed(by: header.disposeBag)
            } else {
                header.label.text = "????????? ?????????"
                if viewModel.currentMyProfileRecord.scrappedRecords.isEmpty {
                    header.button.isHidden = true
               } else {
                   header.button.isHidden = false
               }
                header.button.rx.tap
                    .subscribe(onNext: { [weak self] _ in
                        let vc = InteractionRecordViewController(viewModel: self!.viewModel, type: .like)
                        vc.title = header.label.text
                        self?.navigationController?.pushViewController(vc, animated: true)
                    }).disposed(by: header.disposeBag)
            }

            header.button.setTitle("????????????", for: .normal)
            header.button.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
            header.button.setTitleColor(.mainGrey3, for: .normal)
            header.button.setImage(nil, for: .normal)

            return header
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return Constant.mainHeight * 0.17
        } else {
            return Constant.mainHeight * 0.06
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = UIColor.mainBlack
        } else {
            (view as? UITableViewHeaderFooterView)?.contentView.backgroundColor = UIColor.mainBackGround
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 || indexPath.section == 2 {
            return Constant.mainHeight * 0.235_3
        }

        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
