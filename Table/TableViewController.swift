//
//  TableViewController.swift
//  Table
//
//  Created by 김현욱 on 2022/06/04.
//

import UIKit


var items = ["책 구매", "철수와 약속", "스터디 준비하기"]
// 외부 변수인 items의 내용을 책 구매, 철수와 약속, 스터디 준비하기로 지정
var itemsImageFile = ["cart.jpeg", "clock.jpeg", "pencil.jpeg"]
// 외부 변수인 카트, 클락, 팬슬
class TableViewController: UITableViewController {

    @IBOutlet var tvListView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.leftBarButtonItem = self.editButtonItem
        // 이미 add버튼이 있으니 edit 버튼은 왼쪽에 추가한다. right를 left로 수정한다. 결과를 보면 edit 버튼을 클릭하면 왼쪽에 붉은 원이 나타난다. 붉은 원 버튼을 클릭하면 삭제 버튼이 나오고 클릭하면 삭제된다.
    }

    override func viewWillAppear(_ animated: Bool) {
        tvListView.reloadData()
    }
    // 추가된 내용을 목록으로 불러들인다. 다시 앱을 실행하면 이제는 내용이 제대로 추가된 것을 확인할 수 있다.
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        // 테이블 안에 섹션이 한 개 이므로 numberofsections의 리턴 값을 1로 한다.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
        // 섹션당 열의 개수는 items의 개수이므로 int 함수의 리턴 값을 items.count로 한다.
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.textLabel?.text = items[(indexPath as NSIndexPath).row]
        // 셀의 텍스트 레이블 앞에서 선언한 items을 대입한다. 그 내용은 책 구매, 철수와 약속, 스터디 준비하기 이다.
        cell.imageView?.image = UIImage(named: itemsImageFile[(indexPath as NSIndexPath).row])
        // 셀의 이미지 뷰에 앞에서 선언한 itemsimageFile("cart.png","clock.png","pencil.png")를 대입한다.
        
        return cell
        // 아직 Detail View 와 Add View는 아무런 동작도 하지 않는다.
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: (indexPath as NSIndexPath).row)
            itemsImageFile.remove(at: (indexPath as NSIndexPath).row)
            // 선택한 셀을 삭제하는 코드 삽입 후 목록 삭제 결과를 보면 한 셀을 왼쪽으로 밀면 Delete 버튼이 나타나 이를 클릭하면 항목이 사라진다.
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
        // Delete 대신 한글인 삭제로 바꿔준다.
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath)  {
        let itemToMove = items[(fromIndexPath as NSIndexPath).row]
        //이동할 아이템의 위치를 itemToMove에 저장한다.
        let itemImageToMove = itemsImageFile[(fromIndexPath as NSIndexPath).row]
        // 이동할 아이템의 이미지를 itemImageToMove에 저장한다.
        items.remove(at: (fromIndexPath as NSIndexPath).row)
        // 이동할 아이템을 삭제한다. 이때 삭제한 아이템 뒤의 아이템들의 인덱스가 재정렬된다.
        itemsImageFile.remove(at: (fromIndexPath as NSIndexPath).row)
        // 이동할 아이템의 이미지를 삭제한다. 이때 삭제한 아이템 이미지 뒤의 아이템 이미지들의 인덱스가 재정렬된다.
        items.insert(itemToMove, at: (to as NSIndexPath).row)
        // 삭제된 아이템을 이동할 위치로 삽입한다. 또한 삽입한 아이템 뒤의 아이템들의 인덱스가 재정렬된다.
        itemsImageFile.insert(itemImageToMove, at: (to as NSIndexPath).row)
        // 삭제된 아이템의 이미지를 이동할 위치로 삽입한다. 또한 삽입한 아이템 이미지 뒤의 아이템 이미지들의 인덱스가 재정렬된다. 결과를 보면 오른쪽에 있던 버튼이 순서 바꾸기 버튼으로 바뀌는 것을 확인할 수 있다. 옮기고 싶은 목록을 끌어다 놓고 Done 버튼을 클릭해 저장하면 된다.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "sgDetail" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tvListView.indexPath(for: cell)
            let detailView = segue.destination as! DetailViewController
            detailView.receiveItem(items[((indexPath! as NSIndexPath).row)])
            // 세그웨이를 이용하여 뷰를 전환하는것에 TableViewCell의 indexPath를 구하는 부분을 추가했다. 결과를 보면 다시 실행 버튼을 클릭하고 목록 중에서 하나를 클릭하면 Detail View로 전환되며 내용이 출력된다.
        }
    }
    

}
