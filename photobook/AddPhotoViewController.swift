//
//  AddPhotoViewController.swift
//  photobook
//
//  Created by 鈴木ましろ on 2022/06/03.
//

import Foundation
import UIKit
import RealmSwift

class AddPhotoViewController: UIViewController {
        
        @IBOutlet var imageButton: UIButton!
        @IBOutlet var tweetTextFeild: UITextField!
        
        let realm = try! Realm()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setUpViews()
        }
        
        // Viewの初期設定を行うメソッド
        func setUpViews() {

            imageButton.imageView?.contentMode = .scaleAspectFill
        }
        
        // キャンセルボタンを押したときのアクション
        @IBAction func didTapCancelButton() {
            self.dismiss(animated: true)
        }
        
        // ツイートボタンを押したときのアクション
        @IBAction func didTapTweetButton() {
            
            saveTweet()
            self.dismiss(animated: true)
        }
        
        // ツイートを保存するメソッド
        func saveTweet() {

            let tweet = Item()
            
            // 画像がボタンにセットされてたら画像も保存
            if let tweetImage = imageButton.backgroundImage(for: .normal){
                let imageURLStr = saveImage(image: tweetImage) //画像を保存
                tweet.imageFileName = imageURLStr
            }
            
            try! realm.write({
                realm.add(tweet) // レコードを追加
            })
        }
        
        // 画像を保存するメソッド
        func saveImage(image: UIImage) -> String? {
            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return nil }
            
            do {
                let fileName = UUID().uuidString + ".jpeg" // ファイル名を決定(UUIDは、ユニークなID)
                let imageURL = getImageURL(fileName: fileName) // 保存先のURLをゲット
                try imageData.write(to: imageURL) // imageURLに画像を書き込む
                return fileName
            } catch {
                print("Failed to save the image:", error)
                return nil
            }
        }
        
        // URLを取得するメソッド
        func getImageURL(fileName: String) -> URL {
            let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return docDir.appendingPathComponent(fileName)
        }
        
        // 画像選択ボタンを押したときのアクション
        @IBAction func didTapImageButton() {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            present(imagePickerController, animated: true)
        }
        
    }


    extension AddPhotoViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        // ライブラリから戻ってきた時に呼ばれるデリゲートメソッド
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return picker.dismiss(animated: true) }
            imageButton.setBackgroundImage(pickedImage, for: .normal) // imageButtonのバックグラウンドに選択した画像をセット
            picker.dismiss(animated: true)
        }
    }
