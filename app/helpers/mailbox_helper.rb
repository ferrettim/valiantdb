module MailboxHelper

  def unread_messages_count
    # how to get the number of unread messages for the current user
    # using mailboxer
    mailbox.inbox(:unread => true).count
    #current_user.mailbox.receipts.where(is_read:false).count
  end

end
