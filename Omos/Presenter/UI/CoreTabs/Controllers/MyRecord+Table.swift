//
//  MyRecord + Table.swift
//  Omos
//
//  Created by sangheon on 2022/02/15.
//

import UIKit

extension MyRecordViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myRecord.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyRecordTableCell.identifier, for: indexPath) as! MyRecordTableCell
        let data = myRecord[indexPath.row]
        cell.configureModel(record: data)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UIScreen.main.bounds.height / 5
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let data = myRecord[indexPath.row]
        let rp = RecordsRepositoryImpl(recordAPI: RecordAPI())
        let uc = RecordsUseCase(recordsRepository: rp)
        let vm = MyRecordDetailViewModel(usecase: uc)
        let vc = MyRecordDetailViewController(posetId: data.recordID, viewModel: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }
}
