
import UIKit

class Cell: UICollectionViewCell
{
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mTitle: UILabel!
    @IBOutlet weak var mNote: UILabel!
    @IBOutlet weak var mReminder: UILabel!
    var originalPoint:CGPoint!
    var s:Float = 1
    var sd:CGFloat = 1
    override func awakeFromNib()
    {
        //mTitle.numberOfLines = 0
        self.mTitle.sizeToFit()
        self.mReminder.sizeToFit()
        //mNote.numberOfLines = 0
        self.mNote.sizeToFit()
        super.awakeFromNib()
        
        self.contentView.layer.backgroundColor = UIColor.clear.cgColor
        
        self.layer.shadowOpacity = 1.0
        
        self.layer.shadowRadius = 2
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.contentView.clipsToBounds = true
        
        self.layer.masksToBounds = false

    }

    var pan: UIPanGestureRecognizer!
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit()
    {
        self.contentView.backgroundColor = UIColor.clear
        deleteLabel1 = UILabel()
        self.insertSubview(deleteLabel1, belowSubview: self.contentView)
        deleteLabel2 = UILabel()
        self.insertSubview(deleteLabel2, belowSubview: self.contentView)
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.addGestureRecognizer(pan)
    }
    func resetViewPositionAndTransformations()
    {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: UIViewAnimationOptions(), animations:
        {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.center = self.originalPoint
            self.mView.layer.opacity = 1
            self.transform = CGAffineTransform(rotationAngle: 0)
            
        },
        completion:
        {
            success in
        })
    }
    override func prepareForReuse()
    {
        self.contentView.frame = self.bounds
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()
        if (pan.state == UIGestureRecognizerState.changed)
        {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            self.deleteLabel1.frame = CGRect(x: p.x - deleteLabel1.frame.size.width, y: 0, width: 100, height: height)
            self.deleteLabel2.frame = CGRect(x: p.x + width + deleteLabel2.frame.size.width, y: 0, width: 100, height: height)
        }
    }
    func onPan(_ pan: UIPanGestureRecognizer)
    {
        switch (pan.state)
        {
            case UIGestureRecognizerState.began:
                self.originalPoint = self.center
                break
            case UIGestureRecognizerState.changed:
                self.setNeedsLayout()
                let translation: CGPoint = pan.translation(in: self)
                let displacement: CGPoint = CGPoint.init(x: translation.x, y: translation.y)
                if displacement.x + self.originalPoint.x < self.originalPoint.x
                {
                    self.transform = CGAffineTransform.init(translationX: displacement.x, y: 0)
                    sd = (displacement.x/60)
                    s = Float(1.0 + sd)
                    self.mView.layer.opacity = s
                }
                if displacement.x + self.originalPoint.x > self.originalPoint.x
                {
                    self.transform = CGAffineTransform.init(translationX: displacement.x, y: 0)
                    sd = (displacement.x/60)
                    s = Float(1.0 - sd)
                    self.mView.layer.opacity = s
                }
                break
            case UIGestureRecognizerState.ended:
                if abs(pan.velocity(in: self).x) > 500
                {
                    self.mView.layer.opacity = 1
                    let collectionView: UICollectionView = self.superview as! UICollectionView
                    let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                    collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
                }
                else
                {
                    resetViewPositionAndTransformations()
                }
                break
            default: break
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
}
