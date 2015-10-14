require 'rubygems'
require 'aws-sdk'

bucket_name = 'gridx-modeling-data';
file_dir = '/PG&E'

Dir.glob(file_dir + '/**/*.pdf') do |file_name|
#Dir.foreach(file_dir) do |file_name|
  #puts(file_name)
  next if file_name == '.' || file_name == '..'
    key = file_name
     
    # Get an instance of the S3 interface.
    s3 = Aws::S3::Resource.new(region:'us-west-1')
    fn = file_name.dup
    fn[0] = ''
    
    puts(fn)
    puts(key)
    
    obj = s3.bucket(bucket_name).object(fn)
    #puts(key)
    
    
    #puts(fn)
    obj.upload_file(key, :server_side_encryption => 'aws:kms')
       
end

