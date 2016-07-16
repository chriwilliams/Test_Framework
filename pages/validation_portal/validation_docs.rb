require_relative '../common/base_page'
require_relative 'sections'

module ValidationPortal
  class ValidationDocs < Common::BasePage

    section :header, Header, '#header'
    section :navigation, Navigation, '#navigation'

    element :file_field, 'input[id=validation_doc_file]'
    element :left_nav, 'div[class=left-rail]'
    element :new_doc, 'div[id=new_document]'
    element :release, 'a#release_version'
    element :edit_version, 'a#edit_project'
    element :delete_version, 'a#delete_version'
    element :modal, 'div[class=modal-dialog]'
    element :note_to_file, 'a#note_to_file'
    element :document_actions_btn, '#document-actions-btn'
    element :replace_doc_link, '#replace_document'
    element :remove_doc_link, '#remove_document'
    element :remove_modal_btn, '#remove-modal-link'

    set_url_matcher '/validation_docs/'

    # selects a validation document
    # @param name [string] the project name
    def val_doc_select(name)
      link = left_nav.find(:css, 'a', text: "#{name}")
      link.click
    end

    # uploads a file to a category
    # @param file_path [string] the path and file name you want to upload
    def file_upload_to_portal(file_path)
      bootstrap_attach_file(file_path, '#validation_doc_file')
      upload = new_doc.find('button[id=upload-file]')
      upload.click
    end

    # clicks the release button
    def release_click
      release.click
    end

    # clicks edit version button
    def edit_version_click
      edit_version.click
    end

    # clicks delete version button
    def delete_version_click
      delete_version.click
    end

    # deletes a version
    def version_delete
      delete = modal.find('a[data-method=delete]')
      delete.click
    end

    # releases a version
    # @param git_ref [string] the Git reference tag or SHA-1
    def version_release(git_ref = nil)
      unless git_ref.nil?
        reference = modal.find('input[id=release_git_reference]')
        reference.set(git_ref)
      end
      release = modal.find('input[type=submit]')
      release.click
    end

    # replaces the current document with the one provided in file path
    # @param file_path [string] absolute path of the file replacing the current document
    def document_replace(file_path)
      document_actions_btn.click
      replace_doc_link.click
      bootstrap_attach_file(file_path, '#validation_doc_file')
      upload = modal.find('button[id=upload-file]')
      upload.click
    end

    # removes the document
    def document_remove
      document_actions_btn.click
      remove_doc_link.click
      remove_modal_btn.click
    end

    # adds a note to file to a Validation Document
    def note_to_file_add(file_path, title = nil)
      note_to_file.click
      unless title.nil?
        title_box = modal.find('input[id=validation_doc_title]')
        title_box.set title
      end
      bootstrap_attach_file_to_modal(file_path, '#validation_doc_file')
      upload = modal.find('#upload-file')
      upload.click
    end

  end
end
