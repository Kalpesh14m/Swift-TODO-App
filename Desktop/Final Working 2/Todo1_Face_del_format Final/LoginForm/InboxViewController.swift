//Purpose:
    //1.Used for showing notes in inbox
    //2.Used fir showing notes in archive
    //3.Used for showing notes in reminder
    //4.Used for showing notes in delete


import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

var useremailstored:String?
var userpasswordstored:String?
var currentUserData = [NSManagedObject]()
var myData = [[String:String]]()
var myArchData = [[String:String]]()
var myTrashData = [[String:String]]()
var myRemdData = [[String:String]]()
var resultarray = [[String:String]]()
var reminderState = false
var archiveState = false
var trashState = false
var SearchState = false
var searchBarText = ""
var cell = false

class ViewController: UIViewController,
    UISearchBarDelegate,
    PopupContentViewController
{
    
//MARK: IBOutlet
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var backBtnView: UIView!
    @IBOutlet weak var mBottomView: UIView!
    
    @IBOutlet weak var ArchiveView: UIView!

    @IBOutlet weak var DeleteUndoView: UIView!
    @IBOutlet weak var deleteUndo: UIButton!
   
    @IBOutlet weak var archiveUndoView: UILabel!
    
//MARK:Variable Declaration
    var tempStore = [String:String]()
    var Gridstate = true
    var inboxPresenter = InboxViewPesenter()
    var layout : CHTCollectionViewWaterfallLayout!
    fileprivate var longPressGesture : UILongPressGestureRecognizer!
    var Indx = 0
    var indxArray = [Int]()
    var selectedIndexColor : IndexPath?
    var isSelected:Bool = false
    var isSelectCell:Bool = false
    let Menu: UIButton = UIButton()
    let SearchBtn: UIButton = UIButton()
    let TabToGrid: UIButton = UIButton()
    var archiveDataRemove = false

    @IBOutlet weak var archiveBtnClk: UIButton!
    
    //MARK: Method Declaration
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setBottomViewShadow()
        attributeSetting()
        
        inboxPresenter.fetchData(completion:
        {
            isSucces in
            if (isSucces)
            {
                self.mCollectionView.reloadData()
            }
        })
        let nib = UINib(nibName: "Cell", bundle: nil)
        self.mCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        
        NotificationChatReturn()
    }
    //ViewDidLoad Methods
    func attributeSetting()
    {
       // LoadingIndicatorView.show(self.view, loadingText: "LOADING")
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        
        ArchiveView.isHidden = true
        DeleteUndoView.isHidden = true

        mCollectionView.allowsMultipleSelection = false
        longPressGesture = UILongPressGestureRecognizer(target: self,
        action: #selector(self.handleLongGesture(_:)))
        self.mCollectionView.addGestureRecognizer(longPressGesture)
        layout = self.mCollectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout

        self.revealViewController().rearViewRevealWidth = self.view.frame.width-45
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func NotificationChatReturn()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(loadColor), name: NSNotification.Name(rawValue: "loadColor"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DeleteCell), name: NSNotification.Name(rawValue: "SelectIndex"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(colorForSelectedCell(colors :)), name: NSNotification.Name("selectedCell"), object: nil)
    }
    
    
    //Delete Button Press on view call popup
    @IBAction func deleteBtnPress(_ sender: Any)
    {
        PopupController
            .create(self)
            .customize(
                [     .layout(.mychoise5) ,
                      .animation(.slideUp),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                ]
            )
            .didShowHandler
            { _ in
                print("opened")
            }
            .didCloseHandler
            { _ in
                print("closed")
                self.indxArray.removeAll()
            }.show(PopUpDeleteVC.instance())
        
    }
    //Delete Button Press on view call popup
    @IBAction func colorBtn(_ sender: UIButton)
    {
        PopupController
            
            .create(self)
            .customize(
                [     .layout(.center) ,
                      .animation(.fadeIn),
                      .scrollable(false),
                      .backgroundStyle(.blackFilter(alpha: 0.1)),
                      .dismissWhenTaps(true)
                    
                ]
            )
            .didShowHandler
            {
                _ in
                print("opened")

            }
            .didCloseHandler
            {
                _ in
                self.indxArray.removeAll()
                print("closed")
            }
            .show(ColorPickerView.instance())

    }
    func postColorIntoFIR(color:String)
    {
        let note:[String:String] = ["color":color]
        let key = myData[(selectedIndexColor?.row)!]["key"]! as String

        let df = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        df.child("Users").child(uid!).child("Data").child(key).setValue(note)
    }
    
    func colorForSelectedCell(colors:Notification)
    {
        if let colorValue = colors.userInfo?["color"] as? String
        {
            let cell = mCollectionView.cellForItem(at: selectedIndexColor!) as! Cell
            cell.mView.backgroundColor = UIColor(hex: colorValue)
            print("COlor)()()()()()()",colorValue)
            
            mCollectionView.allowsMultipleSelection = true
            isSelectCell = false
            cell.layer.opacity = 1
            // self.postColorIntoFIR(color: (colors.userInfo?["color"] as! String))
        }

    }
    
    public func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize
    {
        return CGSize(width: 170, height: 250)
        
    }

    @IBAction func removeView(_ sender: UIButton)
    {
        mCollectionView.allowsMultipleSelection = false
        self.navigationController?.navigationBar.isHidden = false
        self.backBtnView.isHidden = true
        
        if let selection = mCollectionView.indexPathsForSelectedItems
        {
            if selection.count > 0
            {
                selection.sorted
                {
                    $1.compare($0) == .orderedAscending
                }
                for indexPath in selection
                {
                    let cell = mCollectionView.cellForItem(at: indexPath) as! Cell
                    cell.layer.opacity = 1
                    cell.isSelected = false
                }
                indxArray.removeAll()
                mCollectionView.reloadData()
            }
        }
    }
    
    
    
    func loadColor()
    {
    }
    func post(indexPath:Int)
    {
        
        let title = myData[indexPath]["title"] as AnyObject
        let note = myData[indexPath]["note"] as AnyObject
        let reminder = myData[indexPath]["reminder"] as AnyObject

        let post : [String:AnyObject] = [
            "title":title,
            "note" : note,
            "reminder" : reminder
                        ]
        let df = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        df.child("Users").child(uid!).child("Trash").childByAutoId().setValue(post)
    }

    func DeleteCell()
    {
        for item in indxArray
        {
            let post : [String:AnyObject] = [
                "title":myData[cellindex]["title"] as AnyObject,
                "note":myData[cellindex]["note"] as AnyObject,
                "reminder":myData[cellindex]["reminder"] as AnyObject
            ]
            
            let df = FIRDatabase.database().reference()
            let uid = FIRAuth.auth()?.currentUser?.uid
            df.child("Users").child(uid!).child("Delete").childByAutoId().setValue(post)
           
            let temp = myData[cellindex]
            let ref = FIRDatabase.database().reference().child("Users").child(uid!).child("Data").child(temp["rec"]!)
            myData.remove(at: cellindex)
            ref.removeValue()
            DeleteUndoView.isHidden = false
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2), execute:
            {
                    self.DeleteUndoView.isHidden = true
            })
            mCollectionView.reloadData()
        }
        mCollectionView.allowsMultipleSelection = false
        indxArray.removeAll()
        mCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        navigationBarButtons()
        setNavigationBar()
    }
  
    //Set Buttons to navigation Button
    func navigationBarButtons()
    {
       
        MenuBtnM()
        SearchBtnM()
        TabToGridBtnM()
        
        let MenuB = UIBarButtonItem(customView: Menu)
        let TabToGridB = UIBarButtonItem(customView: TabToGrid)
        let SearchB = UIBarButtonItem(customView: SearchBtn)
        
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = MenuB
        self.navigationItem.setRightBarButtonItems([TabToGridB,SearchB], animated: true)
        
        
    }
    func shadowM()
    {
        navigationController?.navigationBar.layer.masksToBounds = false
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.8
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 2
    }
    func MenuBtnM()
    {
        //set image for slidemenu button
        Menu.setImage(UIImage(named: "men"), for: UIControlState.normal)
        //Add Action
        Menu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        //set frame
        Menu.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
    }
    func SearchBtnM()
    {
        //set image for search button
        SearchBtn.setImage(UIImage(named: "search123"), for: UIControlState.normal)
        //Add Action
        SearchBtn.addTarget(self, action: #selector(ViewController.searchButtonPressed), for: UIControlEvents.touchUpInside)
        //set Frame
        SearchBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
    }
    func TabToGridBtnM()
    {
        //set image for table and collection view button
        TabToGrid.setImage(UIImage(named: "TableView"), for: UIControlState.normal)
        //add Action
        TabToGrid.addTarget(self, action: #selector(ViewController.ButtonPressed), for: UIControlEvents.touchUpInside)
        //Set Frame
        TabToGrid.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
    }
    
    
    
    
    //Set Color to navigation bar
    func setNavigationBar()
    {
        if reminderState
        {
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Reminders"
            self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 64/255, green: 88/255, blue: 104/255, alpha: 1)
            shadowM()
        }
        else
        {
            if archiveState
            {
                self.navigationItem.titleView = nil
                self.navigationItem.title = "Archive"
                self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 67/255, green: 183/255, blue: 203/255, alpha: 1)
                shadowM()
            }
            else
            {
                if trashState
                {
                    self.navigationItem.titleView = nil
                    self.navigationItem.title = "Trash"
                    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 221/255, green: 52/255, blue: 56/255, alpha: 1)
                    shadowM()
                }
                else
                {
                    self.navigationItem.titleView = nil
                    self.navigationItem.title = "Notes"
                    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 190/255, blue: 0/255, alpha: 1)
                    shadowM()
                }
            }
        }
    }
    
    @IBAction func deleteUndo(_ sender: Any)
    {
        print("DASF&*&*&&DElete Undo Clk")
    }
    
    
  
    @IBAction func archiveBtnClk(_ sender: Any)
    {
        archiveDataRemove = true
        print("DASF&*&*&&DElete Undo Clk")
        
        let df = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        print("LINK__________",tempStore)
        df.child("Users").child(uid!).child("Data").childByAutoId().setValue(tempStore)
        self.ArchiveView.isHidden = true
        mCollectionView.reloadData()
    }
    
    //Set shadow to bottom view
    func setBottomViewShadow()
    {
        mBottomView.layer.shadowColor = UIColor.black.cgColor
        mBottomView.layer.shadowOffset = CGSize.zero
        mBottomView.layer.shadowRadius = 5
        mBottomView.layer.shadowPath = UIBezierPath(rect: mBottomView.bounds).cgPath
        mBottomView.layer.shadowOpacity = 0.5
        mBottomView.clipsToBounds = true
        mBottomView.layer.masksToBounds = false
        view.bringSubview(toFront: mBottomView)
    }
    
    //Take note button is pressed
    @IBAction func notesButtonPressed(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //This method will call when you press table and collection button
    func ButtonPressed()
    {
        mCollectionView.reloadData()
        if Gridstate
        {
            self.TabToGrid.setImage(UIImage(named: "GridView"), for: UIControlState.normal)
            self.Gridstate = false
            
        }
        else
        {
            self.TabToGrid.setImage(UIImage(named: "TableView"), for: UIControlState.normal)
            self.Gridstate = true
        }
    }
    
    func searchButtonPressed()
    {
        createSearchBar()
    }
    
    func createSearchBar()
    {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.placeholder = "search here...."
        searchBar.autocapitalizationType = .none
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        SearchState = false
        setNavigationBar()
        DataBaseModels.updateData(completion:
        {
            isDone in
            if isDone
            {
                self.mCollectionView.reloadData()
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        SearchState = true
        
        resultarray.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "title contains[c] %@ OR note contains[c] %@", searchBar.text!,searchBar.text!)
        let array = (myData as NSArray).filtered(using: searchPredicate)
        resultarray = array as! [[String : String]]
        self.mCollectionView.reloadData()

        if(searchText.characters.count < 1)
        {
            searchBar.resignFirstResponder()
        }
    }
    var cellindex = 0
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer)
    {
        switch(gesture.state)
        {
            case UIGestureRecognizerState.began:
                let selectedIndexPath = self.mCollectionView.indexPathForItem(at: gesture.location(in: self.mCollectionView))
                isSelectCell = true
                self.backBtnView.isHidden = false
                self.selectedIndexColor = selectedIndexPath
                let cell = mCollectionView.cellForItem(at: selectedIndexPath!) as! Cell
                cell.layer.opacity = 0.3
               self.navigationController?.navigationBar.isHidden = true
            
                let b = gesture.location(in: self.mCollectionView)
                let indexPath = self.mCollectionView.indexPathForItem(at: b)
                cellindex = (indexPath?.row)!
                
        
                
                
                mCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath!)
        
        
        case UIGestureRecognizerState.changed:
            mCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            mCollectionView.reloadData()
            self.navigationController?.navigationBar.isHidden = false
            
        case UIGestureRecognizerState.ended:
            mCollectionView.endInteractiveMovement()
            
        default:
            mCollectionView.cancelInteractiveMovement()
        }
    }
    
    //set label height
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    func numberOfCoulom() -> Int
    {
        if Gridstate
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    func sectionInsets() -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension ViewController : CHTCollectionViewDelegateWaterfallLayout
{
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        let note:String?
        let tittle:String?
        var reminder:String?
        if Gridstate
        {
            let labelWidth = (self.mCollectionView.bounds.width-(self.sectionInsets().left+self.sectionInsets().right+layout.minimumColumnSpacing))/2
            
            if reminderState
            {
                note = myRemdData[indexPath.row]["note"]
                tittle = myRemdData[indexPath.row]["title"]
            }
            else
            {
                if archiveState
                {
                    note = myArchData[indexPath.row]["note"]
                    tittle = myArchData[indexPath.row]["title"]
                }
                else if trashState
                {
                    note = myTrashData[indexPath.row]["note"]
                    tittle = myTrashData[indexPath.row]["title"]
                }
                else
                {
                     note = myData[indexPath.row]["note"]
                     tittle = myData[indexPath.row]["title"]
                     reminder = myData[indexPath.row]["reminder"]
                }
            }
            let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
            let noteHeight = self.heightForView(text: (note)!, font: (labelFont)!, width:labelWidth)
            let tittleHeight = self.heightForView(text: tittle!, font: labelFont!, width:labelWidth)
            let totalHeight = noteHeight+tittleHeight
            if reminder == ""
            {
                return CGSize(width: labelWidth, height: totalHeight+20)
            }
            else
            {
                return CGSize(width: labelWidth, height: totalHeight + 40)
            }
        }
        else
        {
            if reminderState
            {
                note = myRemdData[indexPath.row]["note"]
                tittle = myRemdData[indexPath.row]["title"]
            }
            else
            {
                if archiveState
                {
                    note = myArchData[indexPath.row]["note"]
                    tittle = myArchData[indexPath.row]["title"]
                }
                else if trashState
                {
                    note = myTrashData[indexPath.row]["note"]
                    tittle = myTrashData[indexPath.row]["title"]
                }
                else
                {
                    note = myData[indexPath.row]["note"]
                    tittle = myData[indexPath.row]["title"]
                }
            }
            let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
            let noteHeight = self.heightForView(text: note!, font: labelFont!, width:(view.bounds.width - 40))
            let tittleHeight = self.heightForView(text: tittle!, font: labelFont!, width:(view.bounds.width - 40))
            let totalHeight = (noteHeight+40)+tittleHeight
            if reminder == ""
            {
                return CGSize(width: (view.bounds.width - 40), height: totalHeight-20)
            }
            else
            {
                  return CGSize(width: (view.bounds.width - 40), height: totalHeight)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if reminderState
        {
            return myRemdData.count
        }
        else
        {
            if SearchState
            {
                return resultarray.count
            }
            else
            {
                if archiveState
                {
                    return myArchData.count
                }
                else if trashState
                {
                    return myTrashData.count
                }
                else
                {
                    return myData.count
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.mView.layer.cornerRadius = 8
        cell.contentView.layer.cornerRadius = 8
        if reminderState
        {
            cell.mTitle.text = myRemdData[indexPath.row]["title"]
            cell.mNote.text = myRemdData[indexPath.row]["note"]
            cell.mReminder.text = myRemdData[indexPath.row]["reminder"]
        }
        else
        {
            if SearchState
            {
                cell.mTitle.text = resultarray[indexPath.row]["title"]
                cell.mNote.text = resultarray[indexPath.row]["note"]
            }
            else
            {
                if archiveState
                {
                    cell.mTitle.text = myArchData[indexPath.row]["title"]
                    cell.mNote.text = myArchData[indexPath.row]["note"]
                    cell.mReminder.text = myArchData[indexPath.row]["reminder"]
                }

                else if trashState
                {
                    cell.mTitle.text = myTrashData[indexPath.row]["title"]
                    cell.mNote.text = myTrashData[indexPath.row]["note"]
                    cell.mReminder.text = myTrashData[indexPath.row]["reminder"]
                }
                else
                {
                    cell.mTitle.text = myData[indexPath.row]["title"]
                    cell.mNote.text = myData[indexPath.row]["note"]
                    cell.mReminder.text = myData[indexPath.row]["reminder"]
//            if let rem = myData[indexPath.row]["reminder"]
//            {
//                if rem.characters.count > 0
//                {
//                    cell.mReminder.backgroundColor = UIColor.lightGray
//                    cell.mReminder.text = rem
//                }
//                else
//                {
//                    cell.mReminder.backgroundColor = UIColor.clear
//                }
//            }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?)
    {
        let post : [String:AnyObject] = ["title":myData[indexPath.row]["title"] as AnyObject,"note":myData[indexPath.row]["note"] as AnyObject,"reminder":myData[indexPath.row]["reminder"] as AnyObject]
        let df = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        df.child("Users").child(uid!).child("Archive").childByAutoId().setValue(post)
        let temp = myData[indexPath.row]
        tempStore = myData[indexPath.row]
        print("ASDFASDFAS:F:::ASDF:AS:DF:SD",tempStore)
        let ref = FIRDatabase.database().reference().child("Users").child(uid!).child("Data").child(temp["rec"]!)
        myData.remove(at: indexPath.row)
        ArchiveView.isHidden = false
        ref.removeValue()
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 5), execute:
        {
            self.ArchiveView.isHidden = true
        })
        mCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
         let temp = myData.remove(at: sourceIndexPath.item)
         myData.insert(temp, at: destinationIndexPath.item)
       // self.mCollectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if isSelected
        {
        let cell = mCollectionView.cellForItem(at: indexPath) as! Cell
//        if indxArray.contains(indexPath.row)
//        {
//            let location = indxArray.index(of: indexPath.row)
//            indxArray.remove(at: location!)
//            print("&&&&&&&",indxArray)
//            cell.layer.opacity = 1
//            
//        }
        cell.layer.opacity = 1
        cell.isSelected = false
            
        }
    }
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if(isSelectCell == true)
        {
            mCollectionView.allowsMultipleSelection = true
            let cell = mCollectionView.cellForItem(at: indexPath) as! Cell
            cell.isSelected = true
            cell.layer.opacity = 0.3
            Indx = indexPath.row
            print("@@@@@@@@@@",Indx)
            
            indxArray.append(indexPath.row)
            print("########",indxArray)
        }
        else
        {
            let vc:NotesViewController = storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
            //vc.modalPresentationStyle =
           // vc.modalTransitionStyle = .crossDissolve
            vc.mTitleTextFieldData = myData[indexPath.row]["title"]
            vc.mNotesTextViewData = myData[indexPath.row]["note"]
            vc.mReminderData = myData[indexPath.row]["reminder"]
            vc.mKey = currentUserData[indexPath.row].value(forKey: "key") as? String
            vc.mUpdate = true
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
        cell = true
    }


    
    

}
