//
//  AddViewController.swift
//  Table
//
//  Created by 김현욱 on 2022/06/04.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet var tfAddItem: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        items.append(tfAddItem.text!)
        // items에 텍스트 필드의 텍스트 값을 추가한다.
        itemsImageFile.append("clock.jpeg")
        // itemsImageFile에는 무조건 clock.jpeg 파일을 추가한다.
        tfAddItem.text=""
        // 텍스트 필드의 내용을 지운다.
        _ = navigationController?.popViewController(animated: true)
        // 루트 뷰 컨트롤러, 즉 테이블 뷰로 돌아간다. 결과를 보면 +를 클릭하면 Add View로 이동하고, 텍스트 필드에 내용을 입력한 후 Add 버튼을 클릭하면 다시 Main View로 돌아오지만 아직 내용이 추가되지 않는다.
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
