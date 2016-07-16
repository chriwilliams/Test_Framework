require_relative 'base_page'

module Common
  module ModalDialog

    class Modal < Common::BasePage
      attr_reader :container
    end

    class AlertDialog < Modal
      attr_reader :title, :description

      def initialize(container, title, description = nil)
        @container = container
        @title = title
        @description = description
      end

      # Method: verify_alert, verifies title and modal description statement
      def verify_alert
        raise MIST::NotFound, "Unable to find Title \"#{@title}\" in modal" unless page.has_content? @title if @title
        raise MIST::NotFound, "Unable to find Statement \"#{@description}\" in modal" unless page.has_content? @description if @description
      end

      # Method: exit_alert, closes modal with chosen button
      def exit_alert(button = nil)
        raise StandardError, "Method has not been implemented" unless button
        self.verify_alert
        within @container do
          click_button button.capitalize
        end
      end

    end

    class ChoiceDialog < AlertDialog
      attr_reader :button

      def initialize(container, title, button = 'Yes', description = nil)
        super(container, title, description)
        @button = button
      end

      # Method, exit_alert, overrides AlertDialog.exit_alert
      def exit_alert(button = @button)
        super
      end
    end

    class InputDialog < ChoiceDialog
      attr_reader :message, :object

      def initialize(container, title, object, message, button = 'Save', description = nil)
        super(container, title, button, description)
        @message = message
        @object = object
      end

      # Method, exit_alert, overrides AlertDialog.exit_alert
      def exit_alert
        self.verify_alert
        within @container do
          fill_in @object, with: @message if @message
          click_button @button.capitalize
        end
      end
    end

  end
end

