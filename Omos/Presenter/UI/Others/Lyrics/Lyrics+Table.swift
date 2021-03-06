//
//  Lyrics + Table.swift
//  Omos
//
//  Created by sangheon on 2022/03/14.
//

import Foundation
import UIKit

extension LyricsPasteCreateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == .modify {
            return viewModel.lyricsStringArray.count
        } else {
            return viewModel.lyricsStringArray.count * 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: LyriscTableCell.identifier, for: indexPath) as! LyriscTableCell
            if indexPath.row == 0 {
                cell.label.text = viewModel.lyricsStringArray[0]
            }
            if self.type == .modify {
                cell.label.text = viewModel.lyricsStringArray[indexPath.row]
            } else {
                cell.label.text = viewModel.lyricsStringArray[indexPath.row / 2]
            }

            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TextTableCell.identifier, for: indexPath) as! TextTableCell
            cell.textView.delegate = self
            if self.type == .modify {
                cell.textView.text = viewModel.lyricsStringArray[indexPath.row]
            }
            cell.selectionStyle = .none
            cell.layoutIfNeeded()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
