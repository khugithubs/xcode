//
//  DetailViewController.swift
//  Table
//
//  Created by 김현욱 on 2022/06/04.
//

import UIKit

class DetailViewController: UIViewController {

    var receiveItem = ""
    // Main View에서 받을 텍스트를 위해 변수 receive Item를 선언한다.
    @IBOutlet var lblItem: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblItem.text = receiveItem
        // 뷰가 노출될 때마다 이 내용을 레이블의 텍스트로 표시한다.
    }
    
    func receiveItem(_ item: String)
    // Main View에서 변수를 받기 위한 함수를 추가한다.
    {
        receiveItem = item
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
