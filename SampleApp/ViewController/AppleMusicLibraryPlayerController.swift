//
//  AppleMusicLibraryPlayerController.swift
//  SampleApp
//
//  Created by ByungHak Jang on 2020/12/13.
//

import UIKit
import MediaPlayer
import AVFoundation

class AppleMusicLibraryPlayerController: UIViewController, MPMediaPickerControllerDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet var viewMain: UIView!
    
    @IBOutlet var lblTitle: UILabel!        //곡 제목
    @IBOutlet var lblArtist: UILabel!       //곡 아티스트
    @IBOutlet var lblRestTime: UILabel!
    @IBOutlet var btnPlayPause: UIButton!   //실행/중지 버튼.
    @IBOutlet var btnBackWard: UIButton!    //이전곡 버튼
    @IBOutlet var btnForward: UIButton!     //다음곡 버튼
    @IBOutlet var sldProgress: UISlider!    //곡 진행상태바.
    
    //플레이어 인스턴스.
    let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    //선택된 한 곡에대한 Item 변수.
    var nowPlayItem : MPMediaItem!
    
    //타이머 변수. Instance를 할달할 때 마다 타이머가 진행됨.
    var progressTimer:Timer!
    //타이머의 콜백함수(Selector) 지정
    let timePlayerSelector:Selector = #selector(AppleMusicLibraryPlayerController.updatePlayTime)
    
    //음악 전체 길이.
    var gDuration:TimeInterval! = 0
    
    //슬라이더 터치중인지 여부.
    var gTouchDownSlider = false
    
    var imgBtnPlayBg = UIImage(systemName: "play.circle")
    var imgBtnPauseBg = UIImage(systemName: "pause.circle")
    
    override func viewDidLoad() {
        lblTitle.text = ""
        lblArtist.text = ""
        sldProgress.maximumValue = 1.0
        sldProgress.value = 0.0
        sldProgress.isEnabled = false
        lblRestTime.text = "00:00:00"
        btnPlayPause.setBackgroundImage(imgBtnPlayBg, for: UIControl.State.normal)
    }
    
    //Media Picker 띄우기.
    @IBAction func btnShowMusicPicker(_ sender: UIButton) {
        let controller = MPMediaPickerController(mediaTypes: .music)
        controller.allowsPickingMultipleItems = false
        controller.popoverPresentationController?.sourceView = sender
        controller.delegate = self
        present(controller, animated: true)
    }
    
    //Picker에서 음악을 선택했을 경우.
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        //Picker 닫기.
        mediaPicker.dismiss(animated: true)
        
        //재생관련 세팅
        sldProgress.isEnabled = true
        nowPlayItem = mediaItemCollection.items[0]
        gDuration = nowPlayItem.playbackDuration
        lblTitle.text = nowPlayItem.title
        lblArtist.text = nowPlayItem.artist
        

        // Add a playback queue containing all songs on the device.
        musicPlayer.setQueue(with: mediaItemCollection)
        
        musicPlayer.repeatMode = MPMusicRepeatMode.one
        // Start playing from the beginning of the queue.
        musicPlayer.prepareToPlay()
        // Music Play
        setMusicPlay(true)
        
        //타이머 시작.
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    
    //타이머 진행시 콜백함수(Selector)
    @objc func updatePlayTime() {
        //슬라이더를 터치한 상태가 아닐 경우에만 상태바를 업데이트.
        if !gTouchDownSlider {
            sldProgress.value = Float(musicPlayer.currentPlaybackTime / gDuration)
            lblRestTime.text = "-" + convertTime(time: gDuration - musicPlayer.currentPlaybackTime)
//            if musicPlayer.currentPlaybackTime == gDuration {
//                musicPlayer.stop()
//                musicPlayer.currentPlaybackTime = TimeInterval(0)
//                sldProgress.value = 0
//                lblRestTime.text = "-" + convertTime(time: gDuration)
//            }
        }
    }
    
    //시간 문자열로 전환.(00:00:00 형태)
    func convertTime(time:TimeInterval) -> String {
        let sec  = Int(time.truncatingRemainder(dividingBy: 60))
        let min  = Int(time / 60)
        let hour = Int(min / 60)
        return String(format: "%02d:%02d:%02d", hour, min, sec)
    }
    
    //재생/정지 버튼 클릭 시
    //Touch Up Inside
    @IBAction func btnPlayAndPause(_ sender: UIButton) {
        //if let item = nowPlayItem {
        //}
        if musicPlayer.playbackState == MPMusicPlaybackState.playing {
            setMusicPlay(false)
        }
        else {
            setMusicPlay(true)
        }
    }
    
    //뒤로감기 클릭 시
    //Touch Up Inside
    @IBAction func btnBackward(_ sender: UIButton) {
        //3초 이내 터치시 이전 곡. 3초 이후 터치 시 처음으로.
        musicPlayer.currentPlaybackTime = TimeInterval(0)
    }
    
    //앞으로감기 클릭 시
    //Touch Up Inside
    @IBAction func btnForward(_ sender: UIButton) {
        //아직....
    }
    
    //슬라이더를 터치했을 때
    @IBAction func btnTouchDown(_ sender: UISlider) {
        gTouchDownSlider = true
    }
    
    //슬라이더를 드래그한 뒤 Touch Up을 했을 때
    @IBAction func sldTouchUpInside(_ sender: UISlider) {
        musicPlayer.currentPlaybackTime = TimeInterval(sldProgress.value) * gDuration
        gTouchDownSlider = false
    }
    
    //슬라이더를 드래그한 뒤 일정역역 바깥(아래, 위)에서 Touch Up을 했을 때
    @IBAction func sldTouchUpOutside(_ sender: UISlider) {
        musicPlayer.currentPlaybackTime = TimeInterval(sldProgress.value) * gDuration
        gTouchDownSlider = false
    }
    
    //음악을 재생할지 말지 세팅.
    func setMusicPlay(_ play:Bool)  {
        //재생하도록 세팅.
        if play{
            musicPlayer.play()
            btnPlayPause.setBackgroundImage(imgBtnPauseBg, for: UIControl.State.normal)
        }
        //멈추도록 세팅.
        else{
            musicPlayer.pause()
            btnPlayPause.setBackgroundImage(imgBtnPlayBg, for: UIControl.State.normal)
        }
    }
    
}
