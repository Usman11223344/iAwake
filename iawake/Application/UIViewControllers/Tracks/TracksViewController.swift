
import UIKit
import AVKit
import AVFoundation


// MARK: - Tracks Display Protocol
protocol TracksDisplayLogic: AnyObject {
    func displayTracks(viewData: TracksViewController.ProgramTracks.ViewData)
    func displayError(errorString: String)
}

// MARK: - TracksViewController
class TracksViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib.init(nibName: "TrackTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: TrackTableViewCell.identifier)
        }
    }
    
    // MARK: - Properties
    var interactor: TracksInteractorProtocol?
    var router: TracksRouter?
    var viewData: ProgramTracks.ViewData?
    var audioPlayer: AVPlayer?
    var playingSelectedIndex: Int?
    
    // MARK: - Models
    enum ProgramTracks {
        
        struct ViewData {
//            let header: Header
            var section: Section
        }

        struct Header {
            let userName: String
            let avatarUrl: String
        }

        struct Section {
            
            var rows: [Row]
            
            var count: Int {
                return rows.count
            }
            
            subscript(_ index: Int) -> Row {
                return rows[index]
            }
        }
        
        struct Row {
            var trackCellData: TrackTableViewCell.ViewData
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        configureAudioPlayer()
        getProgramTracks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer?.pause()
    }
    
    // MARK: - Helping Methods
    private func setUpNavigationBar() {
        
        // Setting title, title text color and font of navigation bar
        self.title = "Tracks"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedString.Key.foregroundColor: UIColor.black.cgColor]
        
        // Settings tint color of navigation bar
        self.navigationController?.navigationBar.tintColor = .black
        
        // remove text from back button of navigation bar
        self.navigationController?.navigationBar.topItem?.title = " "
        
    }
    
    private func set(view: ProgramTracks.ViewData) {
        self.viewData = view
    }
    
    private func getProgramTracks() {
        self.interactor?.getTracks()
    }
    
    private func configureAudioPlayer() {
        audioPlayer = AVPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didfinishplaying(note:)),name:NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: audioPlayer?.currentItem)
        audioPlayer?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 2), queue: DispatchQueue.main) {[weak self] (progressTime) in
            guard let `self` = self else { return }
            let time = Int(CMTimeGetSeconds(progressTime))
            print("Video playing \(time)")
            self.setCurrentPlayBack(time: time)
        }
    }
    
    fileprivate func reloadRowAt(_ previousIndex: Int) {
        let indexPath = IndexPath(row: previousIndex, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func checkAudioIsAlreadyPlayingAt(index: Int) {
        guard let previousIndex = playingSelectedIndex, let _viewData = viewData, previousIndex < _viewData.section.rows.count  else { return }
        viewData?.section.rows[previousIndex].trackCellData.track.curretnPlayBackDuration = 0
        viewData?.section.rows[previousIndex].trackCellData.track.isPlaying = false
        audioPlayer?.pause()
        reloadRowAt(previousIndex)
    }
    
    func playAudio(track: Track, at index: Int) {
        
        guard let media = track.media, let mp3 = media.mp3, let audioUrl = mp3.url, let url = URL(string: audioUrl)  else { return }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer?.replaceCurrentItem(with: playerItem)
        audioPlayer?.play()
        viewData?.section.rows[index].trackCellData.track.isPlaying = true
        playingSelectedIndex = index
        reloadRowAt(index)
    }
    
    func setCurrentPlayBack(time: Int) {
        guard let index = playingSelectedIndex, let _viewData = viewData, index < _viewData.section.rows.count  else { return }
        viewData?.section.rows[index].trackCellData.track.curretnPlayBackDuration = time
        if viewData?.section.rows[index].trackCellData.track.isPlaying ?? false {
            reloadRowAt(index)
        }
    }
    
    // MARK: - Actions
    @objc func didfinishplaying(note : NSNotification) {
        guard let index = playingSelectedIndex, let _viewData = viewData, index < _viewData.section.rows.count  else { return }
        viewData?.section.rows[index].trackCellData.track.isPlaying = false
        viewData?.section.rows[index].trackCellData.track.curretnPlayBackDuration = 0
        reloadRowAt(index)
    }

}

// MARK: - TracksDisplayLogic
extension TracksViewController: TracksDisplayLogic {
    func displayTracks(viewData: TracksViewController.ProgramTracks.ViewData) {
        self.set(view: viewData)
        self.tableView.reloadData()
    }
    func displayError(errorString: String) {
        self.showToast(message: errorString)
    }
}

// MARK: - UITableViewDelegate
extension TracksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

// MARK: - UITableViewDataSource
extension TracksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewData?.section.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let _viewData = viewData, indexPath.row < _viewData.section.rows.count  else { return UITableViewCell() }

        let section = _viewData.section
        let row = section.rows[indexPath.row]

        let cell: TrackTableViewCell = tableView.dequeueReusableCell(withIdentifier: TrackTableViewCell.identifier, for: indexPath) as! TrackTableViewCell
        cell.configure(with: row.trackCellData)
        cell.playAudio = { [unowned self] in
            
            let track = row.trackCellData.track
            self.checkAudioIsAlreadyPlayingAt(index: indexPath.row)
            if self.playingSelectedIndex ?? -1 != indexPath.row {
                self.playAudio(track: track, at: indexPath.row)
            } else {
                self.playingSelectedIndex = nil
            }
        }
        return cell
    }
    
}
