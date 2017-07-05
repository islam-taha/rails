class ActiveVault::Attached::Many < ActiveVault::Attached
  delegate_missing_to :attachments

  def attachments
    @attachments ||= ActiveVault::Attachment.where(record_gid: record.to_gid.to_s, name: name)
  end

  def attach(*attachables)
    @attachments = attachments | Array(attachables).flatten.collect do |attachable|
      ActiveVault::Attachment.create!(record_gid: record.to_gid.to_s, name: name, blob: create_blob_from(attachable))
    end
  end

  def attached?
    attachments.any?
  end

  def purge
    attachments.each(&:purge)
    @attachments = nil
  end
end
