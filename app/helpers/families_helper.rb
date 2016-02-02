require 'csv'
require 'iconv'

module FamiliesHelper
    public
    def self.handle_csv_file root_name, file, action_name
        filepath = get_path(root_name, action_name)
        File.new(filepath, File::CREAT|File::TRUNC|File::RDWR, 0644).path
        FileUtils.cp file.tempfile, filepath
        File.delete(file.tempfile.path)
    end

    def self.parse_csv_file root_name, action_name
        csv_file_parser File.open(get_path(root_name, action_name))
    end

    private
    def self.get_path root_name, action_name
        expected_path = "tmp/upload_content/"
        Dir.mkdir(expected_path) unless File.exists?(expected_path)
        expected_path = "tmp/upload_content/#{root_name}"
        Dir.mkdir(expected_path) unless File.exists?(expected_path)
        "#{expected_path}/#{action_name}"
    end

    def self.csv_file_parser file
        csv_arr = CSV.read(file.path, :row_sep => :auto, :col_sep => ";")
        header =  csv_arr[0]
        data_rows = []
        (1..csv_arr.size - 1).each do |i|
            row = Hash[[header, csv_arr[i]].transpose]
            data_rows << row
        end
        data_rows
    end
end
