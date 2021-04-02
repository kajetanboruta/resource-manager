require 'roo'

module Api
  module V1
    class LeadsImportController < ApplicationController
      p = []
      xlsx = Roo::Spreadsheet.open('./text.xlsx')
      xlsx.each do |row|
        p << row
      end
    end
  end
end