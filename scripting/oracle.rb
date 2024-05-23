# frozen_string_literal: true

# Install Oracle Client for ruby-oci8
# NOTE: LD_LIBRARY_PATH needs to be exported in .zshrc
FileUtils.mkdir_p('/opt/oracle')
Dir.chdir('/opt/oracle') do
  bash('wget https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-basic-linux.x64-21.12.0.0.0dbru.zip')
  bash('wget https://download.oracle.com/otn_software/linux/instantclient/2112000/instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip')
  bash('unzip instantclient-basic-linux.x64-21.12.0.0.0dbru.zip')
  bash('unzip instantclient-sdk-linux.x64-21.12.0.0.0dbru.zip')
end
