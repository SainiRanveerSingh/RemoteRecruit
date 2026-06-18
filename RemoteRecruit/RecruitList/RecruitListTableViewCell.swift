//
//  RecruitListTableViewCell.swift
//  RemoteRecruit
//
//  Created by RV on 18/06/26.
//

import UIKit

class RecruitListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewBackgroundMain: UIView!
    @IBOutlet weak var labelJobTitle: UILabel!
    @IBOutlet weak var labelCompanyName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelSalaryRange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        initialSetup()
    }

    func initialSetup() {
        viewBackgroundMain.clipsToBounds = true
        viewBackgroundMain.cornerRadius = 20.0
        viewBackgroundMain.isShadow = true
        viewBackgroundMain.borderColor = .lightGray
        viewBackgroundMain.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(indexPath: IndexPath, job: Job?) {
        guard let jobValue = job else { return }
        labelJobTitle.text = jobValue.title
        labelCompanyName.text = jobValue.company
        labelLocation.text =
        "\(jobValue.location?.city ?? ""), \(jobValue.location?.country ?? "")"
        labelSalaryRange.text = "\(jobValue.salary?.currency ?? "INR") \(jobValue.salary?.min ?? 0) to \(jobValue.salary?.max ?? 0)"
    }
    
}
