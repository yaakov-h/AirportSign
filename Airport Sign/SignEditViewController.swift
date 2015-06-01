import UIKit

protocol SignEditViewControllerDelegate : class {
	func getExistingText(controller: SignEditViewController) -> String
	func controller(controller: SignEditViewController, didFinishedEditingWithText text: String)
	func controllerDidCancelEditing(controller: SignEditViewController)
}

class SignEditViewController: UIViewController {
	
	weak var delegate : SignEditViewControllerDelegate?
	@IBOutlet weak var textView : UITextView?
	@IBOutlet weak var heightAdjustmentView : UIView?
	@IBOutlet weak var heightAdjustmentBottomConstraint : NSLayoutConstraint?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if
			let textView = textView,
			let delegate = delegate
		{
			textView.text = delegate.getExistingText(self)
		}
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	@IBAction func done(sender: AnyObject) {
		if
			let delegate = delegate,
			let textView = textView
		{
			delegate.controller(self, didFinishedEditingWithText: textView.text)
		}
	}
	
	@IBAction func cancel(sender: AnyObject) {
		if let delegate = delegate {
			delegate.controllerDidCancelEditing(self)
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		self.heightAdjustmentBottomConstraint?.constant = 0
		self.view.updateConstraintsIfNeeded()
		self.view.layoutIfNeeded()
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		if
			let userInfo = notification.userInfo,
			let frameValue = userInfo[UIKeyboardFrameEndUserInfoKey as NSString] as? NSValue
		{
			let frame = frameValue.CGRectValue()
			let keyboardFrameRelativeToView = self.view.convertRect(frame, fromView: self.view.window)
			self.heightAdjustmentBottomConstraint?.constant = CGRectGetHeight(self.view.bounds) - keyboardFrameRelativeToView.origin.y
			self.view.updateConstraintsIfNeeded()
			self.view.layoutIfNeeded()
		}
	}
}
