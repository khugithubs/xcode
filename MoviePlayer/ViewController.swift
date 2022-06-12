//
//  ViewController.swift
//  MoviePlayer
//
//  Created by 김현욱 on 2022/06/09.
//

import UIKit
import AVKit
// 비디오 관련 헤더 파일을 추가한다.
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPlayInternalMovie(_ sender: UIButton) {
        // 내부 파일 mp4
        let filePath:String? = Bundle.main.path(forResource: "FastTyping", ofType: "mp4")
        // 비디오 파일명을 사용하여 비디오가 저장된 앱 내부의 파일 경로를 받아온다.
        let url = NSURL(fileURLWithPath: filePath!)
        // 앱 내부의 파일명을 NSURL 형식으로 변경한다.
        playVideo(url: url)
        }
    
    @IBAction func btnPlayExternalMovie(_ sender: UIButton) {
        // 외부 파일 mp4.
        let url = NSURL(string: "https://dl.dropboxusercontent.com/s/e38auz050w2mvud/Fireworks.mp4")!
        
        playVideo(url: url)
        // 결과를 보면 프로그램을 실행한 후 버튼을 클릭하면 비디오를 재생할 수 있다. 앱 내부 비디오 재생은 앱 내부에 복사해 놓은 비디오 파일을 직접 재생하고, 외부 링크 비디오 재생은 외부의 링크를 불러와 재생한다.
        }
    
    
    private func playVideo(url: NSURL) {
        let playerController = AVPlayerViewController()
        // AVPlayerViewController의 인스턴스를 생성한다.
        let player = AVPlayer(url: url as URL)
        // 앞에서 얻은 비디오 URL로 초기화된AVPlayer의 인스턴스를 생성한다.
        playerController.player = player
        // AVPlayerViewController의 player 속성에서 생성한 AVPlayer 인스턴스를 할당한다.
        self.present(playerController, animated: true) {
            player.play()
        // 비디오를 재생한다.
        }
    }
}

