//
//  AlbumViewController.swift
//  photobook
//
//  Created by 鈴木ましろ on 2022/06/03.
//

import UIKit
import RealmSwift

class AlbumViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tweetButton: UIButton!

    let realm = try! Realm()

    var tweets = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        getTweetData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTweetData()
    }

    // Viewの初期設定を行うメソッド
    func setUpViews() {
        tableView.delegate = self
        tableView.dataSource = self

    }

    // Realmからデータを取得してテーブルビューを再リロードするメソッド
    func getTweetData() {
        tweets = Array(realm.objects(Item.self)).reversed()  // Realm DBから保存されてるツイートを全取得
        tableView.reloadData() // テーブルビューをリロード
    }


}

extension AlbumViewController: UITableViewDelegate, UITableViewDataSource {

    // TableViewが何個のCellを表示するのか設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tweets.count
    }

    // Cellの中身を設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let tweetImageView = cell.viewWithTag(4) as? UIImageView else { return cell }

        let tweet = tweets[indexPath.row]

        if let imageFileName = tweet.imageFileName {
            let path = getImageURL(fileName: imageFileName).path // 画像のパスを取得
            if FileManager.default.fileExists(atPath: path) { // pathにファイルが存在しているかチェック
                if let imageData = UIImage(contentsOfFile: path) { // pathに保存されている画像を取得
                    tweetImageView.image = imageData
                } else {
                    print("Failed to load the image. path = ", path)
                }
            } else {
                print("Image file not found. path = ", path)
            }
        }
        return cell
    }


    // URLを取得するメソッド
    func getImageURL(fileName: String) -> URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(fileName)
    }

    // Cellのサイズを設定するデリゲートメソッド
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return tweet.imageFileName == nil ? 90 : 310
    }

}

