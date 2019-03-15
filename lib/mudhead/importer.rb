module Mudhead
  class Importer
    attr_reader :resource, :options, :result, :csv_file
    attr_accessor :chunk, :chunks, :headers

    OPTIONS = [
      :batch_size,
      :before_batch_import,
      :excluded_id
    ]

    def initialize(resource, csv_file, options = {})
      @resource = resource
      @csv_file = csv_file
      assign_options(options)
    end

    def import_result
      @import_result ||= ImportResult.new
    end

    def import
      process_file
      import_result
    end

    def batch_replace(header_key, options)
      chunk.map! do |line|
        from = line[header_key]
        line[header_key] = options[from] if options.key?(from)
        line        
      end
    end

    protected

    def cycle batch
      @chunk = batch
      import_result.add(batch_import, @chunk.length)      
    end

    def process_file
      lines = []
      batch_size = options[:batch_size].to_i
      # spreadsheet = CSV.table('raw_files/dim_client.csv', { :headers => true })
      SmarterCSV.process(@csv_file.path, @smart_options) do |chunk|
        cycle(chunk)
      end
    end

    def batch_import
      batch_result = nil
      ActiveRecord::Base.connection.reconnect!
      @resource.transaction do
        run_callback(:before_batch_import)
        batch_added = to_be_added
        batch_headers = prepare_headers
        batch_result = @resource.import(batch_headers, batch_added, :validate => true)
        raise ActiveRecord::Rollback if batch_result.failed_instances.any?
      end
      batch_result
    end

    def to_be_added
      chunk.reject { |e| e.has_key?(@header_key) }
    end

    def prepare_headers
      @headers = chunk.map { |e| e.keys }.uniq.first
      @headers.delete(@options[:excluded_id])
      @headers
    end

    def run_callback name
      options[name].call(self) if options[name].is_a?(Proc)
    end

    def assign_options options
      @options = {
        :batch_size => 1000
      }.merge(options.slice(*OPTIONS))
      smart_options
    end

    def smart_options
      @smart_options = {
        :strip_chars_from_headers => /[\-"]/,
        :chunk_size => 1000,
        :remove_unmapped_keys => true,
        :verbose => true
      }
    end
  end
end