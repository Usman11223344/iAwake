
import UIKit
import SDWebImage

class FreeProgramTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var programAvatarImageView: UIImageView!
    
    // MARK: - Properties
    
    static var identifier: String = "FreeProgramTableViewCell"
    
    struct ViewData {
        let program: Program
    }

    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Helping Methods
    func configure(with viewData: ViewData) {
        let program = viewData.program
        titleLabel.text = program.title
        guard let cover = program.cover, let resolution = cover.resolutions, let last = resolution.last else { return }
        programAvatarImageView.sd_setImage(with: URL(string: last.url ?? "")) { image, error, type, url in
            
        }
    }
    
}
