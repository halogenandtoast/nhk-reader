module BufferUtils
  DEFAULT_ENCODING = "UTF-8"
  BOM = "\xEF\xBB\xBF".force_encoding(DEFAULT_ENCODING)

  def self.strip_byte_order_marker(string)
    string.force_encoding(DEFAULT_ENCODING).sub(BOM, "")
  end

  def self.no_output
    begin
      original_stderr = $stderr.clone
      original_stdout = $stdout.clone
      $stderr.reopen(File.new('/dev/null', 'w'))
      $stdout.reopen(File.new('/dev/null', 'w'))
      retval = yield
    rescue Exception => e
      $stdout.reopen(original_stdout)
      $stderr.reopen(original_stderr)
      raise e
    ensure
      $stdout.reopen(original_stdout)
      $stderr.reopen(original_stderr)
    end
    retval
  end
end
