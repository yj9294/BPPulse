# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BPPulse' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BPPulse
pod 'GoogleMobileAdsMediationPangle'
pod 'GoogleMobileAdsMediationMintegral'
end

post_install do |installer|
  resources_scripts = Dir["Pods/Target Support Files/*/*-resources.sh"]
  resources_scripts.each do |script|
    text = File.read(script).gsub('realpath -mq', 'python3 -c "import os,sys; print(os.path.realpath(sys.argv[1]))"')
    File.write(script, text)
  end
end
