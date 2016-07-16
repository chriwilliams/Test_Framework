require_relative '../common/base_page'
require_relative 'sections'

module Coder
  class SegmentManagement < Common::BasePage
    section :header, Header, 'div.master-header'
    section :footer, Footer, '#masterfooter'
    section :navigation, Navigation, '#navbar'

    element :enroll_segment, 'input[id*= "gridSegments_DXEditor1_I"]'
    element :check_mark, 'table[id*=Segments_DXEditingRow] > tbody > tr > td img:nth-child(1)'
    element :add_new, '[id$=LnkAddNewgridSegments] > b > i'
    element :message, 'span[class="HeaderSpan"]'

    # enrolls a segment (study group in iMedidata) to coder
    # @param segment [String]. Pass in the created study group which is not already enrolled in coder.
    def add_new_segment(segment)
      add_new.click
      enroll_segment.set segment
      page.first('.dxgvCommandColumnItem_Main_Theme').click
      raise 'You tried to add a study group with does not exist in iMedidata' if message.text.include? 'Study Group does not exist in iMedidata'
    end

  end
end


