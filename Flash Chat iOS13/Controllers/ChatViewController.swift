//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        //        tableView.delegate = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener( { querySnapshot, error in
                
            self.messages = []
            if let e = error {
                print("there was an issue retrieving data from firestore. \(e)")
            } else {
                
                //            querySnapshot?.documents[0].data()[K.FStore.senderField]
                if let snapshotDocument = querySnapshot?.documents
                {
                    for doc in snapshotDocument {
                        let data = doc.data()
                        print (doc)
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                        
                    }
                }
            }
            
        })
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField : messageSender,
                K.FStore.bodyField : messageBody,
                K.FStore.dateField : Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print("There was an issue while saving data to firestore, \(e)")
                } else {
                    print("Successfully Saved data")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        if #available(iOS 14.0, *) {
//            var content = UIListContentConfiguration()
//            var content = cell.defaultContentConfiguration()
//            content.textProperties.color = .white
//            content.text = messages[indexPath.row].body
//            print(indexPath.row)
//            cell.contentConfiguration = content
            let message = messages[indexPath.row]
            if message.sender == Auth.auth().currentUser?.email {
                
                cell.rightImageView.isHidden = false
                cell.leftImageView.isHidden = true
                cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
                cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
            } else {
                cell.leftImageView.isHidden = false
                cell.rightImageView.isHidden = true
                cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
                cell.label.textColor = UIColor(named: K.BrandColors.blue)
            }
            cell.label.text = message.body
        }
        
        else {
//             Fallback on earlier versions
            cell.label.text = "This is a cell"
        }
        return cell
    }
    
}

extension ChatViewController : UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("\(indexPath.row)")
//    }
}
