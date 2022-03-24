
import UIKit
import SDWebImage

class TrackTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet private weak var trackTitleLabel: UILabel!
    @IBOutlet private weak var trackStartTimeLabel: UILabel!
    @IBOutlet private weak var trackEndTimeLabel: UILabel!
    @IBOutlet private weak var trackPlayPauseButton: UIButton!
    @IBOutlet weak var trackProgressView: UIProgressView!
    
    // MARK: - Properties
    
    static var identifier: String = "TrackTableViewCell"
    var playAudio: () -> Void = {}
    
    struct ViewData {
        var track: Track
    }
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Actions
    @IBAction func trackPlayPauseAction(_ sender: Any) {
        playAudio()
    }
    
    // MARK: - Helping Methods
    
    fileprivate func getMinutesAndSecodnsFrom(time: Int) -> (minutes: Int, seconds: Int) {
        let seconds = Int(time % 60)
        let minutes = Int(time / 60)
        return (minutes, seconds)
    }
    
    func configure(with viewData: ViewData) {
        let track = viewData.track
        trackTitleLabel.text = track.title
        
        let startTime = getMinutesAndSecodnsFrom(time: track.curretnPlayBackDuration ?? 0)
        let endTime = getMinutesAndSecodnsFrom(time: track.duration ?? 0)
        
        trackStartTimeLabel.text = "\(startTime.minutes):\(startTime.seconds)"
        trackEndTimeLabel.text = "\(endTime.minutes):\(endTime.seconds)"
        
        if track.isPlaying ?? false == true {
            trackPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            trackPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
}
