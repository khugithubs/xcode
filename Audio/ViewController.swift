//
//  ViewController.swift
//  Audio
//
//  Created by 김현욱 on 2022/06/05.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
// 오디오를 재생하려면 헤더 파일과 델리게이트가 필요하므로 AVFoundation을 불러오고, AVAudioPlayerDelegate 선언을 추가한다. 에러를 없애기 위해 AVAudioRecorderDelegate의 선언을 추가한다.
    var audioPlayer : AVAudioPlayer!
    // AVAudioPlayer 인스턴스 변수
    var audioFile : URL!
    // 재생할 오디오의 파일명 변수
    let MAX_VOLUME : Float = 10.0
    // 최대 볼륨, 실수형 상수
    var progressTimer : Timer!
    // 타이머를 위한 변수
    
    let timePlayerSelector:Selector = #selector(ViewController.updatePlayTime)
    // 재생 타이머를 위한 상수를 추가한다.
    let timeRecordSelector:Selector = #selector(ViewController.updateRecordTime)
    // 녹음 타이머를 위한 상수를 추가한다.
    @IBOutlet var pvProgressPlay: UIProgressView!
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var slVolume: UISlider!
    
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var lblRecordTime: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    // audioRecorder 인스턴스를 추가한다.
    var isRecordMode = false
    // 현재 녹음 모드라는 것을 나타낼 isRecordMode를 추가한다. 기본값은 false로 하여 처음 앱을 실행했을 때 '녹음 모드'가 아닌 '재생 모드'가 나타나게 한다.
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectAudioFile()
        if !isRecordMode {
        initPlay()
        // if문의 조건이 !isRecordMode이다. 이는 녹음 모드가 아니라면 이므로 재생모드를 말한다. 따라서 initPlay 함수를 호출한다.
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
            // 조건에 해당하는 것이 재생 모드이므로 Record 버튼과 재생 시간은 비활성화로 설정한다.
        }else {
            initRecord()
            // 조건에 해당하지 않는 경우, 이는 녹음 모드라면 이므로 initRecord 함수를 호출한다.
        }
    }
    func selectAudioFile() {
        if !isRecordMode {
            audioFile = Bundle.main.url(forResource: "Sicilian_Breeze", withExtension: "mp3")
            // audioFile은 재생할 때, 녹음 모드가 아닐 때 사용하므로 if문에 넣는다. 재생 모드일 때는 오디오 파일인 Sicilian_Breeze.mp3가 선택된다.
        } else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
            // 녹음 모드일 때는 새 파일인 recordFile.m4a가 생성된다.
        }
    }
    
    func initRecord() {
        // 녹음과 관련하여 오디오의 포맷, 음질, 비트율, 채널 및 샘플률을 초기화하기 위한 함수를 생성한다.
        let recordSettings = [
            AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey : 2,
            AVSampleRateKey : 44100.0] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings)
        } catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        
        audioRecorder.delegate = self
        // audioRecorder의 델리게이트를 설정하는데 AVAudioRecorderDelegate를 상속받지 않아 에러 발생
        slVolume.value = 1.0
        // AudioRecorder의 델리게이트를 self로 설정한다.
        audioPlayer.volume = slVolume.value
        // 볼륨 슬라이더 값을 1.0으로 설정한다.
        lblEndTime.text = convertNSTimeInterval2String(0)
        // audioPlayer의 볼륨도 슬라이더 값과 동일한 1.0으로 설정한다.
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        // 총 재생 시간을 0으로 바꾼다.
        setPlayButtons(false, pause: false, stop: false)
        // Play, Pause 및 Stop 버튼을 비활성화로 설정한다.
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print(" Error-setCategory : \(error)")
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print(" Error-setActive : \(error)")
        }
    }
    func initPlay() {
        // 재생 모드와 녹음 모드로 변경할 때에 대비해서 오디오 재생 초기화 과정과 녹음 초기화 과정을 분리해 놓아야 편리하다.
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        slVolume.maximumValue = MAX_VOLUME
        // 슬라이더의 최대 볼륨을 상수 MAX_VOLUME인 10.0으로 초기화한다.
        slVolume.value = 1.0
        // 슬라이더의 볼륨을 1.0으로 초기화한다.
        pvProgressPlay.progress = 0
        // 프로그레스 뷰의 진행을 0으로 초기화한다.
        
        audioPlayer.delegate = self
        // audioPlayer의 델리게이트를 self로 한다.
        audioPlayer.prepareToPlay()
        // prepareToPlay()를 실행한다.
        audioPlayer.volume = slVolume.value
        // audioPlayer의 볼륨을 방금 앞에서 초기화한 슬라이더의 볼륨 값 1.0으로 초기화한다.
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        // 오디오 파일의 재생 시간인 audioPlayer.duration 값을 convertNSTimeInterval2String 함수를 이용해 lblEndTime의 텍스트에 출력한다.
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        // lblCurrentTime의 텍스트에는 convertNSTimeInterval2String 함수를 이용해 00:00가 출력되도록 0의 값을 입력한다.
        setPlayButtons(true, pause: false, stop: false)
        // setPlayButtons 함수를 사용해 간략한 소스를 만들었다.
    }
    
    func setPlayButtons(_ play:Bool, pause:Bool, stop:Bool) {
    btnPlay.isEnabled = play
    btnPause.isEnabled = pause
    btnStop.isEnabled = stop
    // Play,Pause,Stop 버튼의 동작 여부를 설정하는 부분은 함수를 따로 만들고, 이 함수에 재생, 일시 정지 그리고 정지의 순으로 true, false 값을 주면서 각각 설정할 것이다.
    }
    
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        // 00:00 형태로 바꾸기 위해 TimeInterval 값을 받아 문자열로 돌려보내는 함수를 생성한다.
        let min = Int(time/60)
        // 재생 시간의 매개변수인 time값을 60으로 나눈 몫을 정수 값으로 변환해 상수 min 값에 초기화한다.
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        // time 값을 60으로 나눈 나머지 값을 정수 값으로 변환하여 상수 sec 값에 초기화한다.
        let strTime = String(format: "%02d:%02d", min, sec)
        // 이 두 값을 활용해 %02d:%02d 형태의 문자열로 변환하여 상수 strTime에 초기화한다.
        return strTime
        // 이 값을 호출한 함수로 돌려보낸다.
    }
    @IBAction func btnPlayAudio(_ sender: UIButton) {
        audioPlayer.play()
        // audioPlayer.play 함수를 실행해 오디오를 재생한다.
        setPlayButtons(false, pause: true, stop: true)
        // Play 버튼은 비활성화, 나머지 두 버튼은 활성화한다.
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
        // Timer.scheduledTimer 함수를 사용하여 0.1초 간격으로 타이머를 생성하도록 구현한다.
    }
    
    @objc func updatePlayTime() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        // 재생 시간인 audioPlayer.currentTime을 레이블 lblCurrentTime에 나타낸다.
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
        // 프로그레스 뷰인 pvProgress Play의 진행 상황에 audioPlayer.currentTime을 audioPlayer.duration으로 나눈 값으로 표시한다.
    }
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        setPlayButtons(true, pause: false, stop: true)
        // 일시 정지 중이므로 audioPlayer.pause 함수를 실행하고 Pause 버튼은 비활성화, 나머지 두 버튼은 활성화
    }
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        // 오디오를 정지하고 다시 재생하면 처음부터 재생해야 하므로 audioPlayer.currentTime을 0으로 한다.
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        // 재생 시간도 00:00로 초기화하기 위해 convertNSTimeInterval2String(0)을 활용한다.
        setPlayButtons(true, pause: false, stop: false)
        // 정지 상태이므로 audioPlayer.stop 함수를 실행하고 Play 버튼은 활성화, 나머지 두 버튼은 비활성화 한다. 결과를 보면 총 재생 시간은 01:55초로 표시되고, 재생 시간은 00:00로 표시된다. Play 버튼을 클릭하면 오디오가 재생되고 Play 버튼은 비활성화, 나머지 버튼은 활성화된다. Pause와 Stop 버튼도 잘 동작한다. 하지만 재생 시간은 00:00으로 변화가 없다.
        progressTimer.invalidate()
        // 타이머도 무효화한다.
    }
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
        // 화면의 슬라이더를 터치해 좌우로 움직이면 볼륨이 조절되는 동작을 구현하기 위해 슬라이더인 slVolume의 값을 오디오 플레이어의 volume 값에 대입한다.
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        progressTimer.invalidate()
        // 타이머를 무효화한다.
        setPlayButtons(true, pause: false, stop: false)
        // Play 버튼은 활성화하고 나머지 버튼은 비활성화한다. 결과를 보면 재생 시간도 제대로 표시되고 볼륨 조절도 가능하다. 그리고 오디오가 종료되면 Play,Pause,Stop 버튼이 새로 설정된다.
    }
    
    @IBAction func swRecordMode(_ sender: UISwitch) {
        if sender.isOn {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            lblRecordTime!.text = convertNSTimeInterval2String(0)
            isRecordMode = true
            btnRecord.isEnabled = true
            lblRecordTime.isEnabled = true
            // 스위치가 On이 되었을 때는 녹음 모드 이므로 오디오 재생을 중지하고, 현재 재생 시간을 00:00으로 만들고, isRecordMode의 값을 참으로 설정하고,Record 버튼과 녹음 시간을 활성화로 설정한다.
        } else {
            isRecordMode = false
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
            lblRecordTime.text = convertNSTimeInterval2String(0)
        }
        // 스위치가 On이 아닐 때, 즉 재생 모드일 때는 isRecordMode의 값을 거짓으로 설정하고, Record 버튼과 녹음 시간을 비활성화하며, 녹음 시간은 0으로 초기화한다.
        selectAudioFile()
        if !isRecordMode {
            initPlay()
        }else {
            initRecord()
        // selectAudioFile 함수를 호출하여 오디오 파일을 선택하고, 모드에 따라 초기화할 함수를 호출한다. 결과를 보면 재생은 문제 없이 진행되며 스위치가 On이 되었을 때 Play, Pause, Stop 버튼이 비활성화되고 현재 재생 시간과 총 재생 시간이 모두 00:00 으로 초기화되어 Record 버튼과 녹음 시간이 활성화된다.
        }
    }
    @IBAction func btnRecord(_ sender: UIButton) {
        if (sender as AnyObject).titleLabel??.text == "Record" {
            audioRecorder.record()
            (sender as AnyObject).setTitle("Stop", for: UIControl.State())
            // 만약에 버튼 이름이 Record 이면 녹음을 하고 버튼 이름을 Stop로 변경한다.
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
            // 녹음할 때 타이머가 작동하도록 progressTimer에 Timer.scheduledTimer 함수를 사용하는데, 0.1초 간격으로 타이머를 생성한다.
        } else {
            audioRecorder.stop()
            progressTimer.invalidate()
            // 녹음이 중지되면 타이머를 무효화한다.
            (sender as AnyObject).setTitle("Record", for: UIControl.State())
            btnPlay.isEnabled = true
            initPlay()
            // 그렇지 않으면 현재 녹음 중이므로 녹음을 중단하고 버튼 이름을 Stop으로 변경한다. Play 버튼을 활성화하고 방금 녹음한 파일로 재생을 초기화한다. 결과를 보면 스위치가 On이 되면 총 재생 시간이 00:00으로 초기화되고 Record 버튼을 클릭하면 녹음이 시작된다. 하지만 아무런 변화가 없으며 Record 버튼의 이름이 Stop으로 변경된다. Stop 버튼을 클릭하면 버튼 이름이 Record로 변경되고 총 재생 시간도 변경되는 것을 확인할 수 있다. Play,Pause,Stop 버튼도 제대로 작동한다.
        }
    }
    @objc func updateRecordTime() {
        lblRecordTime.text = convertNSTimeInterval2String(audioRecorder.currentTime)
    // 결과를 보면 스위치가 On이 되면 총 재생 시간이 00:00으로 초기화되고 Record 버튼을 클릭하면 녹음이 시작된다. 녹음이 진행되는 동안 녹음 시간도 변경된다.Stop 버튼을 클릭하면 버튼 이름이 Record로 변경되고 재생 시간도 변경되는 것을 확인할 수 있다. 그리고 녹음된 파일로 Play, Pause, Stop 버튼도 제대로 작동한다. 스위치가 Off가 되면 재생 시간이 원래 음악의 전체 시간인 01:55로 바뀌면서 원래 음악이 선택된다. 그리고 이 파일로 Play, Pause Stop 버튼도 제대로 작동한다.
    }
}

