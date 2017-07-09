//
//  ViewController.swift
//  apisample
//
//  Created by 水野祥子 on 2017/07/09.
//  Copyright © 2017年 sachiko. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

//参考:http://qiita.com/yutasuzuki/items/15682d737745acd03584
class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    // itemsをJSONの配列と定義
    var items: [JSON] = []

    let table = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新着記事"
        table.frame = view.frame // tableの大きさをviewの大きさに合わせる
        table.delegate = self
        table.dataSource = self
        view.addSubview(table) // viewにtableを乗せる
        
        var myButton = UIButton()
        myButton = UIButton(frame:  CGRect(x: 250.0, y: 580.0, width:80.0 , height: 80.0))
        myButton.addTarget(self, action: #selector(buttonTap(sender:)), for: .touchUpInside)
        myButton.backgroundColor = UIColor.red
        myButton.layer.cornerRadius = 40
        view.addSubview(myButton)
        
        //以下ひよこの内容は同じこと
        let numberWords = ["one", "two", "three"]
        for word in numberWords {
            print("🐥\(word)")
        }
       
        numberWords.forEach {word in
            print("🐥\(word)")
        }

        let listUrl = "http://qiita-stock.info/api.json";
        Alamofire.request(listUrl).responseJSON{ response in
            //もし、nilではなかったら、そのプロパティやメソッドにアクセスする。?? 0　全て一度json型に変更
            let json = JSON(response.result.value ?? 0)
            //jsonのデータを取り出しitemsに追加していく
            json.forEach{(_, data) in
                self.items.append(data)
            }
            //情報が入った時点でテーブルを更新。情報が入った状態なのでしっかり表示される。
            self.table.reloadData()
        }
        
        
//パターン2参考:http://qiita.com/nao007_smiley/items/b8df6222cfeb63c842d0
        var getJson: NSDictionary!
        
        // 抽出した"ip"を格納する変数を定義
        var jsonIp = ""
        
        // 抽出した"hostname"を格納する変数を定義
        var jsonHostname = ""
        
        // 抽出した"ip"と"hostname"を結合する変数を定義
        var jsonString = ""
        
        // API接続先
        let urlStr = "http://inet-ip.info/json"
        
        if let url = URL(string: urlStr) {
            let req = NSMutableURLRequest(url: url)
            req.httpMethod = "GET"
            let task = URLSession.shared.dataTask(with: req as URLRequest, completionHandler: { (data, resp, err) in
                
                guard let data = data, let resp = resp else {
                    return
                }
                
                //リクエストしたurl
                print(resp.url!)
                //帰ってきたdata
                print(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as Any)
                
                // 受け取ったdataをJSONパースし辞書型に変換、エラーならcatchへジャンプ
                do {
                    // dataをJSONパースし、変数"getJson"に格納
                    getJson = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    //取り出していく処理辞書型からの取り出し。
                    jsonIp = (getJson["IP"] as? String)!
                    jsonHostname = (getJson["Hostname"] as? String)!
                    
                } catch {
                    print ("json error")
                    return
                }
            })
            task.resume()
        
        }
    
    
    }
    
    // tableのcellにAPIから受け取ったデータを入れる
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableCell")
        //取れるものbegin_date、end_date,title
        cell.textLabel?.text = items[indexPath.row]["title"].string
        cell.detailTextLabel?.text = "投稿日 : \(items[indexPath.row]["send_date"].stringValue)"
        
        return cell
    }
    
    // cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func buttonTap(sender: UIButton) {
        print("ボタンが押された")
        //配列に入れていたものをからにしてから再度リロードアイテムがからなので表示はされない。
        items = []
        self.table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


