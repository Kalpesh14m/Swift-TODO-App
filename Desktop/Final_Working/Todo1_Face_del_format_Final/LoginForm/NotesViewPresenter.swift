//  NotesViewPresenter.swift
//Purpose:
    //1.Used for Pass data to model for validation.


import Foundation

class NotesViewPresenter
{
    var notesModel = NotesViewModel()

    func ButtonPressed(mTitleTextField:String,mNotesTextView:String,mReminder:String,completion:@escaping (_ result:Bool)->Void)
    {
        notesModel.ButtonPressed(mTitleTextField: mTitleTextField, mNotesTextView: mNotesTextView,mReminder:mReminder,completion: {
            isSucces in
            
            if (isSucces)
            {
                completion(true)
            }
            else
            {
                completion(false)
            }
            
        })
    }
    func update(mTitleTextField:String,mNotesTextView:String,mReminder:String,mKey:String,completion:@escaping (_ result:Bool)->Void)
    {
        notesModel.mupdate(mTitleTextField: mTitleTextField, mNotesTextView: mNotesTextView,mKey:mKey,mReminder:mReminder,completion: {
            isSucces in
            
            if (isSucces)
            {
                completion(true)
            }
            else
            {
                completion(false)
            }
            
        })
    }
}
